import 'dart:math' as math;

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_outline_course_model.dart';
import 'package:mohammad/features/main/domain/entities/outline_course.dart';
import 'package:mohammad/features/main/presentation/bloc/outline_course/outline_course_bloc.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page_args.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

/// Horizontal inset for zigzag nodes / road path (matches painter & widgets).
const double _kRoadSideRatio = 0.18;
const double _kRoadNodeSize = 64;

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

  static const _purple = Color(0xff7C3AED);
  static const _purpleSoft = Color(0xffE7DEF8);
  static const _purpleBg = Color(0xffF3EBFF);
  static const _textDark = Color(0xff2F2146);
  static const _textMuted = Color(0xff6E6884);
  static const _green = Color(0xff4CAF50);
  static const _greenBg = Color(0xffE8F5E9);
  static const _greenSoft = Color(0xffC8E6C9);
  static const _locked = Color(0xff9E96B0);

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
        body: Column(
          children: [
            CustomAppBar(title: widget.title),
            20.h,
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
                            child: ListView(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 32),
                              children: List.generate(modules.length, (
                                moduleIndex,
                              ) {
                                final module = modules[moduleIndex];
                                final paths = module.paths ?? [];
                                final moduleProgress = _moduleProgress(module);
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

class _CourseProgressHeader extends StatelessWidget {
  final int progress;

  const _CourseProgressHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              'پیشرفت دوره',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _OutlinePageState._textDark,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _OutlinePageState._purple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                '%$progress',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
            backgroundColor: _OutlinePageState._purpleSoft,
            valueColor: const AlwaysStoppedAnimation<Color>(
              _OutlinePageState._purple,
            ),
          ),
        ),
      ],
    );
  }
}

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
  }) onUnitTap;

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _OutlinePageState._purpleSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: isComplete
                    ? const [
                        Color(0xffE8F5E9),
                        Color(0xffF1F8E9),
                      ]
                    : const [
                        Color(0xffF3EBFF),
                        Color(0xffFAF7FF),
                      ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isComplete
                        ? _OutlinePageState._green
                        : _OutlinePageState._purple,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isComplete
                                ? _OutlinePageState._green
                                : _OutlinePageState._purple)
                            .withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    isComplete ? Icons.check_rounded : Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        module.title ?? '',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _OutlinePageState._textDark,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        isComplete
                            ? 'فصل کامل شده'
                            : 'پیشرفت فصل $moduleProgress٪',
                        fontSize: 12,
                        color: _OutlinePageState._textMuted,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isComplete
                          ? _OutlinePageState._greenSoft
                          : _OutlinePageState._purpleSoft,
                    ),
                  ),
                  child: CustomText(
                    '$moduleProgress٪',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isComplete
                        ? _OutlinePageState._green
                        : _OutlinePageState._purple,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: moduleProgress / 100.0,
              minHeight: 3,
              backgroundColor: _OutlinePageState._purpleSoft.withValues(
                alpha: 0.5,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete
                    ? _OutlinePageState._green
                    : _OutlinePageState._purple,
              ),
            ),
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
          const SizedBox(height: 8),
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
    }) onUnitTap,
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
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: _PathHeaderCard(path: path),
          ),
        );
      }

      if (units.isNotEmpty) {
        final hasPrevBridge = pathIndex > 0 &&
            (paths[pathIndex - 1].units ?? []).isNotEmpty;
        final hasNextBridge = pathIndex < paths.length - 1 &&
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
          final fromIsLeft =
              (units.length - 1 + zigzagOffset) % 2 == 0;
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
          final fromIsLeft =
              (units.length - 1 + zigzagOffset) % 2 == 0;
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
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
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

class _PathHeaderCard extends StatelessWidget {
  final OutlinePathEntity path;

  const _PathHeaderCard({required this.path});

  @override
  Widget build(BuildContext context) {
    final pathProgress = path.pathProgressPercent ?? 0;
    final isComplete = pathProgress >= 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isComplete
            ? _OutlinePageState._greenBg.withValues(alpha: 0.6)
            : const Color(0xffFAF8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete
              ? _OutlinePageState._greenSoft
              : _OutlinePageState._purpleSoft,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isComplete ? Icons.flag_rounded : Icons.alt_route_rounded,
                size: 18,
                color: isComplete
                    ? _OutlinePageState._green
                    : _OutlinePageState._purple,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  path.title ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _OutlinePageState._textDark,
                ),
              ),
              CustomText(
                '$pathProgress٪',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isComplete
                    ? _OutlinePageState._green
                    : _OutlinePageState._purple,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pathProgress / 100.0,
              minHeight: 4,
              backgroundColor: _OutlinePageState._purpleSoft,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete
                    ? _OutlinePageState._green
                    : _OutlinePageState._purple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophyConnector extends StatelessWidget {
  static const double _topGap = 44;
  static const double _circleSize = 72;

  final bool fromIsLeft;
  final Animation<double> entrance;

  const _TrophyConnector({
    required this.fromIsLeft,
    required this.entrance,
  });

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
            padding: const EdgeInsets.only(top: _topGap, bottom: 20),
            child: Center(
              child: Container(
                width: _circleSize,
                height: _circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: _OutlinePageState._purple,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _OutlinePageState._purple.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: const Image(
                  image: AssetImage('assets/png/chapter_trophy.png'),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
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
    final startY = 0.0;
    // Connect to the center of the trophy circle, like unit nodes.
    final endY = topGap + circleSize / 2;
    final dy = endY - startY;

    final road = Path()
      ..moveTo(startX, startY)
      ..cubicTo(
        startX,
        startY + dy * 0.55,
        endX,
        endY - dy * 0.45,
        endX,
        endY,
      );

    final glowPaint = Paint()
      ..color = _OutlinePageState._purple.withValues(alpha: 0.10)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final basePaint = Paint()
      ..color = _OutlinePageState._purpleSoft.withValues(alpha: 0.85)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final solidPaint = Paint()
      ..color = _OutlinePageState._purple
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    void drawPartial(Path path, Paint paint) {
      for (final metric in path.computeMetrics()) {
        final length = metric.length * progress.clamp(0.0, 1.0);
        if (length <= 0) continue;
        canvas.drawPath(metric.extractPath(0, length), paint);
      }
    }

    drawPartial(road, glowPaint);
    drawPartial(road, basePaint);
    drawPartial(road, solidPaint);
  }

  @override
  bool shouldRepaint(covariant _TrophyPathPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fromIsLeft != fromIsLeft ||
        oldDelegate.topGap != topGap ||
        oldDelegate.circleSize != circleSize;
  }
}

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
    final startY = 0.0;
    final endY = size.height;
    final dy = endY - startY;

    // Gentler S-curve so the bridge turns more gradually behind the header.
    final road = Path()
      ..moveTo(startX, startY)
      ..cubicTo(
        startX,
        startY + dy * 0.7,
        endX,
        endY - dy * 0.7,
        endX,
        endY,
      );

    final glowPaint = Paint()
      ..color = _OutlinePageState._purple.withValues(alpha: 0.10)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final basePaint = Paint()
      ..color = _OutlinePageState._purpleSoft.withValues(alpha: 0.85)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _drawPartial(canvas, road, glowPaint, progress);
    _drawPartial(canvas, road, basePaint, progress);

    if (isPathComplete) {
      final solidPaint = Paint()
        ..color = _OutlinePageState._purple
        ..strokeWidth = 3.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      _drawPartial(canvas, road, solidPaint, progress);
    } else {
      final dashedPaint = Paint()
        ..color = _OutlinePageState._purple.withValues(alpha: 0.55)
        ..strokeWidth = 3.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      _drawSoftDashes(canvas, road, dashedPaint, progress);
    }
  }

  void _drawPartial(
    Canvas canvas,
    Path path,
    Paint paint,
    double progress,
  ) {
    for (final metric in path.computeMetrics()) {
      final length = metric.length * progress.clamp(0.0, 1.0);
      if (length <= 0) continue;
      canvas.drawPath(metric.extractPath(0, length), paint);
    }
  }

  void _drawSoftDashes(
    Canvas canvas,
    Path path,
    Paint paint,
    double progress,
  ) {
    const dashWidth = 5.0;
    const dashSpace = 9.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      final max = metric.length * progress.clamp(0.0, 1.0);
      while (distance < max) {
        final end = math.min(distance + dashWidth, max);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
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
  }) onUnitTap;
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

                final start = (widget.staggerBase + index * 0.07).clamp(0.0, 0.85);
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
                            // Keep circle center on the road path at every width.
                            left: isLeft ? nodeCenterX - nodeRadius : null,
                            right: isLeft
                                ? null
                                : width - nodeCenterX - nodeRadius,
                            child: Align(
                              alignment: Alignment.center,
                              child: Transform.translate(
                                offset: Offset(
                                  (1 - t) * (isLeft ? -40 : 40),
                                  (1 - t) * 24,
                                ),
                                child: Opacity(
                                  opacity: t.clamp(0.0, 1.0),
                                  child: KeyedSubtree(
                                    key: isCurrent
                                        ? widget.currentUnitKey
                                        : null,
                                    child: _RoadUnitNode(
                                      title: unit.title ?? '',
                                      typeLabel:
                                          widget.getTypeLabel(unitType),
                                      icon: widget.getTypeIcon(unitType),
                                      isCompleted: isCompleted,
                                      isLocked: isLocked,
                                      isCurrent: isCurrent,
                                      isLeft: isLeft,
                                      maxLabelWidth: (width * 0.42)
                                          .clamp(88.0, 140.0),
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

class _RoadUnitNode extends StatefulWidget {
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
  State<_RoadUnitNode> createState() => _RoadUnitNodeState();
}

class _RoadUnitNodeState extends State<_RoadUnitNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
      lowerBound: 0.94,
      upperBound: 1.06,
    );
    if (widget.isCurrent && !widget.isLocked) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _RoadUnitNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent && !widget.isLocked) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 1;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color ringColor;
    final Color fillColor;
    final Color iconColor;
    final IconData displayIcon;

    if (widget.isCompleted) {
      ringColor = _OutlinePageState._green;
      fillColor = _OutlinePageState._greenBg;
      iconColor = _OutlinePageState._green;
      displayIcon = Icons.check_rounded;
    } else if (widget.isLocked) {
      ringColor = const Color(0xffD8D2E4);
      fillColor = const Color(0xffF5F3F8);
      iconColor = _OutlinePageState._locked;
      displayIcon = Icons.lock_outline_rounded;
    } else if (widget.isCurrent) {
      ringColor = _OutlinePageState._purple;
      fillColor = _OutlinePageState._purpleBg;
      iconColor = _OutlinePageState._purple;
      displayIcon = widget.icon;
    } else {
      ringColor = _OutlinePageState._purpleSoft;
      fillColor = Colors.white;
      iconColor = _OutlinePageState._purple;
      displayIcon = widget.icon;
    }

    final label = Column(
      crossAxisAlignment:
          widget.isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxLabelWidth),
          child: CustomText(
            widget.title,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: widget.isLocked
                ? _OutlinePageState._locked
                : _OutlinePageState._textDark,
            // Keep title flush against the clickable circle.
            textAlign: widget.isLeft ? TextAlign.left : TextAlign.right,
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 2),
        CustomText(
          widget.typeLabel,
          fontSize: 11,
          color: _OutlinePageState._textMuted,
          textAlign: widget.isLeft ? TextAlign.left : TextAlign.right,
        ),
        if (widget.isLocked) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _OutlinePageState._purpleBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const CustomText(
              'قفل',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _OutlinePageState._purple,
            ),
          ),
        ],
      ],
    );

    final node = ScaleTransition(
      scale: _pulse,
      child: Container(
        width: _kRoadNodeSize,
        height: _kRoadNodeSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fillColor,
          border: Border.all(color: ringColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: ringColor.withValues(alpha: widget.isCurrent ? 0.45 : 0.18),
              blurRadius: widget.isCurrent ? 18 : 8,
              spreadRadius: widget.isCurrent ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(displayIcon, color: iconColor, size: 26),
      ),
    );

    return OnClick(
      onTap: widget.isLocked ? null : widget.onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: widget.isLeft
            ? [node, const SizedBox(width: 10), label]
            : [label, const SizedBox(width: 10), node],
      ),
    );
  }
}

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
    return isLeft
        ? width * _kRoadSideRatio
        : width * (1 - _kRoadSideRatio);
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

    final glowPaint = Paint()
      ..color = _OutlinePageState._purple.withValues(alpha: 0.10)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final basePaint = Paint()
      ..color = _OutlinePageState._purpleSoft.withValues(alpha: 0.85)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final activePaint = Paint()
      ..color = _OutlinePageState._purple.withValues(alpha: 0.55)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final solidPurplePaint = Paint()
      ..color = _OutlinePageState._purple
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    void paintTrail(Path road, {required bool solid}) {
      _drawPartial(canvas, road, glowPaint, progress);
      _drawPartial(canvas, road, basePaint, progress);
      if (solid) {
        _drawPartial(canvas, road, solidPurplePaint, progress);
      } else {
        _drawSoftDashes(canvas, road, activePaint, progress);
      }
    }

    // From path-header bottom-center → first unit.
    if (startFromCenter) {
      final entry = _segment(
        size.width / 2,
        0,
        _nodeX(0, size.width),
        _nodeY(0),
      );
      paintTrail(entry, solid: pathFullyComplete);
    }

    // Incoming bridge from previous path → first unit.
    if (extendFromTop) {
      final firstX = _nodeX(0, size.width);
      final entry = _segment(firstX, 0, firstX, _nodeY(0));
      paintTrail(entry, solid: entryBridgeSolid);
    }

    // Unit-to-unit road.
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

      _drawPartial(canvas, road, glowPaint, progress);
      _drawPartial(canvas, road, basePaint, progress);

      if (pathFullyComplete) {
        // All units done → full solid purple trail (no dashes).
        _drawPartial(canvas, road, solidPurplePaint, progress);
      } else {
        final completedCount =
            completedFlags.where((done) => done).length.clamp(0, itemCount);
        if (completedCount > 0) {
          final doneRatio =
              ((completedCount - 1) / (itemCount - 1)).clamp(0.0, 1.0);
          final greenPaint = Paint()
            ..color = _OutlinePageState._green.withValues(alpha: 0.7)
            ..strokeWidth = 3.2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;
          _drawPartial(
            canvas,
            road,
            greenPaint,
            math.min(progress, doneRatio),
          );
        }

        _drawSoftDashes(canvas, road, activePaint, progress);
      }
    }

    // Outgoing bridge from last unit → next path.
    if (extendToBottom) {
      final lastX = _nodeX(itemCount - 1, size.width);
      final exit = _segment(lastX, _nodeY(itemCount - 1), lastX, size.height);
      paintTrail(exit, solid: pathFullyComplete);
    }
  }

  void _drawPartial(
    Canvas canvas,
    Path path,
    Paint paint,
    double progress,
  ) {
    for (final metric in path.computeMetrics()) {
      final length = metric.length * progress.clamp(0.0, 1.0);
      if (length <= 0) continue;
      canvas.drawPath(metric.extractPath(0, length), paint);
    }
  }

  void _drawSoftDashes(
    Canvas canvas,
    Path path,
    Paint paint,
    double progress,
  ) {
    const dashWidth = 5.0;
    const dashSpace = 9.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      final max = metric.length * progress.clamp(0.0, 1.0);
      while (distance < max) {
        final end = math.min(distance + dashWidth, max);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
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