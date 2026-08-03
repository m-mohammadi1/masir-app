import 'package:flutter/material.dart';
import 'custom_colors.dart';

/// Very subtle dot-grid so scroll areas read as textured paper.
class PaperGrainPainter extends CustomPainter {
  const PaperGrainPainter();

  static const double _spacing = 15;
  static const double _dotRadius = 0.7;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColor.inkFaint.withValues(alpha: 0.4);
    for (double y = 6; y < size.height; y += _spacing) {
      for (double x = 6; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PaperGrainPainter oldDelegate) => false;
}

/// Faint paper-grain texture behind [child].
class PaperBackdrop extends StatelessWidget {
  final Widget child;

  const PaperBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(painter: PaperGrainPainter()),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
