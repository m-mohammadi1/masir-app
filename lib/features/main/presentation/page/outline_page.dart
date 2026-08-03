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

/// Horizontal inset for zigzag nodes / trail (matches painter & widgets).
/// Kept moderate (not 0.5) so the route still zigzags, but gentle enough
/// that a thick trail reads as a winding path rather than a coiling snake.
const double _kRoadSideRatio = 0.30;
const double _kRoadNodeSize = 44;

// ---------------------------------------------------------------------------
// The trail — drawn as a walkable path ribbon, not a thin line, so the
// roadmap reads as an actual route rather than a graph. It's one continuous
// ribbon throughout; only the color changes between the part still ahead
// (purple) and the part already adventured (green).
//
// Each piece only strokes its two long edges (never the flat cut ends), and
// caps are plain filled circles with no outline — so wherever two pieces
// meet (module bridges, path headers) the colors blend instead of forming
// a visible ring/knot.
// ---------------------------------------------------------------------------

class _TrailRibbon {
  const _TrailRibbon._();

  static const double halfWidth = 6.5;
  static const double _sampleStep = 8.0;

  /// The portion of [source] already adventured — solid green.
  static void drawWalked(Canvas canvas, Path source, double progress) {
    _drawSolid(
      canvas,
      source,
      progress,
      fill: PaperTheme.trailWalked,
      edge: PaperTheme.trailWalkedEdge,
    );
  }

  /// The portion of [source] not yet adventured — solid purple.
  static void drawUnwalked(Canvas canvas, Path source, double progress) {
    _drawSolid(
      canvas,
      source,
      progress,
      fill: PaperTheme.trailUnwalked,
      edge: PaperTheme.trailUnwalkedEdge,
    );
  }

