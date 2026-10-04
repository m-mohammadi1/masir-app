import '/core/feedback/masir_feedback.dart';
import 'dart:math' as math;

import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_outline_course_model.dart';
import 'package:mohammad/features/main/domain/entities/outline_course.dart';
import 'package:mohammad/features/main/data/models/request_subscribe_course_model.dart';
import 'package:mohammad/features/main/presentation/bloc/outline_course/outline_course_bloc.dart';
import 'package:mohammad/features/main/presentation/bloc/subscribe_course/subscribe_course_bloc.dart';
import 'package:mohammad/features/main/presentation/page/outline/roadmap/paper_theme.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page_args.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/institute_themed.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/icon_tile.dart';
import '/widgets/masir_card.dart';
import '/widgets/masir_motion.dart';
import '/widgets/masir_page.dart';
import '/widgets/pill_chip.dart';
import '/widgets/progress_pill.dart';
import '/widgets/unit_kit/unit_type_style.dart';
import '/widgets/state_view.dart';

// ---------------------------------------------------------------------------
// ARCHITECTURE NOTE
//
// Earlier iterations built this roadmap out of many independent widgets
// (one CustomPaint per module bridge, per path bridge, per zigzag) that each
// guessed a neighbor's on-screen X position from their *own* local width and
// padding. Any mismatch between two widgets' assumptions — different insets,
// text wrapping to an extra line, a rounding difference — broke the visual
// connection between them. That's why lines kept looking disjointed however
// many one-off fixes were applied.
//
// This version renders the *entire* course as a single flat list of
// waypoints (chapter → path → units → path → … → trophy → chapter → …),
// computes every waypoint's (x, y) center exactly once, then draws the whole
// trail with one CustomPainter and lays every node out with one Stack using
// those same numbers. The line and the markers are mathematically
// guaranteed to agree, because they read from the same source of truth.
// ---------------------------------------------------------------------------

/// Horizontal inset for zigzag unit nodes (fraction of the canvas width).
/// Kept moderate (not 0.5) so the route still zigzags, but gentle enough
/// that a thick trail reads as a winding path rather than a coiling snake.
const double _kRoadSideRatio = 0.30;
const double _kRoadNodeSize = 64;

/// Horizontal inset of the trail canvas inside the page. The zigzag geometry
/// is a fraction of the canvas width, so this must not change.
const double _kCanvasInset = 12;

/// Width of a unit's slot: wide enough for its caption pill, centred on the
/// unit's trail line.
double _unitSlotWidth(double canvasWidth) =>
    (canvasWidth * 0.44).clamp(80.0, 130.0);

// Fixed vertical space reserved for each waypoint type. Generous on
// purpose — text is always capped with `maxLines` + ellipsis, so these are
// safe upper bounds, not tight fits, and there's no risk of the guessed
// height ever being too small for the actual content.
//
// Chapters are plain full-width title plates, not trail markers — they sit
// on the timeline (so the trail still flows from one chapter into the
// next) but never zigzag and never compete visually with the real
// waypoints, which are paths and units.
const double _kChapterNodeHeight = 76;
const double _kPathNodeHeight = 118;
const double _kUnitNodeHeight = 118;
const double _kTrophyNodeHeight = 112;
const double _kCourseFinishHeight = 150;

/// Empty space kept above every chapter plate except the first, so the
/// previous module's last waypoint (medallion plus the caption hanging below
/// it) never slides under the next chapter's title.
const double _kChapterLeadingGap = 56;

// ---------------------------------------------------------------------------
// The trail — a thick rounded ribbon with a solid "lip" underneath (the same
// depth as ChunkyBox). The part already walked is solid green; the part still
// ahead is a dashed neutral track. Lips are painted before faces so they never
// cover a neighbouring segment.
// ---------------------------------------------------------------------------

class _TrailRibbon {
  const _TrailRibbon._();

  /// Walked ribbon width and the dashed track width.
  static const double walkedWidth = 14;
  static const double trackWidth = 10;
  static const double _dash = 14;
  static const double _gap = 12;

  /// Paints the whole trail in two passes (lips, then faces) so a lip is
  /// never drawn over a neighbouring segment's face.
  static void paint(
    Canvas canvas, {
    required Path walked,
    required Path ahead,
    required PaperTheme theme,
  }) {
    const lip = Offset(0, Chunky.lip);
    _dashed(
      canvas,
      ahead.shift(lip),
      color: theme.trailUnwalkedEdge,
      width: trackWidth,
    );
    canvas.drawPath(
      walked.shift(lip),
      _stroke(theme.trailWalkedEdge, walkedWidth),
    );
    _dashed(canvas, ahead, color: theme.trailUnwalked, width: trackWidth);
    canvas.drawPath(walked, _stroke(theme.trailWalked, walkedWidth));
  }

