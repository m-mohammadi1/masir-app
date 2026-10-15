import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/core/services/hive_service.dart';
import '/design/design.dart';

/// Violet splash: the mark, «مسیر» and three loading dots.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _dots = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      context.go(HiveService.isLogged ? Routes.vitrine : Routes.intro);
    });
  }

  @override
  void dispose() {
    _dots.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.violet,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _TrailPainter())),
        Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const MasirMark(size: 140),
            const SizedBox(height: 22),
            Text('مسیر', style: T.of(44, FontWeight.w900, Colors.white, 1.1)),
            const SizedBox(height: 6),
            Text('قدم‌به‌قدم یاد بگیر', style: T.of(16, FontWeight.w600, C.onVioletMuted)),
          ]),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 72,
          child: Semantics(
            label: 'در حال بارگذاری',
            child: AnimatedBuilder(
              animation: _dots,
              builder: (_, _) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Opacity(
                    opacity: Motion.reduced(context) ? [1.0, .6, .3][i] : (1 - ((_dots.value * 3 - i) % 3) / 3).clamp(.3, 1),
                    child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  ),
                ],
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

/// The faint dotted trail behind the splash (12% white).
class _TrailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 390, sy = size.height / 844;
    final path = Path()
      ..moveTo(300 * sx, -20 * sy)
      ..cubicTo(300 * sx, 120 * sy, 90 * sx, 140 * sy, 90 * sx, 300 * sy)
      ..cubicTo(90 * sx, 460 * sy, 300 * sx, 480 * sy, 300 * sx, 640 * sy)
      ..cubicTo(300 * sx, 800 * sy, 90 * sx, 820 * sy, 90 * sx, 900 * sy);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 36) {
        canvas.drawPath(m.extractPath(d, d + 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