  static void _drawSolid(
    Canvas canvas,
    Path source,
    double progress, {
    required Color fill,
    required Color edge,
  }) {
    final clamped = progress.clamp(0.0, 1.0);
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (final metric in source.computeMetrics()) {
      final length = metric.length * clamped;
      if (length <= 0.5) continue;
      _paintPiece(canvas, metric.extractPath(0, length), fillPaint, edgePaint);
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
  final _currentUnitKey = GlobalKey();
  bool _hasPlayedEntrance = false;
  bool _hasScrolledToCurrent = false;
  int _scrollRetryCount = 0;

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

  void _scrollToCurrentUnitOnce() {
    if (_hasScrolledToCurrent) return;

    final targetContext = _currentUnitKey.currentContext;
    if (targetContext == null) {
      if (_scrollRetryCount >= 12) {
        _hasScrolledToCurrent = true;
        return;
      }
      _scrollRetryCount++;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToCurrentUnitOnce();
      });
      return;
    }

    _hasScrolledToCurrent = true;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      final ctx = _currentUnitKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeInOutCubic,
        alignment: 0.35,
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
    _scrollRetryCount = 0;

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
            16.h,
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

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      _playEntranceOnce();
                      if (currentUnitId != null) {
                        _scrollToCurrentUnitOnce();
                      } else {
                        _hasScrolledToCurrent = true;
                      }
                    });

                    return Expanded(
                      child: Column(
                        children: [
                          _CourseProgressHeader(progress: courseProgress),
                          const SizedBox(height: 16),
                          Expanded(
                            child: PaperBackdrop(
                              child: ListView(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  bottom: 32,
                                  top: 4,
                                ),
                                children: List.generate(modules.length, (
                                  moduleIndex,
                                ) {
                                  final module = modules[moduleIndex];
                                  final paths = module.paths ?? [];
                                  final moduleProgress = _moduleProgress(
                                    module,
                                  );
                                  final isFullyCompleted =
                                      _isModuleFullyCompleted(module);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: _ModuleRoadmap(
                                      module: module,
                                      paths: paths,
                                      moduleProgress: moduleProgress,
                                      isFullyCompleted: isFullyCompleted,
                                      moduleIndex: moduleIndex,
                                      currentUnitId: currentUnitId,
                                      currentUnitKey: _currentUnitKey,
                                      entrance: _entranceController,
                                      getTypeLabel: _getTypeLabel,
                                      getTypeIcon: _getTypeIcon,
                                      onUnitTap: _onUnitTap,
                                    ),
                                  );
                                }),
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
      padding: const EdgeInsets.all(16),
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
                size: 36,
                ringColor: PaperTheme.accent,
                child: CustomText(
                  '$progress٪',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: PaperTheme.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
// Module sheet ("chapter plate" + its path sections)
// ---------------------------------------------------------------------------

class _ModuleRoadmap extends StatelessWidget {
  final OutlineModuleEntity module;
  final List<OutlinePathEntity> paths;
  final int moduleProgress;
  final bool isFullyCompleted;
  final int moduleIndex;
  final String? currentUnitId;
  final GlobalKey currentUnitKey;
  final Animation<double> entrance;
  final String Function(String) getTypeLabel;
  final IconData Function(String) getTypeIcon;
  final Future<void> Function({
    required String? id,
    required String? type,
    required String? title,
    required String? status,
    required bool locked,
  })
  onUnitTap;

  const _ModuleRoadmap({
    required this.module,
    required this.paths,
    required this.moduleProgress,
    required this.isFullyCompleted,
    required this.moduleIndex,
    required this.currentUnitId,
    required this.currentUnitKey,
    required this.entrance,
    required this.getTypeLabel,
    required this.getTypeIcon,
    required this.onUnitTap,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = isFullyCompleted || moduleProgress >= 100;

    return Container(
      decoration: BoxDecoration(
        color: PaperTheme.cardPaper,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PaperTheme.paperEdge, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: PaperTheme.ink.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ChapterPlateHeader(
            index: moduleIndex,
            title: module.title ?? '',
            progress: moduleProgress,
            isComplete: isComplete,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: _DashedDivider(),
          ),
          ..._buildPathSections(
            paths: paths,
            moduleIndex: moduleIndex,
            currentUnitId: currentUnitId,
            currentUnitKey: currentUnitKey,
            entrance: entrance,
            getTypeLabel: getTypeLabel,
            getTypeIcon: getTypeIcon,
            onUnitTap: onUnitTap,
            isFullyCompleted: isFullyCompleted,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  List<Widget> _buildPathSections({
    required List<OutlinePathEntity> paths,
    required int moduleIndex,
    required String? currentUnitId,
    required GlobalKey currentUnitKey,
    required Animation<double> entrance,
    required String Function(String) getTypeLabel,
    required IconData Function(String) getTypeIcon,
    required Future<void> Function({
      required String? id,
      required String? type,
      required String? title,
      required String? status,
      required bool locked,
    })
    onUnitTap,
    required bool isFullyCompleted,
  }) {
    final sections = <Widget>[];
    final lastUnitsPathIndex = paths.lastIndexWhere(
      (p) => (p.units ?? []).isNotEmpty,
    );

    for (var pathIndex = 0; pathIndex < paths.length; pathIndex++) {
      final path = paths[pathIndex];
      final units = path.units ?? [];
      final zigzagOffset = pathIndex;

      // First path header sits above its units; later headers sit inside the bridge.
      if (pathIndex == 0) {
        sections.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
            child: _PathHeaderCard(path: path),
          ),
        );
      }

      if (units.isNotEmpty) {
        final hasPrevBridge =
            pathIndex > 0 && (paths[pathIndex - 1].units ?? []).isNotEmpty;
        final hasNextBridge =
            pathIndex < paths.length - 1 &&
            (paths[pathIndex + 1].units ?? []).isNotEmpty;
        final startFromPathHeader = pathIndex == 0;
        final connectToTrophy =
            isFullyCompleted && pathIndex == lastUnitsPathIndex;

        sections.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: _ZigZagRoadmap(
              units: units,
              zigzagOffset: zigzagOffset,
              currentUnitId: currentUnitId,
              currentUnitKey: currentUnitKey,
              entrance: entrance,
              getTypeLabel: getTypeLabel,
              getTypeIcon: getTypeIcon,
              onUnitTap: onUnitTap,
              staggerBase: moduleIndex * 0.15 + pathIndex * 0.08,
              extendFromTop: hasPrevBridge,
              extendToBottom: hasNextBridge || connectToTrophy,
              // First path: trail grows out of path-header bottom-center.
              startFromCenter: startFromPathHeader,
              pathFullyComplete: _isPathFullyCompleted(path),
              entryBridgeSolid: hasPrevBridge
                  ? _isPathFullyCompleted(paths[pathIndex - 1])
                  : false,
            ),
          ),
        );

        if (connectToTrophy) {
          final fromIsLeft = (units.length - 1 + zigzagOffset) % 2 == 0;
          sections.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _TrophyConnector(
                fromIsLeft: fromIsLeft,
                entrance: entrance,
              ),
            ),
          );
        }
      }

      // Bridge: last unit of this path → first unit of the next path.
      if (pathIndex < paths.length - 1) {
        final nextPath = paths[pathIndex + 1];
        final nextUnits = nextPath.units ?? [];
        if (units.isNotEmpty && nextUnits.isNotEmpty) {
          final fromIsLeft = (units.length - 1 + zigzagOffset) % 2 == 0;
          final toIsLeft = (pathIndex + 1) % 2 == 0;
          final pathComplete = _isPathFullyCompleted(path);

          sections.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _InterPathConnector(
                fromIsLeft: fromIsLeft,
                toIsLeft: toIsLeft,
                isPathComplete: pathComplete,
                entrance: entrance,
                child: _PathHeaderCard(path: nextPath),
              ),
            ),
          );
        } else {
          sections.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 4),
              child: _PathHeaderCard(path: nextPath),
            ),
          );
        }
      }
    }

    return sections;
  }

  bool _isPathFullyCompleted(OutlinePathEntity path) {
    final units = path.units ?? [];
    if (units.isEmpty) return (path.pathProgressPercent ?? 0) >= 100;
    return units.every((u) => u.status == 'completed');
  }
}

