import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

class RouteMapPage extends StatefulWidget {
  static const String routeName = "/route-map";

  const RouteMapPage({super.key});

  @override
  State<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage>
    with SingleTickerProviderStateMixin {
  final int itemCount = 15;
  final double itemHeight = 120;

  int currentStep = 4;

  late ScrollController scrollController;
  late AnimationController animationController;

  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        scrollOffset = scrollController.offset;
      });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        currentStep * itemHeight,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('زبان ترکی')),
      backgroundColor: context.colors.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([animationController, scrollController]),
        builder: (c, w) {
          final offset = scrollController.hasClients
              ? scrollController.offset
              : 0.0;
          return CustomPaint(
            painter: RoadPainter(
              itemCount: itemCount,
              progress: animationController.value,
              scrollOffset: offset,
              currentStep: currentStep,
              walked: context.colors.trailWalkedEdge,
              unwalked: context.colors.trailUnwalked,
            ),
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 0),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final isLeft = index % 2 == 0;
                return SizedBox(
                  height: itemHeight,
                  child: Align(
                    alignment: isLeft
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RoadItem(index: index, state: _getState(index)),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  StepState _getState(int index) {
    if (index < currentStep) return StepState.completed;
    if (index == currentStep) return StepState.current;
    return StepState.locked;
  }
}

class RoadMapPainter extends CustomPainter {
  final int itemCount;
  final Color color;

  RoadMapPainter({required this.itemCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    double verticalSpacing = 100;

    for (int i = 0; i < itemCount - 1; i++) {
      final isLeft = i % 2 == 0;

      final startX = isLeft ? size.width * 0.25 : size.width * 0.75;
      final endX = !isLeft ? size.width * 0.25 : size.width * 0.75;

      final startY = i * verticalSpacing + 50;
      final endY = (i + 1) * verticalSpacing + 50;

      path.moveTo(startX, startY);

      path.quadraticBezierTo(size.width / 2, (startY + endY) / 2, endX, endY);

      _drawDottedPath(canvas, path, paint);

      path.reset();
    }
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 6;
    const dashSpace = 6;

    final metrics = path.computeMetrics();

    for (var metric in metrics) {
      double distance = 0;

      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dashWidth);

        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum StepState { completed, current, locked }

class RoadItem extends StatefulWidget {
  final int index;
  final StepState state;

  const RoadItem({super.key, required this.index, required this.state});

  @override
  State<RoadItem> createState() => _RoadItemState();
}

class _RoadItemState extends State<RoadItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.9,
      upperBound: 1.1,
    );

    if (widget.state == StepState.current) {
      controller.repeat(reverse: true); // bounce
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant RoadItem oldWidget) {
    if (widget.state == StepState.current) {
      controller.repeat(reverse: true);
    } else {
      controller.stop();
      controller.value = 1;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    Widget child;

    switch (widget.state) {
      case StepState.completed:
        color = context.colors.success;
        child = const Icon(Icons.check, color: Colors.white);
        break;

      case StepState.current:
        color = context.colors.primary;
        child = CustomText(
          (widget.index + 1).toString(),
          style: const TextStyle(color: Colors.white),
        );
        break;
      case StepState.locked:
        color = context.colors.locked;
        child = const Icon(Icons.lock, color: Colors.white);
        break;
    }

    return ScaleTransition(
      scale: controller,
      child: GestureDetector(
        onTap: widget.state == StepState.locked ? null : () {},
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: .8)],
            ),
            boxShadow: widget.state == StepState.current
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.6),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: OnClick(
            onTap: () {
              if (widget.state != StepState.locked) {
                CustomNavigator.pushNamed(UnitPage.routeName);
              }
            },
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  final int itemCount;
  final double progress;
  final double scrollOffset;
  final int currentStep;
  final Color walked;
  final Color unwalked;

  RoadPainter({
    required this.itemCount,
    required this.progress,
    required this.scrollOffset,
    required this.currentStep,
    required this.walked,
    required this.unwalked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double spacing = 120;

    for (int i = 0; i < itemCount - 1; i++) {
      final isLeft = i % 2 == 0;

      final startX = isLeft ? size.width * 0.2 : size.width * 0.8;
      final endX = !isLeft ? size.width * 0.2 : size.width * 0.8;

      final startY = i * spacing + 60 - scrollOffset;
      final endY = (i + 1) * spacing + 60 - scrollOffset;

      final path = Path()
        ..moveTo(startX, startY)
        ..cubicTo(size.width / 2, startY, size.width / 2, endY, endX, endY);

      final isPassed = i < currentStep;

      final paint = Paint()
        ..color = isPassed ? walked : unwalked
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      _drawDotted(canvas, path, paint);
    }
  }

  void _drawDotted(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8;
    const dashSpace = 6;

    final metrics = path.computeMetrics();

    for (var metric in metrics) {
      double distance = 0;
      final max = metric.length * progress;

      while (distance < max) {
        final segment = metric.extractPath(distance, distance + dashWidth);

        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoadPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.progress != progress;
  }
}
