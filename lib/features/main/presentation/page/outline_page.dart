import 'dart:math' as math;

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_outline_course_model.dart';
import 'package:mohammad/features/main/domain/entities/outline_course.dart';
import 'package:mohammad/features/main/presentation/bloc/outline_course/outline_course_bloc.dart';
import 'package:mohammad/core/helper/custom_colors.dart';
import 'package:mohammad/core/helper/paper_surface.dart';
import 'package:mohammad/features/main/presentation/page/outline/roadmap/paper_theme.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page_args.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

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
const double _kRoadNodeSize = 44;

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

// ---------------------------------------------------------------------------
// The trail — drawn as a walkable path ribbon, not a thin line, so the
// roadmap reads as an actual route rather than a graph. Only the color
// changes between the part still ahead (purple) and the part already
// adventured (green).
//
// Each piece only strokes its two long edges (never the flat cut ends), and
// caps are plain filled circles with no outline — so wherever two segments
// meet the colors blend instead of forming a visible ring/knot.
// ---------------------------------------------------------------------------

class _TrailRibbon {
  const _TrailRibbon._();

  static const double halfWidth = 6.5;
  static const double _sampleStep = 8.0;

  /// The portion of [source] already adventured — solid green.
  static void drawWalked(Canvas canvas, Path source) {
    _drawSolid(
      canvas,
      source,
      fill: PaperTheme.trailWalked,
      edge: PaperTheme.trailWalkedEdge,
    );
  }

  /// The portion of [source] not yet adventured — solid purple.
  static void drawUnwalked(Canvas canvas, Path source) {
    _drawSolid(
      canvas,
      source,
      fill: PaperTheme.trailUnwalked,
      edge: PaperTheme.trailUnwalkedEdge,
    );
  }

  static void _drawSolid(
    Canvas canvas,
    Path source, {
    required Color fill,
    required Color edge,
  }) {
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (final metric in source.computeMetrics()) {
      if (metric.length <= 0.5) continue;
      _paintPiece(
        canvas,
        metric.extractPath(0, metric.length),
        fillPaint,
        edgePaint,
      );
    }
  }

  static void _paintPiece(
    Canvas canvas,
    Path piece,
    Paint fillPaint,
    Paint edgePaint,
  ) {
    final points = _samplePoints(piece);
    if (points == null) return;

    final fillPath = Path()..moveTo(points.left.first.dx, points.left.first.dy);
    for (final p in points.left.skip(1)) {
      fillPath.lineTo(p.dx, p.dy);
    }
    for (final p in points.right.reversed) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    final leftEdge = Path()..moveTo(points.left.first.dx, points.left.first.dy);
    for (final p in points.left.skip(1)) {
      leftEdge.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(leftEdge, edgePaint);

    final rightEdge = Path()
      ..moveTo(points.right.first.dx, points.right.first.dy);
    for (final p in points.right.skip(1)) {
      rightEdge.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(rightEdge, edgePaint);

    canvas.drawCircle(points.startCenter, halfWidth, fillPaint);
    canvas.drawCircle(points.endCenter, halfWidth, fillPaint);
  }

  static _RibbonPoints? _samplePoints(Path path) {
    final leftPts = <Offset>[];
    final rightPts = <Offset>[];
    Offset? startCenter;
    Offset? endCenter;

    for (final metric in path.computeMetrics()) {
      final len = metric.length;
      if (len <= 0) continue;

      var d = 0.0;
      while (d < len) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
          leftPts.add(tangent.position + normal * halfWidth);
          rightPts.add(tangent.position - normal * halfWidth);
          startCenter ??= tangent.position;
        }
        d += _sampleStep;
      }

      final endTangent = metric.getTangentForOffset(len);
      if (endTangent != null) {
        final normal = Offset(-endTangent.vector.dy, endTangent.vector.dx);
        leftPts.add(endTangent.position + normal * halfWidth);
        rightPts.add(endTangent.position - normal * halfWidth);
        endCenter = endTangent.position;
      }
    }

    if (leftPts.length < 2 || startCenter == null || endCenter == null) {
      return null;
    }
    return _RibbonPoints(leftPts, rightPts, startCenter, endCenter);
  }
}

class _RibbonPoints {
  final List<Offset> left;
  final List<Offset> right;
  final Offset startCenter;
  final Offset endCenter;

  const _RibbonPoints(this.left, this.right, this.startCenter, this.endCenter);
}