  static Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static void _dashed(
    Canvas canvas,
    Path source, {
    required Color color,
    required double width,
  }) {
    final paint = _stroke(color, width);
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + _dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += _dash + _gap;
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Waypoint model — the single source of truth for both the line and the
// markers. `centered` waypoints (chapter/path/trophy) sit on the vertical
// midline; zigzag waypoints (units) alternate left/right.
// ---------------------------------------------------------------------------

class _TrailNode {
  final double height;

  /// Blank space reserved above this node, before its box starts.
  final double leadingGap;
  final bool centered;
  final bool isLeft;

  /// Small deterministic offset (fraction of canvas width) added to the
  /// left/right zigzag position, so waypoints don't all sit on exactly the
  /// same two vertical lines — this alone is most of what makes the trail
  /// read as hand-drawn rather than mechanically repeated.
  final double xJitter;

  /// Radius of this waypoint's actual pin marker — units and paths use
  /// differently-sized pins, and the zigzag slot needs the real radius to
  /// land the line exactly on the pin's center rather than assuming one
  /// fixed size for every marker type.
  final double pinRadius;

  /// When set, the waypoint is centred on its trail line in a slot this wide
  /// (units, whose caption sits under the node). Otherwise its pin edge is
  /// anchored to the line using [pinRadius] (paths).
  final double Function(double canvasWidth)? slotWidth;

  /// Deterministic horizontal nudges for the two control points of the
  /// cubic bezier leading into this node, so consecutive segments bow in
  /// slightly different ways instead of every curve having identical
  /// symmetric tension.
  final double curveKickA;
  final double curveKickB;

  /// Whether the segment *leading into* this node should be drawn as
  /// already-walked (green) rather than still-ahead (purple).
  final bool incomingSolid;
  final String? anchorId;
  final Widget Function(double canvasWidth) build;

  const _TrailNode({
    required this.height,
    this.leadingGap = 0,
    this.centered = true,
    this.isLeft = false,
    this.xJitter = 0,
    this.pinRadius = _kRoadNodeSize / 2,
    this.slotWidth,
    this.curveKickA = 0,
    this.curveKickB = 0,
    required this.incomingSolid,
    this.anchorId,
    required this.build,
  });
}

class _NodeBuildResult {
  final List<_TrailNode> nodes;
  final int? currentUnitIndex;

  const _NodeBuildResult(this.nodes, this.currentUnitIndex);
}

List<double> _computeCentersY(List<_TrailNode> nodes) {
  final centers = <double>[];
  var y = 0.0;
  for (final node in nodes) {
    y += node.leadingGap;
    centers.add(y + node.height / 2);
    y += node.height;
  }
  return centers;
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class OutlinePage extends StatefulWidget {
  final String title, id;
  final String? moduleId;

  /// Institute theme carried over from the screen that opened the roadmap.
  final String? themePreset;
  static const String routeName = "/outline";

  const OutlinePage({
    super.key,
    required this.title,
    required this.id,
    this.moduleId,
    this.themePreset,
  });

  @override
  State<OutlinePage> createState() => _OutlinePageState();
}

class _OutlinePageState extends State<OutlinePage>
    with SingleTickerProviderStateMixin {
  final bloc = inject<OutlineCourseBloc>();
  final subscribeBloc = inject<SubscribeCourseBloc>();
  late final AnimationController _entranceController;
  final _scrollController = ScrollController();
  bool _hasPlayedEntrance = false;
  bool _hasScrolledToCurrent = false;

  /// Set as soon as joining succeeds, so the free-start prompts disappear
  /// before the reloaded roadmap arrives.
  bool _justSubscribed = false;

  /// The unit finished during the last visit; its pin plays a one-shot pop.
  String? _justCompletedId;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    bloc.add(
      OutlineCourseEvent.outlineCourse(
        params: RequestOutlineCourseModel(id: widget.id),
      ),
    );
  }

  void _playEntranceOnce() {
    if (_hasPlayedEntrance) return;
    _hasPlayedEntrance = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _entranceController.value = 1;
    } else {
      _entranceController.forward(from: 0);
    }
  }

  /// Scrolls straight to a precomputed Y — no GlobalKey, no `ensureVisible`
  /// retry loop. Prefer a chapter `moduleId` when the announcement deep-link
  /// provided one; otherwise land on the current unit.
  void _scrollToCurrentUnitOnce(_NodeBuildResult result) {
    if (_hasScrolledToCurrent) return;
    int? index;
    final moduleId = widget.moduleId;
    if (moduleId != null && moduleId.isNotEmpty) {
      final found = result.nodes.indexWhere((n) => n.anchorId == moduleId);
      if (found >= 0) index = found;
    }
    index ??= result.currentUnitIndex;
    if (index == null) {
      _hasScrolledToCurrent = true;
      return;
    }
    _hasScrolledToCurrent = true;

    final targetY = _computeCentersY(result.nodes)[index];
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted || !_scrollController.hasClients) return;
      final position = _scrollController.position;
      final target = (targetY - position.viewportDimension * 0.35).clamp(
        0.0,
        position.maxScrollExtent,
      );
      if (MediaQuery.disableAnimationsOf(context)) {
        _scrollController.jumpTo(target);
        return;
      }
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int _previewCount(List<OutlineModuleEntity> modules) {
    var count = 0;
    for (final module in modules) {
      for (final path in module.paths ?? []) {
        for (final unit in path.units ?? []) {
          if (unit.isPreview == true) count++;
        }
      }
    }
    return count;
  }

  /// Joins the course (free for now: payment is not wired yet) and reloads
  /// the roadmap once the server confirms, so locked units open up.
  void _subscribe() {
    subscribeBloc.add(
      SubscribeCourseEvent.subscribeCourse(
        params: RequestSubscribeCourseModel(id: widget.id),
      ),
    );
  }

  void _onSubscribed() {
    MasirFeedback.success();
    CustomToast.toast(context, 'عضو دوره شدی! بزن بریم');
    setState(() => _justSubscribed = true);
    _hasScrolledToCurrent = false;
    bloc.add(
      OutlineCourseEvent.outlineCourse(
        params: RequestOutlineCourseModel(id: widget.id),
      ),
    );
  }

  void _promptSubscribe() {
    showModalBottomSheet<void>(
      context: context,
      sheetAnimationStyle: MasirMotion.sheet,
      builder: (sheetContext) {
        // The sheet lives on the root overlay, so carry the institute theme.
        return InstituteThemed(
          preset: widget.themePreset,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              MasirSpace.gutter,
              MasirSpace.gutter,
              MasirSpace.gutter,
              MasirSpace.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomText.headline(
                  'برای ادامه این واحد ثبت‌نام کن',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: MasirSpace.lg),
                CustomButton(
                  title: 'ثبت‌نام',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _subscribe();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onUnitTap(OutlineUnitEntity unit) {
    final id = unit.id;
    if (id == null || id.isEmpty) return;
    if (unit.locked ?? false) {
      _promptSubscribe();
      return;
    }
    _openUnit(unit);
  }

  /// Opens a unit. The unit page itself carries the student on to the next
  /// unit of the path, so we only get control back when they leave: either by
  /// backing out, or at the end of a path / before a locked unit. The page
  /// hands back the id of the last unit completed during the visit.
  Future<void> _openUnit(OutlineUnitEntity unit) async {
    final result = await CustomNavigator.pushNamed(
      UnitPage.routeName,
      arguments: UnitPageArgs(
        unitId: unit.id ?? '',
        unitType: unit.type ?? '',
        unitTitle: unit.title ?? '',
        status: unit.status ?? '',
        themePreset: widget.themePreset,
      ).toMap(),
    );
    if (!mounted) return;

    // Re-enable auto-scroll to the current unit once we are back.
    _hasScrolledToCurrent = false;
    final fresh = await _reload();
    if (!mounted || result is! String || fresh == null) return;

    setState(() => _justCompletedId = result);
    final spot = _locate(fresh.modules ?? [], result);
    if (spot == null) return;
    final units = spot.path.units ?? [];

    if (spot.index >= units.length - 1) {
      // Last unit of the path: celebrate once the whole path is really done.
      if (units.every((u) => u.status == 'completed')) {
        await _showPathCompleted(spot, fresh);
      }
      return;
    }

    // Stopped before a locked unit: offer to join.
    final next = units[spot.index + 1];
    if ((next.locked ?? false) && !(fresh.isSubscribed || _justSubscribed)) {
      _promptSubscribe();
    }
  }

  /// Reloads the roadmap and resolves with the fresh data (null on failure).
  Future<OutlineCourseEntity?> _reload() async {
    final settled = bloc.stream
        .firstWhere(
          (s) => s.maybeWhen(
            success: (_, _) => true,
            error: (_, _) => true,
            orElse: () => false,
          ),
        )
        .timeout(const Duration(seconds: 12));
    bloc.add(
      OutlineCourseEvent.outlineCourse(
        params: RequestOutlineCourseModel(id: widget.id),
      ),
    );
    try {
      final state = await settled;
      return state.maybeWhen(success: (_, data) => data, orElse: () => null);
    } catch (_) {
      return null;
    }
  }

  ({OutlineModuleEntity module, OutlinePathEntity path, int index})? _locate(
    List<OutlineModuleEntity> modules,
    String unitId,
  ) {
    for (final module in modules) {
      for (final path in module.paths ?? <OutlinePathEntity>[]) {
        final units = path.units ?? <OutlineUnitEntity>[];
        for (var i = 0; i < units.length; i++) {
          if (units[i].id == unitId) {
            return (module: module, path: path, index: i);
          }
        }
      }
    }
    return null;
  }

  Future<void> _showPathCompleted(
    ({OutlineModuleEntity module, OutlinePathEntity path, int index}) spot,
    OutlineCourseEntity course,
  ) {
    final modules = course.modules ?? [];
    MasirFeedback.celebrate();
    return showMasirDialog<void>(
      context: context,
      builder: (_) => InstituteThemed(
        preset: widget.themePreset,
        child: PathCompletedDialog(
          pathTitle: spot.path.title ?? '',
          unitCount: spot.path.units?.length ?? 0,
          chapterDone: _isModuleFullyCompleted(spot.module),
          courseDone:
              modules.isNotEmpty && modules.every(_isModuleFullyCompleted),
        ),
      ),
    );
  }

  int _moduleProgress(OutlineModuleEntity module) {
    final paths = module.paths ?? [];
    if (paths.isEmpty) return 0;
    final total = paths.fold<int>(
      0,
      (sum, p) => sum + (p.pathProgressPercent ?? 0),
    );
    return (total / paths.length).round();
  }

  bool _isModuleFullyCompleted(OutlineModuleEntity module) {
    final paths = module.paths ?? [];
    if (paths.isEmpty) return false;

    for (final path in paths) {
      final units = path.units ?? [];
      if (units.isEmpty) {
        if ((path.pathProgressPercent ?? 0) < 100) return false;
      } else if (!units.every((u) => u.status == 'completed')) {
        return false;
      }
    }
    return true;
  }

  OutlineUnitEntity? _findCurrentUnit(List<OutlineModuleEntity> modules) {
    for (final module in modules) {
      for (final path in module.paths ?? []) {
        for (final unit in path.units ?? []) {
          final locked = unit.locked ?? false;
          final completed = unit.status == 'completed';
          if (!locked && !completed) return unit;
        }
      }
    }
    return null;
  }

  /// (completed, total) unit counts across the whole course.
  (int, int) _unitCounts(List<OutlineModuleEntity> modules) {
    var done = 0;
    var total = 0;
    for (final module in modules) {
      for (final path in module.paths ?? <OutlinePathEntity>[]) {
        for (final unit in path.units ?? <OutlineUnitEntity>[]) {
          total++;
          if (unit.status == 'completed') done++;
        }
      }
    }
    return (done, total);
  }

  /// Flattens every module into one ordered waypoint list: chapter → its
  /// first path → that path's units → next path → … → trophy (if the
  /// chapter is fully complete) → next chapter → … This is the *only* place
  /// that decides ordering, sizing, and left/right/center placement, so the
  /// painter and the widgets can never disagree about where anything is.
  ///
  /// Chapters are plain full-width title plates, not trail markers — they
  /// still sit on the timeline (so the trail keeps flowing from one module
  /// into the next), but they never zigzag and never compete visually with
  /// the actual waypoints, which are paths and units. Paths and units each
  /// pick their left/right side at random (`randomSide`) instead of always
  /// snapping back to dead-center, which read as an artificial hourglass
  /// rather than a winding trail.
  _NodeBuildResult _buildTrailNodes(
    List<OutlineModuleEntity> modules,
    String? currentUnitId, {
    required bool subscribed,
  }) {
    final nodes = <_TrailNode>[];
    int? currentUnitIndex;

    // The green trail is the ground already covered: every segment up to and
    // including the one that *leads into* the current unit is walked, and
    // everything beyond it is still ahead. With no current unit the course is
    // either fully done (all green) or not started (all ahead).
    final courseDone =
        modules.isNotEmpty && modules.every(_isModuleFullyCompleted);
    var reachedCurrent = false;
    bool walkedInto({bool isCurrent = false}) {
      if (currentUnitId == null) return courseDone;
      if (reachedCurrent) return false;
      if (isCurrent) reachedCurrent = true;
      return true;
    }

    // Fixed seed → same randomness every rebuild for the same course
    // structure (no flicker when the bloc re-emits after a tap), and seeded
    // from this course's own id — not a fixed constant — so every course
    // keeps its own distinct trail shape across app sessions instead of
    // every course rendering the exact same pattern.
    final rng = math.Random(widget.id.hashCode);
    double jitter(double range) => (rng.nextDouble() * 2 - 1) * range;
    // Each path/unit waypoint picks its side at random instead of strictly
    // alternating left-right-left-right — but a plain coin flip can streak
    // (3+ in a row on the same side), and since the seed is locked to this
    // course's id, an unlucky streak would stick around forever for that
    // course. Capping the run at 2 keeps the "not mechanical" feel while
    // guaranteeing it never stops reading as a zigzag.
    // Structured zigzag: always alternate sides (left, right, left, right…)
    // in the order the path/unit waypoints are added.
    var nextIsLeft = true;
    bool structuredSide() {
      final side = nextIsLeft;
      nextIsLeft = !nextIsLeft;
      return side;
    }

    for (var moduleIndex = 0; moduleIndex < modules.length; moduleIndex++) {
      final module = modules[moduleIndex];
      final paths = module.paths ?? [];
      final moduleProgress = _moduleProgress(module);
      final isModuleFullyCompleted = _isModuleFullyCompleted(module);
      final chapterIsComplete = isModuleFullyCompleted || moduleProgress >= 100;

      nodes.add(
        _TrailNode(
          height: _kChapterNodeHeight,
          leadingGap: moduleIndex == 0 ? 0 : _kChapterLeadingGap,
          incomingSolid: walkedInto(),
          curveKickA: jitter(16),
          curveKickB: jitter(16),
          anchorId: module.id,
          build: (_) => _ChapterHeader(
            index: moduleIndex,
            title: module.title ?? '',
            progress: moduleProgress,
            isComplete: chapterIsComplete,
          ),
        ),
      );

      final lastUnitsPathIndex = paths.lastIndexWhere(
        (p) => (p.units ?? []).isNotEmpty,
      );

      for (var pathIndex = 0; pathIndex < paths.length; pathIndex++) {
        final path = paths[pathIndex];
        final units = path.units ?? [];
        final pathIsLeft = structuredSide();

        nodes.add(
          _TrailNode(
            height: _kPathNodeHeight,
            centered: false,
            isLeft: pathIsLeft,
            xJitter: jitter(0.055),
            pinRadius: _PathWaypoint._size / 2,
            curveKickA: jitter(22),
            curveKickB: jitter(22),
            incomingSolid: walkedInto(),
            build: (canvasWidth) => _PathWaypoint(
              path: path,
              isLeft: pathIsLeft,
              maxLabelWidth: (canvasWidth * 0.46).clamp(90.0, 150.0),
            ),
          ),
        );

        for (var unitIndex = 0; unitIndex < units.length; unitIndex++) {
          final unit = units[unitIndex];
          final isLeft = structuredSide();
          final isCompleted = unit.status == 'completed';
          final isLocked = unit.locked ?? false;
          final isCurrent = unit.id == currentUnitId;
          final unitType = unit.type ?? '';

          final incomingSolid = walkedInto(isCurrent: isCurrent);

          if (isCurrent) currentUnitIndex = nodes.length;

          nodes.add(
            _TrailNode(
              height: _kUnitNodeHeight,
              centered: false,
              isLeft: isLeft,
              xJitter: jitter(0.05),
              slotWidth: _unitSlotWidth,
              curveKickA: jitter(18),
              curveKickB: jitter(18),
              incomingSolid: incomingSolid,
              build: (canvasWidth) => _RoadUnitNode(
                pinKey: ValueKey('roadmap-pin-${unit.id}'),
                title: unit.title ?? '',
                typeLabel: UnitTypeStyle.labelOf(unitType),
                icon: UnitTypeStyle.iconOf(unitType),
                isCompleted: isCompleted,
                isLocked: isLocked,
                isPreview: !subscribed && unit.isPreview == true,
                isCurrent: isCurrent,
                celebrate: isCompleted && unit.id == _justCompletedId,
                slotWidth: _unitSlotWidth(canvasWidth),
                onTap: () => _onUnitTap(unit),
              ),
            ),
          );
        }

        if (isModuleFullyCompleted && pathIndex == lastUnitsPathIndex) {
          nodes.add(
            _TrailNode(
              height: _kTrophyNodeHeight,
              incomingSolid: walkedInto(),
              curveKickA: jitter(16),
              curveKickB: jitter(16),
              build: (_) => const _TrophyNode(),
            ),
          );
        }
      }
    }

    // Whole-course finish line — always the very last waypoint on the
    // trail, so the destination is revealed from the moment the roadmap
    // loads instead of only appearing once you happen to finish. It stays
    // locked-looking (like a locked unit) until every module — and so
    // every unit — is actually completed.
    if (modules.isNotEmpty) {
      final courseComplete = courseDone;
      nodes.add(
        _TrailNode(
          height: _kCourseFinishHeight,
          incomingSolid: walkedInto(),
          curveKickA: jitter(16),
          curveKickB: jitter(16),
          build: (_) => _CourseFinishNode(isComplete: courseComplete),
        ),
      );
    }

    return _NodeBuildResult(nodes, currentUnitIndex);
  }

  @override
  Widget build(BuildContext context) {
    return InstituteThemed(
      preset: widget.themePreset,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocListener<SubscribeCourseBloc, SubscribeCourseState>(
          bloc: subscribeBloc,
          listener: (context, sub) {
            sub.whenOrNull(
              success: (_, _) => _onSubscribed(),
              error: (_, message) => CustomToast.toast(context, message),
            );
          },
          child: BlocBuilder<OutlineCourseBloc, OutlineCourseState>(
            bloc: bloc,
            // A reload keeps the roadmap on screen instead of flashing a
            // skeleton; the fresh data swaps in when it arrives.
            buildWhen: (prev, curr) => prev.maybeWhen(
              success: (_, _) =>
                  curr.maybeWhen(loading: (_) => false, orElse: () => true),
              orElse: () => true,
            ),
            builder: (context, state) {
              return state.when(
                loading: (_) => _shell(
                  body: const StateView.loading(
                    variant: SkeletonVariant.detail,
                  ),
                ),
                error: (_, message) => _shell(
                  body: StateView.error(
                    message: message,
                    retry: () => bloc.add(
                      OutlineCourseEvent.outlineCourse(
                        params: RequestOutlineCourseModel(id: widget.id),
                      ),
                    ),
                  ),
                ),
                success: (isLoading, data) {
                  final courseProgress = data.courseProgressPercent ?? 0;
                  final modules = data.modules ?? [];
                  final currentUnit = _findCurrentUnit(modules);
                  final currentUnitId = currentUnit?.id;
                  final (doneUnits, totalUnits) = _unitCounts(modules);
                  final subscribed = data.isSubscribed || _justSubscribed;
                  final result = _buildTrailNodes(
                    modules,
                    currentUnitId,
                    subscribed: subscribed,
                  );

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    _playEntranceOnce();
                    _scrollToCurrentUnitOnce(result);
                  });

                  return _shell(
                    bleed: true,
                    stickyBottom: !subscribed
                        ? _PreviewSubscribeBar(
                            previewCount:
                                data.previewUnitCount ?? _previewCount(modules),
                            bloc: subscribeBloc,
                            onSubscribe: _subscribe,
                          )
                        : currentUnit != null
                        ? _ContinueBar(
                            unitTitle: currentUnit.title ?? '',
                            started: doneUnits > 0,
                            onTap: () => _onUnitTap(currentUnit),
                          )
                        : null,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: MasirSpace.pageH,
                          child: _CourseProgressHeader(
                            progress: courseProgress,
                            done: doneUnits,
                            total: totalUnits,
                          ),
                        ),
                        const SizedBox(height: MasirSpace.md),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(
                              _kCanvasInset,
                              0,
                              _kCanvasInset,
                              MasirSpace.xxl,
                            ),
                            child: _TrailCanvas(
                              nodes: result.nodes,
                              entrance: _entranceController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _shell({
    required Widget body,
    Widget? stickyBottom,
    bool bleed = false,
  }) {
    return MasirPage.detail(
      title: widget.title,
      body: body,
      bleed: bleed,
      stickyBottom: stickyBottom,
    );
  }
}

class _PreviewSubscribeBar extends StatelessWidget {
  final int previewCount;
  final SubscribeCourseBloc bloc;
  final VoidCallback onSubscribe;

  const _PreviewSubscribeBar({
    required this.previewCount,
    required this.bloc,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText.caption(
          previewCount > 0
              ? '${faDigits(previewCount)} واحد اول رایگانه'
              : 'برای شروع این دوره ثبت‌نام کن',
          textAlign: TextAlign.center,
          color: context.colors.inkMuted,
        ),
        const SizedBox(height: MasirSpace.sm),
        BlocBuilder<SubscribeCourseBloc, SubscribeCourseState>(
          bloc: bloc,
          builder: (context, state) => CustomButton(
            title: 'ثبت‌نام',
            loading: state.isLoading,
            onTap: onSubscribe,
          ),
        ),
      ],
    );
  }
}

/// Sticky "pick up where you left off" bar: the one obvious next step.
class _ContinueBar extends StatelessWidget {
  final String unitTitle;
  final bool started;
  final VoidCallback onTap;

  const _ContinueBar({
    required this.unitTitle,
    required this.started,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (unitTitle.isNotEmpty) ...[
          CustomText.caption(
            unitTitle,
            textAlign: TextAlign.center,
            color: context.colors.inkMuted,
            maxLines: 1,
          ),
          const SizedBox(height: MasirSpace.sm),
        ],
        CustomButton(
          title: started ? 'ادامه یادگیری' : 'شروع یادگیری',
          onTap: onTap,
        ),
      ],
    );
  }
}

/// Celebration shown on the roadmap after the last unit of a path is done.
@visibleForTesting
class PathCompletedDialog extends StatelessWidget {
  final String pathTitle;
  final int unitCount;
  final bool chapterDone;
  final bool courseDone;

  const PathCompletedDialog({
    super.key,
    required this.pathTitle,
    required this.unitCount,
    required this.chapterDone,
    required this.courseDone,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final title = courseDone
        ? 'دوره رو تموم کردی!'
        : chapterDone
        ? 'یک فصل کامل شد!'
        : 'این مسیر کامل شد!';
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: MasirSpace.lg,
        vertical: MasirSpace.xxl,
      ),
      child: ChunkyBox(
        fill: c.surface,
        edge: c.lip,
        borderColor: c.border,
        radius: MasirRadius.hero,
        padding: const EdgeInsets.fromLTRB(
          MasirSpace.xl,
          MasirSpace.xxl,
          MasirSpace.xl,
          MasirSpace.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutBack,
                builder: (context, t, child) => Transform.scale(
                  scale: 0.4 + 0.6 * t,
                  child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
                ),
                child: SizedBox(
                  width: 128,
                  height: 128 + Chunky.lip,
                  child: ChunkyBox(
                    fill: c.sun,
                    edge: c.sunEdge,
                    radius: 64,
                    alignment: Alignment.center,
                    child: Icon(
                      courseDone
                          ? Icons.emoji_events_rounded
                          : Icons.workspace_premium_rounded,
                      size: 68,
                      color: c.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: MasirSpace.xl),
            CustomText.display(title, textAlign: TextAlign.center),
            if (pathTitle.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.xs),
              CustomText.headline(
                pathTitle,
                textAlign: TextAlign.center,
                color: c.inkMuted,
              ),
            ],
            const SizedBox(height: MasirSpace.lg),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: MasirSpace.sm,
              runSpacing: MasirSpace.sm,
              children: [
                if (unitCount > 0)
                  PillChip(
                    '${faDigits(unitCount)} واحد تموم شد',
                    icon: Icons.check_circle_rounded,
                    tone: PillTone.success,
                  ),
                if (chapterDone && !courseDone)
                  const PillChip('فصل کامل شد', tone: PillTone.sun),
              ],
            ),
            const SizedBox(height: MasirSpace.xxl),
            CustomButton(
              title: courseDone ? 'ایول!' : 'ادامه مسیر',
              height: 56,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Course progress header (pinned above the trail)
// ---------------------------------------------------------------------------

class _CourseProgressHeader extends StatelessWidget {
  final int progress;
  final int done;
  final int total;

  const _CourseProgressHeader({
    required this.progress,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    return MasirCard(
      padding: const EdgeInsets.symmetric(
        horizontal: MasirSpace.card,
        vertical: MasirSpace.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.bodyStrong('مسیر یادگیری'),
                    if (total > 0)
                      CustomText.caption(
                        '${faDigits(done)} از ${faDigits(total)} واحد',
                        color: context.colors.inkMuted,
                      ),
                  ],
                ),
              ),
              CustomText.bodyStrong(
                '${faDigits(progress)}٪',
                color: progress >= 100 ? t.success : t.accent,
              ),
            ],
          ),
          const SizedBox(height: MasirSpace.sm),
          ProgressPill(
            value: progress,
            color: progress >= 100 ? t.success : t.accent,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The canvas — one Stack, one coordinate space, for the whole course.
// ---------------------------------------------------------------------------

class _TrailCanvas extends StatelessWidget {
  final List<_TrailNode> nodes;
  final Animation<double> entrance;

  const _TrailCanvas({required this.nodes, required this.entrance});

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();

    final centersY = _computeCentersY(nodes);
    final totalHeight = centersY.last + nodes.last.height / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          width: width,
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _FullTrailPainter(
                    nodes: nodes,
                    centersY: centersY,
                    theme: PaperTheme.of(context),
                  ),
                ),
              ),
              for (var i = 0; i < nodes.length; i++)
                Positioned(
                  top: centersY[i] - nodes[i].height / 2,
                  left: 0,
                  right: 0,
                  height: nodes[i].height,
                  child: _TrailNodeEntrance(
                    index: i,
                    entrance: entrance,
                    child: nodes[i].centered
                        ? OverflowBox(
                            maxHeight: double.infinity,
                            alignment: Alignment.center,
                            child: nodes[i].build(width),
                          )
                        : _ZigZagSlot(
                            isLeft: nodes[i].isLeft,
                            width: width,
                            xJitter: nodes[i].xJitter,
                            pinRadius: nodes[i].pinRadius,
                            slotWidth: nodes[i].slotWidth?.call(width),
                            child: nodes[i].build(width),
                          ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Places a zigzag unit's pin exactly on the trail's left/right line by
/// pinning the pin's edge (not the whole row, which also has a label of
/// variable width) at the computed fraction of the canvas width — the same
/// fraction the painter uses for that side, so pin and line always meet.
class _ZigZagSlot extends StatelessWidget {
  final bool isLeft;
  final double width;
  final double xJitter;
  final double pinRadius;

  /// When set, [child] is centred on the line instead of edge-anchored.
  final double? slotWidth;
  final Widget child;

  const _ZigZagSlot({
    required this.isLeft,
    required this.width,
    required this.xJitter,
    required this.pinRadius,
    this.slotWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final base = isLeft ? _kRoadSideRatio : (1 - _kRoadSideRatio);
    final nodeCenterX = (base + xJitter) * width;
    final nodeRadius = pinRadius;

    final centeredWidth = slotWidth;
    if (centeredWidth != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: nodeCenterX - centeredWidth / 2,
            width: centeredWidth,
            child: OverflowBox(
              maxHeight: double.infinity,
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ],
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: isLeft ? nodeCenterX - nodeRadius : null,
          right: isLeft ? null : width - nodeCenterX - nodeRadius,
          child: Align(alignment: Alignment.center, child: child),
        ),
      ],
    );
  }
}

/// Fade + rise-in for a waypoint, staggered by its position in the flat
/// list. Purely cosmetic (opacity/translate) — it never touches layout, so
/// it can't be a source of misalignment.
class _TrailNodeEntrance extends StatelessWidget {
  final int index;
  final Animation<double> entrance;
  final Widget child;

  const _TrailNodeEntrance({
    required this.index,
    required this.entrance,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.02).clamp(0.0, 0.85);
    final end = (start + 0.35).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: entrance,
      builder: (context, _) {
        final t = Interval(
          start,
          end,
          curve: Curves.easeOutBack,
        ).transform(entrance.value).clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 14),
            child: child,
          ),
        );
      },
    );
  }
}

/// Draws the entire course's trail in a single pass by connecting every
/// consecutive pair of waypoint centers. Because it reads from the exact
/// same `nodes`/`centersY` the Stack above positions widgets with, there is
/// no possible mismatch between where the line goes and where a node sits.
class _FullTrailPainter extends CustomPainter {
  final List<_TrailNode> nodes;
  final List<double> centersY;
  final PaperTheme theme;

  _FullTrailPainter({
    required this.nodes,
    required this.centersY,
    required this.theme,
  });

  double _x(_TrailNode node, double width) {
    if (node.centered) return width / 2;
    final base = node.isLeft ? _kRoadSideRatio : (1 - _kRoadSideRatio);
    return (base + node.xJitter) * width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final walked = Path();
    final ahead = Path();

    for (var i = 1; i < nodes.length; i++) {
      final x1 = _x(nodes[i - 1], size.width);
      final y1 = centersY[i - 1];
      final x2 = _x(nodes[i], size.width);
      final y2 = centersY[i];
      final dy = y2 - y1;
      final kickA = nodes[i].curveKickA;
      final kickB = nodes[i].curveKickB;

      final segment = Path()
        ..moveTo(x1, y1)
        ..cubicTo(
          x1 + kickA,
          y1 + dy * 0.55,
          x2 + kickB,
          y2 - dy * 0.55,
          x2,
          y2,
        );

      (nodes[i].incomingSolid ? walked : ahead).addPath(segment, Offset.zero);
    }

    _TrailRibbon.paint(canvas, walked: walked, ahead: ahead, theme: theme);
  }

  @override
  bool shouldRepaint(covariant _FullTrailPainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// Waypoint widgets — pure visuals, no positioning logic of their own.
// ---------------------------------------------------------------------------

/// Chapter title plate — a full-width card, *not* a trail marker. It still
/// sits on the timeline so the trail flows between chapters.
class _ChapterHeader extends StatelessWidget {
  final int index;
  final String title;
  final int progress;
  final bool isComplete;

  const _ChapterHeader({
    required this.index,
    required this.title,
    required this.progress,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    final accent = isComplete ? t.success : t.accent;

    final content = Row(
      children: [
        isComplete
            ? const IconTile(Icons.check_rounded, tone: IconTileTone.success)
            : Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: t.accentTint,
                  borderRadius: BorderRadius.circular(MasirRadius.chip),
                ),
                child: CustomText.headline(
                  faDigits(index + 1),
                  color: t.accent,
                ),
              ),
        const SizedBox(width: MasirSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CustomText.micro('فصل ${faDigits(index + 1)}', color: accent),
                  const SizedBox(width: MasirSpace.sm),
                  Expanded(child: CustomText.bodyStrong(title, maxLines: 1)),
                ],
              ),
              const SizedBox(height: MasirSpace.sm - 2),
              ProgressPill(value: progress, height: 6, color: accent),
            ],
          ),
        ),
        const SizedBox(width: MasirSpace.md),
        CustomText.caption(
          isComplete ? 'کامل' : '${faDigits(progress)}٪',
          color: accent,
          weight: MasirText.heavy,
        ),
      ],
    );

    const padding = EdgeInsets.symmetric(
      horizontal: MasirSpace.md,
      vertical: MasirSpace.sm,
    );

    if (!isComplete) {
      return MasirCard(padding: padding, child: content);
    }
    return ChunkyBox(
      fill: t.successSoft,
      edge: t.successEdge.withValues(alpha: 0.35),
      borderColor: t.successEdge.withValues(alpha: 0.35),
      radius: MasirRadius.card,
      padding: padding,
      child: content,
    );
  }
}

/// Path waypoint — a rounded-square milestone tile in sun, green once the
/// path is done, with a soft label beside it.
class _PathWaypoint extends StatelessWidget {
  final OutlinePathEntity path;
  final bool isLeft;
  final double maxLabelWidth;

  const _PathWaypoint({
    required this.path,
    required this.isLeft,
    required this.maxLabelWidth,
  });

  static const double _size = 52;

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    final pathProgress = path.pathProgressPercent ?? 0;
    final isComplete = pathProgress >= 100;
    final fg = isComplete ? t.successEdge : t.sunEdge;
    final soft = isComplete ? t.successSoft : t.sunSoft;

    // The lip hangs below the face, so size the slot to the face alone and
    // let the lip overflow: the tile's face centre is then the slot centre.
    final pin = SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: _size,
            height: _size + Chunky.lip,
            child: ChunkyBox(
              fill: soft,
              edge: fg,
              borderColor: fg,
              radius: MasirRadius.row,
              alignment: Alignment.center,
              child: Icon(
                isComplete ? Icons.flag_circle_rounded : Icons.route_rounded,
                size: MasirIconSize.lg,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );

    final align = isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final textAlign = isLeft ? TextAlign.left : TextAlign.right;
    final label = Container(
      constraints: BoxConstraints(maxWidth: maxLabelWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: MasirSpace.md,
        vertical: MasirSpace.sm,
      ),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(MasirRadius.row),
      ),
      child: Column(
        crossAxisAlignment: align,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText.caption(
            path.title ?? '',
            weight: MasirText.strong,
            textAlign: textAlign,
            maxLines: 2,
          ),
          const SizedBox(height: 2),
          CustomText.micro(
            isComplete ? 'مسیر کامل شد' : 'پیشرفت ${faDigits(pathProgress)}٪',
            color: fg,
            textAlign: textAlign,
          ),
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: isLeft
          ? [pin, const SizedBox(width: MasirSpace.md), label]
          : [label, const SizedBox(width: MasirSpace.md), pin],
    );
  }
}

/// A round chunky medallion whose *face centre* is this widget's centre. The
/// caption is a `Positioned` overflow annotation, so the trail ends at the
/// medallion and not at the midpoint of "medallion + caption".
class _Medallion extends StatelessWidget {
  final double size;
  final Color fill;
  final Color edge;
  final Color? borderColor;
  final IconData icon;
  final Color iconColor;
  final Widget caption;

  const _Medallion({
    super.key,
    required this.size,
    required this.fill,
    required this.edge,
    this.borderColor,
    required this.icon,
    required this.iconColor,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    // Centered waypoints are laid out with tight full-width constraints, which
    // would stretch a plain SizedBox and glue the medallion to one side. The
    // Center loosens them so the medallion keeps its own size, mid-trail.
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: size,
              height: size + Chunky.lip,
              child: ChunkyBox(
                fill: fill,
                edge: edge,
                borderColor: borderColor,
                radius: size / 2,
                alignment: Alignment.center,
                child: Icon(icon, size: size * 0.5, color: iconColor),
              ),
            ),
            Positioned(
              top: size + Chunky.lip + MasirSpace.sm,
              left: 0,
              right: 0,
              height: 0,
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                alignment: Alignment.topCenter,
                child: caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Trophy waypoint at the end of a completed chapter.
class _TrophyNode extends StatelessWidget {
  const _TrophyNode();

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    return _Medallion(
      key: const ValueKey('roadmap-trophy'),
      size: 64,
      fill: t.sun,
      edge: t.sunEdge,
      icon: Icons.workspace_premium_rounded,
      iconColor: t.colors.white,
      caption: CustomText.caption(
        'این فصل کامل شد',
        color: t.success,
        weight: MasirText.strong,
      ),
    );
  }
}

/// The finish line — always the last waypoint, so the destination is visible
/// from the start. Sun while the course is unfinished, green once it is done.
class _CourseFinishNode extends StatelessWidget {
  final bool isComplete;

  const _CourseFinishNode({required this.isComplete});

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);

    if (!isComplete) {
      return _Medallion(
        key: const ValueKey('roadmap-finish'),
        size: 72,
        fill: t.sunSoft,
        edge: t.sunEdge,
        borderColor: t.sunEdge,
        icon: Icons.flag_rounded,
        iconColor: t.sunEdge,
        caption: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText.bodyStrong('پایان مسیر', textAlign: TextAlign.center),
            const SizedBox(height: 2),
            CustomText.caption(
              'با تموم شدن دوره باز می‌شه',
              color: t.inkMuted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return _Medallion(
      key: const ValueKey('roadmap-finish'),
      size: 80,
      fill: t.success,
      edge: t.successEdge,
      icon: Icons.emoji_events_rounded,
      iconColor: t.colors.white,
      caption: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText.bodyStrong(
            'دوره تموم شد!',
            color: t.success,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          CustomText.caption(
            'همه‌ی واحدها رو گذروندی',
            color: t.inkMuted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A single unit: a 64px chunky circular button with a type icon, a caption
/// pill underneath and, for the current / free unit, a small bubble above.
///
/// The column is padded symmetrically above and below the button, so the
/// button's face centre is exactly this widget's centre — which is where the
/// trail passes.
class _RoadUnitNode extends StatelessWidget {
  final Key? pinKey;
  final String title;
  final String typeLabel;
  final IconData icon;
  final bool isCompleted;
  final bool isLocked;
  final bool isPreview;
  final bool isCurrent;
  final bool celebrate;
  final double slotWidth;
  final VoidCallback onTap;

  const _RoadUnitNode({
    this.pinKey,
    required this.title,
    required this.typeLabel,
    required this.icon,
    required this.isCompleted,
    required this.isLocked,
    required this.isPreview,
    required this.isCurrent,
    this.celebrate = false,
    required this.slotWidth,
    required this.onTap,
  });

  static const double _halo = 36;

  Widget _pin(PaperTheme t) {
    final Color fill;
    final Color edge;
    Color? border;
    final Color fg;
    final IconData glyph;

    if (isCompleted) {
      fill = t.success;
      edge = t.successEdge;
      fg = t.colors.white;
      glyph = Icons.check_rounded;
    } else if (isLocked) {
      fill = t.colors.border100;
      edge = t.border;
      fg = t.locked;
      glyph = Icons.lock_rounded;
    } else if (isCurrent) {
      fill = t.accent;
      edge = t.accentEdge;
      fg = t.onAccent;
      glyph = icon;
    } else {
      fill = t.surface;
      edge = t.accent.withValues(alpha: 0.35);
      border = t.accent.withValues(alpha: 0.35);
      fg = t.accent;
      glyph = icon;
    }

    return SizedBox(
      width: _kRoadNodeSize,
      height: _kRoadNodeSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (isCurrent) const _PulseRing(size: _kRoadNodeSize),
          if (celebrate) const _DonePop(size: _kRoadNodeSize),
          Positioned(
            left: 0,
            top: 0,
            width: _kRoadNodeSize,
            height: _kRoadNodeSize + Chunky.lip,
            child: ChunkyBox(
              key: pinKey,
              fill: fill,
              edge: edge,
              borderColor: border,
              radius: _kRoadNodeSize / 2,
              alignment: Alignment.center,
              onTap: onTap,
              child: Icon(glyph, size: MasirIconSize.lg + 2, color: fg),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _bubble(PaperTheme t) {
    if (isCurrent) {
      return _Bubble(label: 'شروع', fill: t.accent, fg: t.onAccent);
    }
    if (isPreview && !isLocked && !isCompleted) {
      return _Bubble(label: 'رایگان', fill: t.sunSoft, fg: t.sunEdge);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    final bubble = _bubble(t);

    final pill = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: slotWidth),
        padding: const EdgeInsets.symmetric(
          horizontal: MasirSpace.md - 2,
          vertical: MasirSpace.xs,
        ),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(MasirRadius.pill),
          border: Border.all(color: t.border, width: Chunky.border),
        ),
        child: CustomText.caption(
          title,
          weight: MasirText.strong,
          color: isLocked ? t.locked : t.ink,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );

    return Semantics(
      button: true,
      label: '$title، $typeLabel',
      child: SizedBox(
        width: slotWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _halo,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: bubble,
                ),
              ),
            ),
            _pin(t),
            // Lip + gap, then the pill, in a box as tall as the halo above.
            SizedBox(
              height: _halo,
              child: Padding(
                padding: const EdgeInsets.only(top: Chunky.lip + 4),
                child: Align(alignment: Alignment.topCenter, child: pill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small speech bubble ("شروع", "رایگان") with a tail pointing at the node.
class _Bubble extends StatelessWidget {
  final String label;
  final Color fill;
  final Color fg;

  const _Bubble({required this.label, required this.fill, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: MasirSpace.md,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(MasirRadius.pill),
          ),
          child: CustomText.micro(label, color: fg),
        ),
        CustomPaint(size: const Size(10, 5), painter: _TailPainter(fill)),
      ],
    );
  }
}

class _TailPainter extends CustomPainter {
  final Color color;

  const _TailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TailPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Soft ring that breathes around the current unit. Static when the system
/// asks for reduced motion.
class _PulseRing extends StatefulWidget {
  final double size;

  const _PulseRing({required this.size});

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  bool _reduce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduce = MediaQuery.disableAnimationsOf(context);
    if (_reduce) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _reduce ? 0.0 : Curves.easeOut.transform(_controller.value);
          final scale = _reduce ? 1.18 : 1.0 + 0.4 * t;
          final opacity = _reduce ? 0.28 : 0.4 * (1 - t);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: opacity),
                  width: 4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A one-shot green ring that blooms out of a pin the student just finished.
class _DonePop extends StatefulWidget {
  final double size;

  const _DonePop({required this.size});

  @override
  State<_DonePop> createState() => _DonePopState();
}

class _DonePopState extends State<_DonePop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!MediaQuery.disableAnimationsOf(context)) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.green;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeOutCubic.transform(_controller.value);
          if (_controller.value == 0 || _controller.value >= 1) {
            return const SizedBox.shrink();
          }
          return Transform.scale(
            scale: 1.0 + 0.9 * t,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.6 * (1 - t)),
                  width: 5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
