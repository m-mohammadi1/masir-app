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
import 'package:mohammad/features/main/presentation/page/outline/roadmap/roadmap_canvas.dart';
import 'package:mohammad/features/main/presentation/page/outline/roadmap/roadmap_nodes.dart';
import 'package:mohammad/features/main/presentation/page/outline/roadmap/trail_layout.dart';
import 'package:mohammad/features/main/presentation/page/outline/roadmap/unit_card.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_origin.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page_args.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/institute_themed.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/masir_card.dart';
import '/widgets/masir_motion.dart';
import '/widgets/masir_notice.dart';
import '/widgets/masir_toast.dart';
import '/widgets/masir_page.dart';
import '/widgets/progress_pill.dart';
import '/widgets/unit_kit/unit_type_style.dart';
import '/widgets/state_view.dart';
import 'outline/roadmap/paper_theme.dart';

// The roadmap draws the whole course as one trail (see `outline/roadmap/`):
// the page decides the stops and their order, TrailGeometry places them and
// threads one smooth curve through their centres, and TrailCanvas paints the
// trail and positions the stops from those same numbers.

/// Vertical space per kind of stop. Units are just their pin plus breathing
/// room; nothing hangs below a pin, so nothing can sit on the trail.
const double kChapterStopHeight = 76;
const double kChapterStopGap = 36;
const double kPathStopHeight = 72;
const double kUnitStopHeight = 100;
const double kTrophyStopHeight = 96;
const double kFinishStopHeight = 150;

/// Horizontal inset of the trail canvas inside the page.
const double _kCanvasInset = 12;

/// Bottom padding under the canvas, room for the finish caption.
const double _kCanvasBottom = MasirSpace.xxl;

/// Where the current unit sits in the viewport when the roadmap scrolls to it.
const double _kFocusFraction = 0.4;

/// A stable per-course seed (String.hashCode may differ between runs).
int _seedFor(String id) =>
    id.codeUnits.fold(17, (hash, unit) => (hash * 31 + unit) & 0x7fffffff);

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

/// The stops of one roadmap build, and which one is the current unit.
class _Trail {
  final List<TrailNode> nodes;
  final int? currentIndex;

  /// How far the walked trail reaches: the current unit, the finish once the
  /// course is done, or the start when nothing is open yet.
  final double walkedTo;

  const _Trail(this.nodes, this.currentIndex, this.walkedTo);
}