// ---------------------------------------------------------------------------
// Waypoint model — the single source of truth for both the line and the
// markers. `centered` waypoints (chapter/path/trophy) sit on the vertical
// midline; zigzag waypoints (units) alternate left/right.
// ---------------------------------------------------------------------------

class _TrailNode {
  final double height;
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

  /// Deterministic horizontal nudges for the two control points of the
  /// cubic bezier leading into this node, so consecutive segments bow in
  /// slightly different ways instead of every curve having identical
  /// symmetric tension.
  final double curveKickA;
  final double curveKickB;

  /// Whether the segment *leading into* this node should be drawn as
  /// already-walked (green) rather than still-ahead (purple).
  final bool incomingSolid;
  final Widget Function(double canvasWidth) build;

  const _TrailNode({
    required this.height,
    this.centered = true,
    this.isLeft = false,
    this.xJitter = 0,
    this.pinRadius = _kRoadNodeSize / 2,
    this.curveKickA = 0,
    this.curveKickB = 0,
    required this.incomingSolid,
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
  static const String routeName = "/outline";

  const OutlinePage({super.key, required this.title, required this.id});

  @override
  State<OutlinePage> createState() => _OutlinePageState();
}

class _OutlinePageState extends State<OutlinePage>
    with SingleTickerProviderStateMixin {
  final bloc = inject<OutlineCourseBloc>();
  late final AnimationController _entranceController;
  final _scrollController = ScrollController();
  bool _hasPlayedEntrance = false;
  bool _hasScrolledToCurrent = false;

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
    _entranceController.forward(from: 0);
  }

  /// Scrolls straight to the current unit's precomputed Y — no GlobalKey,
  /// no `ensureVisible` retry loop. The position is known analytically the
  /// moment the node list is built, so this can never fail to find it.
  void _scrollToCurrentUnitOnce(_NodeBuildResult result) {
    if (_hasScrolledToCurrent) return;
    final index = result.currentUnitIndex;
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

  String _getTypeLabel(String type) {
    switch (type) {
      case 'html':
        return 'درس';
      case 'practice':
        return 'تمرین';
      case 'quiz':
        return 'آزمون';
      case 'audio':
        return 'صوتی';
      default:
        return type;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'html':
        return Icons.description_outlined;
      case 'practice':
        return Icons.fact_check_outlined;
      case 'quiz':
        return Icons.help_outline;
      case 'audio':
        return Icons.headphones_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  Future<void> _onUnitTap({
    required String? id,
    required String? type,
    required String? title,
    required String? status,
    required bool locked,
  }) async {
    if (locked || id == null || id.isEmpty) return;

    await CustomNavigator.pushNamed(
      UnitPage.routeName,
      arguments: UnitPageArgs(
        unitId: id,
        unitType: type ?? '',
        unitTitle: title ?? '',
        status: status ?? '',
      ).toMap(),
    );

    if (!mounted) return;

    // Re-enable auto-scroll to the next current unit after returning.
    _hasScrolledToCurrent = false;

    bloc.add(
      OutlineCourseEvent.outlineCourse(
        params: RequestOutlineCourseModel(id: widget.id),
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

  bool _isPathFullyCompleted(OutlinePathEntity path) {
    final units = path.units ?? [];
    if (units.isEmpty) return (path.pathProgressPercent ?? 0) >= 100;
    return units.every((u) => u.status == 'completed');
  }

  String? _findCurrentUnitId(List<OutlineModuleEntity> modules) {
    for (final module in modules) {
      for (final path in module.paths ?? []) {
        for (final unit in path.units ?? []) {
          final locked = unit.locked ?? false;
          final completed = unit.status == 'completed';
          if (!locked && !completed) return unit.id;
        }
      }
    }
    return null;
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
  /// the actual waypoints, which are paths and units. Paths and units share
  /// one continuous left/right alternation (`zigzagCounter`) instead of
  /// paths always snapping back to dead-center, which read as an artificial
  /// hourglass rather than a winding trail.
  _NodeBuildResult _buildTrailNodes(
    List<OutlineModuleEntity> modules,
    String? currentUnitId,
  ) {
    final nodes = <_TrailNode>[];
    int? currentUnitIndex;
    bool? previousModuleFullyCompleted;
    var zigzagCounter = 0;

    // Fixed seed → same jitter every rebuild for the same course structure
    // (no flicker when the bloc re-emits after a tap), but different from
    // path to path so the trail reads as hand-drawn instead of mechanical.
    final rng = math.Random(1337);
    double jitter(double range) => (rng.nextDouble() * 2 - 1) * range;

    for (var moduleIndex = 0; moduleIndex < modules.length; moduleIndex++) {
      final module = modules[moduleIndex];
      final paths = module.paths ?? [];
      final moduleProgress = _moduleProgress(module);
      final isModuleFullyCompleted = _isModuleFullyCompleted(module);
      final chapterIsComplete = isModuleFullyCompleted || moduleProgress >= 100;

      nodes.add(
        _TrailNode(
          height: _kChapterNodeHeight,
          incomingSolid: previousModuleFullyCompleted ?? false,
          curveKickA: jitter(16),
          curveKickB: jitter(16),
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
        final pathFullyComplete = _isPathFullyCompleted(path);
        final firstUnitDone =
            units.isNotEmpty && units.first.status == 'completed';

        final pathIncomingSolid = pathIndex == 0
            ? (pathFullyComplete || firstUnitDone)
            : _isPathFullyCompleted(paths[pathIndex - 1]);

        final pathIsLeft = zigzagCounter % 2 == 0;
        zigzagCounter++;

        nodes.add(
          _TrailNode(
            height: _kPathNodeHeight,
            centered: false,
            isLeft: pathIsLeft,
            xJitter: jitter(0.055),
            pinRadius: 26,
            curveKickA: jitter(22),
            curveKickB: jitter(22),
            incomingSolid: pathIncomingSolid,
            build: (canvasWidth) => _PathWaypoint(
              path: path,
              isLeft: pathIsLeft,
              maxLabelWidth: (canvasWidth * 0.46).clamp(90.0, 150.0),
            ),
          ),
        );

        for (var unitIndex = 0; unitIndex < units.length; unitIndex++) {
          final unit = units[unitIndex];
          final isLeft = zigzagCounter % 2 == 0;
          zigzagCounter++;
          final isCompleted = unit.status == 'completed';
          final isLocked = unit.locked ?? false;
          final isCurrent = unit.id == currentUnitId;
          final unitType = unit.type ?? '';

          final incomingSolid = unitIndex == 0
              ? (pathFullyComplete || firstUnitDone)
              : isCompleted;

          if (isCurrent) currentUnitIndex = nodes.length;

          nodes.add(
            _TrailNode(
              height: _kUnitNodeHeight,
              centered: false,
              isLeft: isLeft,
              xJitter: jitter(0.05),
              curveKickA: jitter(18),
              curveKickB: jitter(18),
              incomingSolid: incomingSolid,
              build: (canvasWidth) => _RoadUnitNode(
                title: unit.title ?? '',
                typeLabel: _getTypeLabel(unitType),
                icon: _getTypeIcon(unitType),
                isCompleted: isCompleted,
                isLocked: isLocked,
                isCurrent: isCurrent,
                isLeft: isLeft,
                maxLabelWidth: (canvasWidth * 0.44).clamp(80.0, 130.0),
                onTap: () => _onUnitTap(
                  id: unit.id,
                  type: unitType,
                  title: unit.title,
                  status: unit.status,
                  locked: isLocked,
                ),
              ),
            ),
          );
        }

        if (isModuleFullyCompleted && pathIndex == lastUnitsPathIndex) {
          nodes.add(
            _TrailNode(
              height: _kTrophyNodeHeight,
              incomingSolid: true,
              curveKickA: jitter(16),
              curveKickB: jitter(16),
              build: (_) => const _TrophyNode(),
            ),
          );
        }
      }

      previousModuleFullyCompleted = isModuleFullyCompleted;
    }

    return _NodeBuildResult(nodes, currentUnitIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BaseScreen(
        usePaperGrain: false,
        backgroundColor: AppColor.background,
        body: Column(
          children: [
            CustomAppBar(title: widget.title),
            10.h,
            BlocBuilder<OutlineCourseBloc, OutlineCourseState>(
              bloc: bloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => CustomLoading(),
                  error: (_, message) => CustomError(message: message),
                  success: (isLoading, data) {
                    final courseProgress = data.courseProgressPercent ?? 0;
                    final modules = data.modules ?? [];
                    final currentUnitId = _findCurrentUnitId(modules);
                    final result = _buildTrailNodes(modules, currentUnitId);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      _playEntranceOnce();
                      _scrollToCurrentUnitOnce(result);
                    });

                    return Expanded(
                      child: Column(
                        children: [
                          _CourseProgressHeader(progress: courseProgress),
                          const SizedBox(height: 10),
                          Expanded(
                            child: PaperBackdrop(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  0,
                                  12,
                                  32,
                                ),
                                child: _TrailCanvas(
                                  nodes: result.nodes,
                                  entrance: _entranceController,
                                ),
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
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Course header ("ledger" card)
// ---------------------------------------------------------------------------

class _CourseProgressHeader extends StatelessWidget {
  final int progress;

  const _CourseProgressHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: PaperTheme.cardPaper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PaperTheme.paperEdge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'مسیر یادگیری',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: PaperTheme.ink,
              ),
              _StampBadge(
                size: 32,
                ringColor: PaperTheme.accent,
                child: CustomText(
                  '$progress٪',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: PaperTheme.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100.0,
              minHeight: 6,
              backgroundColor: PaperTheme.inkFaint.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                PaperTheme.accent,
              ),
            ),
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
                  painter: _FullTrailPainter(nodes: nodes, centersY: centersY),
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
  final Widget child;

  const _ZigZagSlot({
    required this.isLeft,
    required this.width,
    required this.xJitter,
    required this.pinRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final base = isLeft ? _kRoadSideRatio : (1 - _kRoadSideRatio);
    final nodeCenterX = (base + xJitter) * width;
    final nodeRadius = pinRadius;

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

  _FullTrailPainter({required this.nodes, required this.centersY});

  double _x(_TrailNode node, double width) {
    if (node.centered) return width / 2;
    final base = node.isLeft ? _kRoadSideRatio : (1 - _kRoadSideRatio);
    return (base + node.xJitter) * width;
  }

  @override
  void paint(Canvas canvas, Size size) {
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

      if (nodes[i].incomingSolid) {
        _TrailRibbon.drawWalked(canvas, segment);
      } else {
        _TrailRibbon.drawUnwalked(canvas, segment);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FullTrailPainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// Waypoint widgets — pure visuals, no positioning logic of their own.
// ---------------------------------------------------------------------------

/// Chapter title plate — a full-width header card, *not* a trail marker.
/// It still sits on the timeline (so the trail keeps flowing between
/// modules), but it reads as a section title. All "waypoint" styling is
/// reserved for paths and units, which is what should actually look like
/// beads on the trail.
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
    final accent = isComplete ? PaperTheme.success : PaperTheme.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: PaperTheme.cardPaper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PaperTheme.paperEdge),
        boxShadow: [
          BoxShadow(
            color: PaperTheme.ink.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PaperTheme.cardPaper,
              border: Border.all(color: accent, width: 1.8),
            ),
            child: isComplete
                ? const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: PaperTheme.success,
                  )
                : CustomText(
                    persianDigits(index + 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: PaperTheme.ink,
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  title,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PaperTheme.ink,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress / 100.0,
                    minHeight: 4,
                    backgroundColor: PaperTheme.inkFaint.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          CustomText(
            isComplete ? 'کامل' : '$progress٪',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: accent,
          ),
        ],
      ),
    );
  }
}

/// Circular "wax seal" style badge reused for numbering, percentages, and
/// the completed-unit stamp.
class _StampBadge extends StatelessWidget {
  final Widget child;
  final double size;
  final Color ringColor;

  const _StampBadge({
    required this.child,
    required this.size,
    required this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.05,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PaperTheme.cardPaper,
          border: Border.all(color: ringColor, width: 2),
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ringColor.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Path waypoint — a rounded-*square* marker (never a circle, so it can
/// never be mistaken for a chapter's badge or a unit's pin) with its title
/// in a pill tag beside it. Positioned in the same left/right zigzag as
/// units (see `_buildTrailNodes`'s `zigzagCounter`) instead of always
/// sitting dead-center, so the trail keeps winding naturally through every
/// path instead of snapping back to the middle each time.
class _PathWaypoint extends StatelessWidget {
  final OutlinePathEntity path;
  final bool isLeft;
  final double maxLabelWidth;

  const _PathWaypoint({
    required this.path,
    required this.isLeft,
    required this.maxLabelWidth,
  });

  @override
  Widget build(BuildContext context) {
    final pathProgress = path.pathProgressPercent ?? 0;
    final isComplete = pathProgress >= 100;
    final accent = isComplete ? PaperTheme.success : PaperTheme.accent;

    final pin = Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PaperTheme.cardPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent, width: 2.2),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        isComplete ? Icons.flag_circle_rounded : Icons.route_outlined,
        size: 24,
        color: accent,
      ),
    );

    final label = Container(
      constraints: BoxConstraints(maxWidth: maxLabelWidth),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: PaperTheme.cardPaper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: isLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            path.title ?? '',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: PaperTheme.ink,
            textAlign: isLeft ? TextAlign.left : TextAlign.right,
            maxLines: 2,
          ),
          const SizedBox(height: 2),
          CustomText(
            isComplete ? 'مسیر کامل شد' : 'پیشرفت مسیر $pathProgress٪',
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: accent,
            textAlign: isLeft ? TextAlign.left : TextAlign.right,
          ),
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: isLeft
          ? [pin, const SizedBox(width: 10), label]
          : [label, const SizedBox(width: 10), pin],
    );
  }
}

/// Trophy waypoint at the end of a completed module — a wax-seal medallion
/// with a short "completed" caption.
class _TrophyNode extends StatelessWidget {
  const _TrophyNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: -0.06,
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PaperTheme.cardPaper,
              border: Border.all(color: PaperTheme.accent, width: 2.4),
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: PaperTheme.accent.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 26,
                color: PaperTheme.accent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const CustomText(
          'این فصل کامل شد',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: PaperTheme.success,
        ),
      ],
    );
  }
}

/// A single unit "waypoint" — pin/stamp marker plus its paper label tag.
class _RoadUnitNode extends StatelessWidget {
  final String title;
  final String typeLabel;
  final IconData icon;
  final bool isCompleted;
  final bool isLocked;
  final bool isCurrent;
  final bool isLeft;
  final double maxLabelWidth;
  final VoidCallback onTap;

  const _RoadUnitNode({
    required this.title,
    required this.typeLabel,
    required this.icon,
    required this.isCompleted,
    required this.isLocked,
    required this.isCurrent,
    required this.isLeft,
    required this.maxLabelWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget pin;

    if (isCompleted) {
      pin = _StampBadge(
        size: _kRoadNodeSize,
        ringColor: PaperTheme.success,
        child: const Icon(
          Icons.check_rounded,
          size: 20,
          color: PaperTheme.success,
        ),
      );
    } else if (isLocked) {
      pin = _DashedCircle(
        size: _kRoadNodeSize,
        child: const Icon(
          Icons.lock_outline_rounded,
          size: 18,
          color: PaperTheme.locked,
        ),
      );
    } else if (isCurrent) {
      pin = Container(
        width: _kRoadNodeSize,
        height: _kRoadNodeSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PaperTheme.cardPaper,
          border: Border.all(color: PaperTheme.accent, width: 2.4),
          boxShadow: [
            BoxShadow(
              color: PaperTheme.accent.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.flag_rounded,
          size: 20,
          color: PaperTheme.accent,
        ),
      );
    } else {
      pin = Container(
        width: _kRoadNodeSize,
        height: _kRoadNodeSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PaperTheme.cardPaper,
          border: Border.all(color: PaperTheme.inkFaint, width: 1.6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: PaperTheme.accent.withValues(alpha: 0.8),
        ),
      );
    }

    final tagRotation = isLeft ? -0.035 : 0.035;
    final label = Transform.rotate(
      angle: tagRotation,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxLabelWidth),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: PaperTheme.cardPaper,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isLocked ? PaperTheme.inkFaint : PaperTheme.paperEdge,
          ),
        ),
        child: Column(
          crossAxisAlignment: isLeft
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              title,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isLocked ? PaperTheme.locked : PaperTheme.ink,
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
              maxLines: 2,
            ),
            const SizedBox(height: 2),
            CustomText(
              typeLabel,
              fontSize: 11,
              color: PaperTheme.inkMuted,
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
            ),
          ],
        ),
      ),
    );

    return OnClick(
      onTap: isLocked ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: isLeft
            ? [pin, const SizedBox(width: 10), label]
            : [label, const SizedBox(width: 10), pin],
      ),
    );
  }
}

/// Circle with a dashed ink outline (locked waypoints).
class _DashedCircle extends StatelessWidget {
  final double size;
  final Widget child;

  const _DashedCircle({required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: const _DashedCirclePainter(),
          ),
          Container(
            width: size - 8,
            height: size - 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: PaperTheme.cardPaper,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PaperTheme.locked
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final path = Path()
      ..addOval(Rect.fromLTWH(1, 1, size.width - 2, size.height - 2));
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) => false;
}