/// "Chapter plate" — numbered stamp badge, title, and a percent stamp.
class _ChapterPlateHeader extends StatelessWidget {
  final int index;
  final String title;
  final int progress;
  final bool isComplete;

  const _ChapterPlateHeader({
    required this.index,
    required this.title,
    required this.progress,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StampBadge(
            size: 38,
            ringColor: isComplete ? PaperTheme.success : PaperTheme.accent,
            child: isComplete
                ? const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: PaperTheme.success,
                  )
                : CustomText(
                    persianDigits(index + 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PaperTheme.ink,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: PaperTheme.ink,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                CustomText(
                  isComplete ? 'این فصل کامل شد' : 'پیشرفت فصل',
                  fontSize: 12,
                  color: PaperTheme.inkMuted,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _StampBadge(
            size: 40,
            ringColor: isComplete ? PaperTheme.success : PaperTheme.accent,
            child: CustomText(
              isComplete ? '✓' : '$progress٪',
              fontSize: isComplete ? 16 : 11,
              fontWeight: FontWeight.bold,
              color: isComplete ? PaperTheme.success : PaperTheme.ink,
            ),
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

/// Thin horizontal dashed rule (ink on paper), used instead of progress bars.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      child: CustomPaint(painter: _DashPainter()),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PaperTheme.inkFaint
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + dashWidth, size.width), y),
        paint,
      );
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Path header ("trail tag")
// ---------------------------------------------------------------------------

class _PathHeaderCard extends StatelessWidget {
  final OutlinePathEntity path;

  const _PathHeaderCard({required this.path});

  @override
  Widget build(BuildContext context) {
    final pathProgress = path.pathProgressPercent ?? 0;
    final isComplete = pathProgress >= 100;

    return Transform.rotate(
      angle: -0.012,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: PaperTheme.pagePaper,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isComplete ? PaperTheme.success : PaperTheme.paperEdge,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isComplete ? Icons.flag_circle_rounded : Icons.route_outlined,
              size: 18,
              color: isComplete ? PaperTheme.success : PaperTheme.accent,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomText(
                path.title ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PaperTheme.ink,
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 8),
            CustomText(
              isComplete ? 'کامل' : '$pathProgress٪',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isComplete ? PaperTheme.success : PaperTheme.accent,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trophy → wax-seal medallion at the end of a completed module.
// ---------------------------------------------------------------------------

class _TrophyConnector extends StatelessWidget {
  static const double _topGap = 40;
  static const double _circleSize = 64;

  final bool fromIsLeft;
  final Animation<double> entrance;

  const _TrophyConnector({required this.fromIsLeft, required this.entrance});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: entrance,
      builder: (context, _) {
        final progress = Curves.easeOutCubic.transform(entrance.value);
        return CustomPaint(
          painter: _TrophyPathPainter(
            fromIsLeft: fromIsLeft,
            progress: progress,
            topGap: _topGap,
            circleSize: _circleSize,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: _topGap, bottom: 18),
            child: Center(
              child: Transform.rotate(
                angle: -0.06,
                child: Container(
                  width: _circleSize,
                  height: _circleSize,
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
            ),
          ),
        );
      },
    );
  }
}

class _TrophyPathPainter extends CustomPainter {
  final bool fromIsLeft;
  final double progress;
  final double topGap;
  final double circleSize;

  _TrophyPathPainter({
    required this.fromIsLeft,
    required this.progress,
    required this.topGap,
    required this.circleSize,
  });

  double _x(bool isLeft, double width) =>
      isLeft ? width * _kRoadSideRatio : width * (1 - _kRoadSideRatio);

  @override
  void paint(Canvas canvas, Size size) {
    final startX = _x(fromIsLeft, size.width);
    final endX = size.width / 2;
    const startY = 0.0;
    final endY = topGap + circleSize / 2;
    final dy = endY - startY;

    final road = Path()
      ..moveTo(startX, startY)
      ..cubicTo(startX, startY + dy * 0.55, endX, endY - dy * 0.45, endX, endY);

    _TrailRibbon.drawWalked(canvas, road, progress);
  }

  @override
  bool shouldRepaint(covariant _TrophyPathPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fromIsLeft != fromIsLeft ||
        oldDelegate.topGap != topGap ||
        oldDelegate.circleSize != circleSize;
  }
}

// ---------------------------------------------------------------------------
// Bridge between two paths inside the same module.
// ---------------------------------------------------------------------------

class _InterPathConnector extends StatelessWidget {
  final bool fromIsLeft;
  final bool toIsLeft;
  final bool isPathComplete;
  final Animation<double> entrance;
  final Widget child;

  const _InterPathConnector({
    required this.fromIsLeft,
    required this.toIsLeft,
    required this.isPathComplete,
    required this.entrance,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: entrance,
      builder: (context, _) {
        final progress = Curves.easeOutCubic.transform(entrance.value);
        return CustomPaint(
          painter: _InterPathPainter(
            fromIsLeft: fromIsLeft,
            toIsLeft: toIsLeft,
            isPathComplete: isPathComplete,
            progress: progress,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: child,
          ),
        );
      },
    );
  }
}

class _InterPathPainter extends CustomPainter {
  final bool fromIsLeft;
  final bool toIsLeft;
  final bool isPathComplete;
  final double progress;

  _InterPathPainter({
    required this.fromIsLeft,
    required this.toIsLeft,
    required this.isPathComplete,
    required this.progress,
  });

  double _x(bool isLeft, double width) =>
      isLeft ? width * _kRoadSideRatio : width * (1 - _kRoadSideRatio);

  @override
  void paint(Canvas canvas, Size size) {
    final startX = _x(fromIsLeft, size.width);
    final endX = _x(toIsLeft, size.width);
    const startY = 0.0;
    final endY = size.height;
    final dy = endY - startY;

    final road = Path()
      ..moveTo(startX, startY)
      ..cubicTo(startX, startY + dy * 0.7, endX, endY - dy * 0.7, endX, endY);

    if (isPathComplete) {
      _TrailRibbon.drawWalked(canvas, road, progress);
    } else {
      _TrailRibbon.drawUnwalked(canvas, road, progress);
    }
  }

  @override
  bool shouldRepaint(covariant _InterPathPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fromIsLeft != fromIsLeft ||
        oldDelegate.toIsLeft != toIsLeft ||
        oldDelegate.isPathComplete != isPathComplete;
  }
}

// ---------------------------------------------------------------------------
// Units of a single path, laid out in a zigzag along a trail.
// ---------------------------------------------------------------------------

class _ZigZagRoadmap extends StatefulWidget {
  final List<OutlineUnitEntity> units;
  final int zigzagOffset;
  final String? currentUnitId;
  final GlobalKey currentUnitKey;
  final Animation<double> entrance;
  final double staggerBase;
  final String Function(String) getTypeLabel;
  final IconData Function(String) getTypeIcon;
  final Future<void> Function({
    required String? id,
    required String? type,
    required String? title,
    required String? status,
    required bool locked,
  })
  onUnitTap;
  final bool extendFromTop;
  final bool extendToBottom;
  final bool startFromCenter;
  final bool pathFullyComplete;
  final bool entryBridgeSolid;

  const _ZigZagRoadmap({
    required this.units,
    required this.zigzagOffset,
    required this.currentUnitId,
    required this.currentUnitKey,
    required this.entrance,
    required this.staggerBase,
    required this.getTypeLabel,
    required this.getTypeIcon,
    required this.onUnitTap,
    this.extendFromTop = false,
    this.extendToBottom = false,
    this.startFromCenter = false,
    this.pathFullyComplete = false,
    this.entryBridgeSolid = false,
  });

  @override
  State<_ZigZagRoadmap> createState() => _ZigZagRoadmapState();
}

class _ZigZagRoadmapState extends State<_ZigZagRoadmap> {
  static const double _nodeHeight = 118;

  @override
  Widget build(BuildContext context) {
    final count = widget.units.length;
    final completedFlags = widget.units
        .map((u) => u.status == 'completed')
        .toList();

    return AnimatedBuilder(
      animation: widget.entrance,
      builder: (context, _) {
        return SizedBox(
          height: count * _nodeHeight,
          child: CustomPaint(
            painter: _RoadPathPainter(
              itemCount: count,
              itemHeight: _nodeHeight,
              zigzagOffset: widget.zigzagOffset,
              progress: Curves.easeOutCubic.transform(widget.entrance.value),
              completedFlags: completedFlags,
              extendFromTop: widget.extendFromTop,
              extendToBottom: widget.extendToBottom,
              startFromCenter: widget.startFromCenter,
              pathFullyComplete: widget.pathFullyComplete,
              entryBridgeSolid: widget.entryBridgeSolid,
            ),
            child: Column(
              children: List.generate(count, (index) {
                final unit = widget.units[index];
                final isLeft = (index + widget.zigzagOffset) % 2 == 0;
                final isCompleted = unit.status == 'completed';
                final isLocked = unit.locked ?? false;
                final isCurrent = unit.id == widget.currentUnitId;
                final unitType = unit.type ?? '';

                final start = (widget.staggerBase + index * 0.07).clamp(
                  0.0,
                  0.85,
                );
                final end = (start + 0.35).clamp(0.0, 1.0);
                final t = Interval(
                  start,
                  end,
                  curve: Curves.easeOutBack,
                ).transform(widget.entrance.value);

                return SizedBox(
                  height: _nodeHeight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final nodeCenterX = isLeft
                          ? width * _kRoadSideRatio
                          : width * (1 - _kRoadSideRatio);
                      final nodeRadius = _kRoadNodeSize / 2;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            // Keep circle center on the trail at every width.
                            left: isLeft ? nodeCenterX - nodeRadius : null,
                            right: isLeft
                                ? null
                                : width - nodeCenterX - nodeRadius,
                            child: Align(
                              alignment: Alignment.center,
                              child: Transform.translate(
                                offset: Offset(
                                  (1 - t) * (isLeft ? -30 : 30),
                                  (1 - t) * 18,
                                ),
                                child: Opacity(
                                  opacity: t.clamp(0.0, 1.0),
                                  child: KeyedSubtree(
                                    key: isCurrent
                                        ? widget.currentUnitKey
                                        : null,
                                    child: _RoadUnitNode(
                                      title: unit.title ?? '',
                                      typeLabel: widget.getTypeLabel(unitType),
                                      icon: widget.getTypeIcon(unitType),
                                      isCompleted: isCompleted,
                                      isLocked: isLocked,
                                      isCurrent: isCurrent,
                                      isLeft: isLeft,
                                      maxLabelWidth: (width * 0.44).clamp(
                                        80.0,
                                        130.0,
                                      ),
                                      onTap: () => widget.onUnitTap(
                                        id: unit.id,
                                        type: unitType,
                                        title: unit.title,
                                        status: unit.status,
                                        locked: isLocked,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

/// A single "waypoint" — pin/stamp marker plus its paper label tag.
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

// ---------------------------------------------------------------------------
// The trail itself (unit-to-unit + entry/exit bridges).
// ---------------------------------------------------------------------------

class _RoadPathPainter extends CustomPainter {
  final int itemCount;
  final double itemHeight;
  final int zigzagOffset;
  final double progress;
  final List<bool> completedFlags;
  final bool extendFromTop;
  final bool extendToBottom;
  final bool startFromCenter;
  final bool pathFullyComplete;
  final bool entryBridgeSolid;

  _RoadPathPainter({
    required this.itemCount,
    required this.itemHeight,
    required this.zigzagOffset,
    required this.progress,
    required this.completedFlags,
    this.extendFromTop = false,
    this.extendToBottom = false,
    this.startFromCenter = false,
    this.pathFullyComplete = false,
    this.entryBridgeSolid = false,
  });

  double _nodeX(int index, double width) {
    final isLeft = (index + zigzagOffset) % 2 == 0;
    return isLeft ? width * _kRoadSideRatio : width * (1 - _kRoadSideRatio);
  }

  double _nodeY(int index) => index * itemHeight + itemHeight / 2;

  Path _segment(double x1, double y1, double x2, double y2) {
    final dy = y2 - y1;
    return Path()
      ..moveTo(x1, y1)
      ..cubicTo(x1, y1 + dy * 0.55, x2, y2 - dy * 0.55, x2, y2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (itemCount < 1) return;

    void paintTrail(Path road, {required bool solid}) {
      if (solid) {
        _TrailRibbon.drawWalked(canvas, road, progress);
      } else {
        _TrailRibbon.drawUnwalked(canvas, road, progress);
      }
    }

    // From path-header bottom-center → first unit. This should turn green
    // as soon as the first unit itself is done, not only once the whole
    // path is finished — otherwise it would rarely ever color in.
    if (startFromCenter) {
      final entry = _segment(
        size.width / 2,
        0,
        _nodeX(0, size.width),
        _nodeY(0),
      );
      final firstUnitDone = completedFlags.isNotEmpty && completedFlags.first;
      paintTrail(entry, solid: pathFullyComplete || firstUnitDone);
    }

    // Incoming bridge from previous path → first unit.
    if (extendFromTop) {
      final firstX = _nodeX(0, size.width);
      final entry = _segment(firstX, 0, firstX, _nodeY(0));
      paintTrail(entry, solid: entryBridgeSolid);
    }

    // Unit-to-unit trail.
    if (itemCount >= 2) {
      final road = Path()..moveTo(_nodeX(0, size.width), _nodeY(0));

      for (int i = 0; i < itemCount - 1; i++) {
        final startX = _nodeX(i, size.width);
        final endX = _nodeX(i + 1, size.width);
        final startY = _nodeY(i);
        final endY = _nodeY(i + 1);
        final dy = endY - startY;

        road.cubicTo(
          startX,
          startY + dy * 0.55,
          endX,
          endY - dy * 0.55,
          endX,
          endY,
        );
      }

      if (pathFullyComplete) {
        _TrailRibbon.drawWalked(canvas, road, progress);
      } else {
        // Faint sketched path for the whole trail, then a solid dirt-path
        // overlay for the portion already walked.
        _TrailRibbon.drawUnwalked(canvas, road, progress);

        final completedCount = completedFlags
            .where((done) => done)
            .length
            .clamp(0, itemCount);
        if (completedCount > 0) {
          final doneRatio = ((completedCount - 1) / (itemCount - 1)).clamp(
            0.0,
            1.0,
          );
          _TrailRibbon.drawWalked(canvas, road, math.min(progress, doneRatio));
        }
      }
    }

    // Outgoing bridge from last unit → next path.
    if (extendToBottom) {
      final lastX = _nodeX(itemCount - 1, size.width);
      final exit = _segment(lastX, _nodeY(itemCount - 1), lastX, size.height);
      paintTrail(exit, solid: pathFullyComplete);
    }
  }

  @override
  bool shouldRepaint(covariant _RoadPathPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.itemCount != itemCount ||
        oldDelegate.zigzagOffset != zigzagOffset ||
        oldDelegate.extendFromTop != extendFromTop ||
        oldDelegate.extendToBottom != extendToBottom ||
        oldDelegate.startFromCenter != startFromCenter ||
        oldDelegate.pathFullyComplete != pathFullyComplete ||
        oldDelegate.entryBridgeSolid != entryBridgeSolid;
  }
}
