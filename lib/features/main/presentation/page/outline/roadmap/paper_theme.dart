import 'package:flutter/material.dart';

/// Visual tokens for the "paper map" learning roadmap.
/// All colors are fixed literals (not theme/dark-mode dependent), matching
/// how the roadmap page has always styled itself independent of [AppColor].
class PaperTheme {
  PaperTheme._();

  // Surfaces
  static const Color pagePaper = Color(0xFFF6F4EF); // soft off-white page
  static const Color cardPaper = Color(0xFFFFFEFB); // module sheet
  static const Color paperEdge = Color(0xFFE5E2D9); // hairline border

  // Ink tones
  static const Color ink = Color(0xFF3A362F);
  static const Color inkMuted = Color(0xFF8B8779);
  static const Color inkFaint = Color(0xFFD2CFC4);
  static const Color locked = Color(0xFFB7B4A7);

  // Accent ink (used sparingly: current step, stamps)
  static const Color accent = Color(0xFF7E42C5);
  static const Color success = Color(0xFF2E7D4F);

  // The trail itself — a solid ribbon rather than a thin line, so the
  // roadmap reads as a route to walk, not a graph. The route not yet
  // adventured is purple (brand color); the portion already adventured
  // turns green, matching the green used on completed-unit stamps.
  static const Color trailWalked = Color(0xFF6FAE86);
  static const Color trailWalkedEdge = Color(0xFF2E7D4F);
  static const Color trailUnwalked = Color(0xFFC3A6E6);
  static const Color trailUnwalkedEdge = Color(0xFF7E42C5);
}

/// A very subtle dot-grid painted once behind the roadmap list so the
/// area reads as a textured page rather than a flat color.
class PaperGrainPainter extends CustomPainter {
  const PaperGrainPainter();

  static const double _spacing = 15;
  static const double _dotRadius = 0.7;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = PaperTheme.inkFaint.withValues(alpha: 0.4);
    for (double y = 6; y < size.height; y += _spacing) {
      for (double x = 6; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PaperGrainPainter oldDelegate) => false;
}

/// Wraps [child] with a faint paper-grain texture behind it.
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

String persianDigits(int n) {
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  var s = n.toString();
  for (var i = 0; i < western.length; i++) {
    s = s.replaceAll(western[i], persian[i]);
  }
  return s;
}