class _OutlinePageState extends State<OutlinePage>
    with TickerProviderStateMixin {
  final bloc = inject<OutlineCourseBloc>();
  final subscribeBloc = inject<SubscribeCourseBloc>();
  late final AnimationController _entranceController;

  /// Draws the walked trail forward after a unit is finished.
  late final AnimationController _trailController;

  /// How far the walked trail reaches, as a fractional stop index.
  final _walked = ValueNotifier<double>(0);

  /// Created on the first roadmap build, already scrolled to the current
  /// unit, so the page never opens at the top and then jumps.
  ScrollController? _scrollController;

  final _canvasKey = GlobalKey();
  bool _hasPlayedEntrance = false;

  /// While true the trail and the current pin keep showing the previous
  /// visit, until the return sequence animates them forward.
  bool _holdProgress = false;

  /// The last built trail, for scroll targets and the return sequence.
  _Trail? _trail;

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
    _trailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    bloc.add(
      OutlineCourseEvent.outlineCourse(
        params: RequestOutlineCourseModel(id: widget.id),
      ),
    );
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  void _playEntranceOnce() {
    if (_hasPlayedEntrance) return;
    _hasPlayedEntrance = true;
    if (_reduceMotion) {
      _entranceController.value = 1;
    } else {
      _entranceController.forward(from: 0);
    }
  }

  /// Scroll offset that brings stop [index] to the focus line.
  double _offsetFor(List<TrailNode> nodes, int index, double viewport) {
    final centers = computeCentersY(nodes);
    final contentHeight = centers.last + nodes.last.height / 2 + _kCanvasBottom;
    final maxOffset = math.max(0.0, contentHeight - viewport);
    return (centers[index] - viewport * _kFocusFraction).clamp(0.0, maxOffset);
  }

  /// Where the roadmap opens: a chapter from a deep link, else the current
  /// unit.
  double _initialOffset(_Trail trail, double viewport) {
    var index = trail.currentIndex;
    final moduleId = widget.moduleId;
    if (moduleId != null && moduleId.isNotEmpty) {
      final found = trail.nodes.indexWhere((n) => n.anchorId == moduleId);
      if (found >= 0) index = found;
    }
    if (index == null) return 0;
    return _offsetFor(trail.nodes, index, viewport);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _trailController.dispose();
    _walked.dispose();
    _scrollController?.dispose();
    bloc.close();
    subscribeBloc.close();
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

  /// A tapped pin opens its card; the card decides what happens next.
  Future<void> _onUnitTap(
    OutlineUnitEntity unit,
    Rect anchor, {
    required bool isCurrent,
    required bool subscribed,
  }) async {
    final id = unit.id;
    if (id == null || id.isEmpty) return;
    final locked = unit.locked ?? false;
    final state = unit.status == 'completed'
        ? UnitCardState.completed
        : locked
        ? UnitCardState.locked
        // Before joining, a free unit says so, even the one to start with.
        : (!subscribed && unit.isPreview == true)
        ? UnitCardState.preview
        : isCurrent
        ? UnitCardState.current
        : UnitCardState.open;
    final type = unit.type ?? '';
    final action = await showUnitCard(
      context,
      anchor: anchor,
      title: unit.title ?? '',
      typeLabel: UnitTypeStyle.labelOf(type),
      icon: UnitTypeStyle.iconOf(type),
      state: state,
      themePreset: widget.themePreset,
    );
    if (!mounted || action == null) return;
    switch (action) {
      case UnitCardAction.join:
        _subscribe();
      case UnitCardAction.open:
        _openUnit(unit, origin: anchor.center);
    }
  }

  /// Where stop [index] is on screen, to open its unit from there.
  Offset? _originOf(int? index) {
    final trail = _trail;
    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (index == null || trail == null || box == null || !box.hasSize) {
      return null;
    }
    final centers = computeCentersY(trail.nodes);
    final local = Offset(trail.nodes[index].x * box.size.width, centers[index]);
    return box.localToGlobal(local);
  }

  /// Opens a unit, growing out of its pin ([origin]). The unit page itself
  /// carries the student on to the next unit of the path, so we only get
  /// control back when they leave: either by backing out, or at the end of a
  /// path / before a locked unit. The page hands back a [UnitPageResult]
  /// with the last unit completed during the visit, and whether the student
  /// asked to join from the free preview. Leaving by the browser back hands
  /// back nothing.
  Future<void> _openUnit(OutlineUnitEntity unit, {Offset? origin}) async {
    UnitOrigin.set(origin);
    final popped = await CustomNavigator.pushNamed(
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
    final outcome = popped is UnitPageResult ? popped : const UnitPageResult();

    // Keep showing where the student was until the fresh roadmap is in, then
    // walk the trail forward to where they are now.
    final walkedFrom = _walked.value;
    setState(() => _holdProgress = true);
    final fresh = await _reload();
    if (!mounted) return;
    if (fresh == null) {
      setState(() => _holdProgress = false);
      return;
    }

    if (outcome.join) {
      setState(() => _holdProgress = false);
      if (!(fresh.isSubscribed || _justSubscribed)) _promptSubscribe();
      return;
    }

    final completedId = outcome.lastCompletedId;
    if (completedId != null) setState(() => _justCompletedId = completedId);
    // The fresh data is in the bloc, but the trail is rebuilt from it on the
    // next frame; wait for it so the walk targets the new current unit.
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await _advanceTrail(from: walkedFrom);
    if (!mounted || completedId == null) return;

    final spot = _locate(fresh.modules ?? [], completedId);
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

  /// The return sequence: the finished pin pops, the walked trail draws
  /// forward to the new current unit while the view follows it, then the new
  /// current pin pops in (releasing [_holdProgress]).
  Future<void> _advanceTrail({required double from}) async {
    final trail = _trail;
    if (trail == null) {
      setState(() => _holdProgress = false);
      return;
    }
    final to = trail.walkedTo;
    if (_reduceMotion || (to - from).abs() < 0.001) {
      _walked.value = to;
      setState(() => _holdProgress = false);
      _scrollToCurrent(trail, animate: !_reduceMotion);
      return;
    }

    // Let the finished pin's pop start first.
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    final progress = Tween(begin: from, end: to).animate(
      CurvedAnimation(parent: _trailController, curve: Curves.easeInOutCubic),
    );
    void follow() => _walked.value = progress.value;
    progress.addListener(follow);
    _scrollToCurrent(trail, animate: true);
    try {
      await _trailController.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    } finally {
      progress.removeListener(follow);
    }
    if (!mounted) return;
    _walked.value = to;
    setState(() => _holdProgress = false);
  }

  void _scrollToCurrent(_Trail trail, {required bool animate}) {
    final controller = _scrollController;
    final index = trail.currentIndex;
    if (controller == null || !controller.hasClients || index == null) return;
    final target = _offsetFor(
      trail.nodes,
      index,
      controller.position.viewportDimension,
    );
    if (!animate) {
      controller.jumpTo(target);
      return;
    }
    controller.animateTo(
      target,
      duration: _trailController.duration!,
      curve: Curves.easeInOutCubic,
    );
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
      return state.maybeWhen<OutlineCourseEntity?>(
        success: (_, data) => data,
        orElse: () => null,
      );
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
  ) async {
    final modules = course.modules ?? [];
    final notice = pathCompletedNotice(
      pathTitle: spot.path.title ?? '',
      unitCount: spot.path.units?.length ?? 0,
      chapterDone: _isModuleFullyCompleted(spot.module),
      courseDone: modules.isNotEmpty && modules.every(_isModuleFullyCompleted),
    );
    MasirFeedback.celebrate();
    MasirToast.show(
      context,
      title: notice.title,
      message: notice.message,
      tone: NoticeTone.success,
      icon: notice.icon,
      duration: MasirToast.celebration,
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

  /// Flattens every module into one ordered list of stops: chapter → path →
  /// its units → next path → … → trophy (chapter fully done) → next chapter
  /// → … → finish. This is the only place that decides order, sizes and
  /// horizontal placement, so the trail and the stops can't disagree.
  ///
  /// Chapters, paths, trophies and the finish sit on the centre line; units
  /// weave around it ([weaveX]), swinging right in one path and left in the
  /// next, with a little seeded jitter so the trail reads as hand-drawn.
  _Trail _buildTrail(
    List<OutlineModuleEntity> modules,
    String? currentUnitId, {
    required bool subscribed,
  }) {
    final courseDone =
        modules.isNotEmpty && modules.every(_isModuleFullyCompleted);
    final rng = math.Random(_seedFor(widget.id));
    final stops = <({double x, TrailNode Function(bool bubbleOnLeft) make})>[];
    int? currentIndex;
    var pathCount = 0;

    for (var moduleIndex = 0; moduleIndex < modules.length; moduleIndex++) {
      final module = modules[moduleIndex];
      final paths = module.paths ?? [];
      final moduleProgress = _moduleProgress(module);
      final moduleDone = _isModuleFullyCompleted(module);
      stops.add((
        x: 0.5,
        make: (_) => TrailNode(
          height: kChapterStopHeight,
          leadingGap: moduleIndex == 0 ? 0 : kChapterStopGap,
          anchorId: module.id,
          build: (_) => RoadmapChapterPlate(
            index: moduleIndex,
            title: module.title ?? '',
            progress: moduleProgress,
            isComplete: moduleDone || moduleProgress >= 100,
          ),
        ),
      ));

      final lastUnitsPathIndex = paths.lastIndexWhere(
        (p) => (p.units ?? []).isNotEmpty,
      );
      for (var pathIndex = 0; pathIndex < paths.length; pathIndex++) {
        final path = paths[pathIndex];
        final units = path.units ?? [];
        final swingRight = pathCount.isEven;
        pathCount++;
        stops.add((
          x: 0.5,
          make: (_) => TrailNode(
            height: kPathStopHeight,
            build: (_) => RoadmapPathSign(
              title: path.title ?? '',
              progress: path.pathProgressPercent ?? 0,
            ),
          ),
        ));

        for (var unitIndex = 0; unitIndex < units.length; unitIndex++) {
          final unit = units[unitIndex];
          final x = weaveX(
            unitIndex,
            swingRight: swingRight,
            jitter: rng.nextDouble() * 2 - 1,
          );
          final isCurrent = unit.id == currentUnitId;
          if (isCurrent) currentIndex = stops.length;
          final isCompleted = unit.status == 'completed';
          final type = unit.type ?? '';
          stops.add((
            x: x,
            make: (bubbleOnLeft) => TrailNode(
              height: kUnitStopHeight,
              x: x,
              boxWidth: kRoadmapPinSize,
              unitId: unit.id,
              build: (_) => RoadmapUnitPin(
                unitId: unit.id ?? '',
                icon: UnitTypeStyle.iconOf(type),
                isCompleted: isCompleted,
                isLocked: unit.locked ?? false,
                // Until the return sequence reaches it, the new current unit
                // waits as a plain open pin.
                isCurrent: isCurrent && !_holdProgress,
                isPreview: !subscribed && unit.isPreview == true,
                celebrate: isCompleted && unit.id == _justCompletedId,
                bubbleOnLeft: bubbleOnLeft,
                semanticsLabel:
                    '${unit.title ?? ''}، ${UnitTypeStyle.labelOf(type)}',
                onTap: (rect) => _onUnitTap(
                  unit,
                  rect,
                  isCurrent: isCurrent,
                  subscribed: subscribed,
                ),
              ),
            ),
          ));
        }

        if (moduleDone && pathIndex == lastUnitsPathIndex) {
          stops.add((
            x: 0.5,
            make: (_) => TrailNode(
              height: kTrophyStopHeight,
              build: (_) => const RoadmapTrophy(),
            ),
          ));
        }
      }
    }

    // The finish is always the last stop, so the destination shows from the
    // first visit; it looks locked until every unit is done.
    if (modules.isNotEmpty) {
      stops.add((
        x: 0.5,
        make: (_) => TrailNode(
          height: kFinishStopHeight,
          build: (_) => RoadmapFinish(isComplete: courseDone),
        ),
      ));
    }

    // A pin's bubble goes on the side away from its neighbours, where the
    // trail doesn't run.
    bool bubbleOnLeft(int i) {
      final x = stops[i].x;
      final prev = stops[math.max(i - 1, 0)].x;
      final next = stops[math.min(i + 1, stops.length - 1)].x;
      final neighbours = (prev + next) / 2;
      if ((neighbours - x).abs() < 0.01) return x < 0.5;
      return neighbours > x;
    }

    final nodes = [
      for (var i = 0; i < stops.length; i++) stops[i].make(bubbleOnLeft(i)),
    ];
    final walkedTo =
        currentIndex?.toDouble() ??
        (courseDone ? (nodes.length - 1).toDouble() : 0.0);
    return _Trail(nodes, currentIndex, walkedTo);
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
                success: (isLoading, data) => _roadmap(data),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _roadmap(OutlineCourseEntity data) {
    final courseProgress = data.courseProgressPercent ?? 0;
    final modules = data.modules ?? [];
    final currentUnit = _findCurrentUnit(modules);
    final (doneUnits, totalUnits) = _unitCounts(modules);
    final subscribed = data.isSubscribed || _justSubscribed;
    final trail = _buildTrail(modules, currentUnit?.id, subscribed: subscribed);
    _trail = trail;
    if (!_holdProgress) _walked.value = trail.walkedTo;

    if (!_hasPlayedEntrance) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _playEntranceOnce();
      });
    }

    return _shell(
      bleed: true,
      stickyBottom: !subscribed
          ? _PreviewSubscribeBar(
              previewCount: data.previewUnitCount ?? _previewCount(modules),
              bloc: subscribeBloc,
              onSubscribe: _subscribe,
            )
          : currentUnit != null
          ? _ContinueBar(
              unitTitle: currentUnit.title ?? '',
              started: doneUnits > 0,
              onTap: () =>
                  _openUnit(currentUnit, origin: _originOf(trail.currentIndex)),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Open already scrolled to the current unit: no jump.
                _scrollController ??= ScrollController(
                  initialScrollOffset: _initialOffset(
                    trail,
                    constraints.maxHeight,
                  ),
                );
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    _kCanvasInset,
                    0,
                    _kCanvasInset,
                    _kCanvasBottom,
                  ),
                  child: SizedBox(
                    key: _canvasKey,
                    child: TrailCanvas(
                      nodes: trail.nodes,
                      seed: _seedFor(widget.id),
                      entrance: _entranceController,
                      walked: _walked,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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

/// What to tell the student when the last unit of a path is done.
@visibleForTesting
({String title, String message, IconData icon}) pathCompletedNotice({
  required String pathTitle,
  required int unitCount,
  required bool chapterDone,
  required bool courseDone,
}) {
  final title = courseDone
      ? 'دوره رو تموم کردی!'
      : chapterDone
      ? 'یک فصل کامل شد!'
      : 'این مسیر کامل شد!';
  final parts = [
    if (pathTitle.isNotEmpty) pathTitle,
    if (unitCount > 0) '${faDigits(unitCount)} واحد تموم شد',
  ];
  return (
    title: title,
    message: parts.join(' · '),
    icon: courseDone
        ? Icons.emoji_events_rounded
        : Icons.workspace_premium_rounded,
  );
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
