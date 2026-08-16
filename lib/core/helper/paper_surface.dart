import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';

/// Very subtle dot-grid so scroll areas read as textured paper.
class PaperGrainPainter extends CustomPainter {
  final Color color;

  const PaperGrainPainter({required this.color});

  static const double _spacing = 15;
  static const double _dotRadius = 0.7;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.4);
    for (double y = 6; y < size.height; y += _spacing) {
      for (double x = 6; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PaperGrainPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Faint paper-grain texture behind [child].
class PaperBackdrop extends StatelessWidget {
  final Widget child;

  const PaperBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: PaperGrainPainter(color: context.colors.inkFaint),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
