import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/design/design.dart';

/// Three intro slides, then «کد دعوت دارم، ثبت‌نام» or «حساب دارم، ورود».
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _pages = PageController();
  int _i = 0;

  static const _slides = [
    (
      bg: C.surface,
      title: 'یه مسیر، قدم‌به‌قدم',
      body: 'هر دوره یه نقشه‌ست. همیشه می‌دونی قدم بعدی چیه و چقدر راه اومدی.',
    ),
    (
      bg: C.sand,
      title: 'مؤسسه‌ت، توی جیبت',
      body: 'دوره‌ها، استادها و اطلاعیه‌های مؤسسه‌ت، همه یه‌جا و با رنگ خودش.',
    ),
    (
      bg: C.sunSoft,
      title: 'هر قدم یه جشن کوچیک',
      body: 'واحدها کوتاهن. تمومش کن، جام بگیر، زنجیره‌ت رو نگه دار.',
    ),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int i) => _pages.animateToPage(
    i,
    duration: const Duration(milliseconds: 320),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final last = _i == _slides.length - 1;
    return Scaffold(
      backgroundColor: C.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  // To the last slide, where «حساب دارم» and registration
                  // both are; on it, «رد شو» starts registration.
                  onPressed: () => last
                      ? context.push(Routes.register)
                      : _go(_slides.length - 1),
                  style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                  child: Text(
                    'رد شو',
                    style: T.of(15, FontWeight.w700, C.muted),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pages,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _i = i),
                  itemBuilder: (_, i) {
                    final s = _slides[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 320,
                          decoration: BoxDecoration(
                            color: s.bg,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: switch (i) {
                            0 => const _TrailArt(),
                            1 => const _InstitutesArt(),
                            _ => const _CheerArt(),
                          },
                        ),
                        const SizedBox(height: 28),
                        Text(
                          s.title,
                          textAlign: TextAlign.center,
                          style: T.of(28, FontWeight.w900, C.ink, 1.4),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          s.body,
                          textAlign: TextAlign.center,
                          style: T.of(16, FontWeight.w500, C.body, 1.9),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var k = 0; k < _slides.length; k++) ...[
                    if (k > 0) const SizedBox(width: 8),
                    Semantics(
                      label: 'اسلاید ${fa(k + 1)}',
                      selected: k == _i,
                      button: true,
                      child: GestureDetector(
                        onTap: () => _go(k),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: k == _i ? 28 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: k == _i ? C.violet : C.lip,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              if (last)
                Btn(
                  'کد دعوت دارم، ثبت‌نام',
                  onPressed: () => context.push(Routes.register),
                )
              else
                Btn('بعدی', onPressed: () => _go(_i + 1)),
              const SizedBox(height: 10),
              Btn.secondary(
                'حساب دارم، ورود',
                onPressed: () => context.push(Routes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrailArt extends StatelessWidget {
  const _TrailArt();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final s = c.maxWidth / 350;
      Widget dot(
        double l,
        double t,
        double size,
        Color bg,
        Color e, {
        Color? ring,
        double r = 999,
      }) => Positioned(
        left: l * s,
        top: t,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(r == 999 ? size : r),
            boxShadow: [
              lip(e, 5),
              if (ring != null) BoxShadow(color: ring, spreadRadius: 10),
            ],
          ),
        ),
      );
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _IntroTrail(s))),
            dot(228, 8, 64, C.green, C.greenDark),
            dot(52, 132, 76, C.violet, C.violetDark, ring: C.violetSoft),
            dot(228, 258, 64, C.locked, C.lockedLip, r: 22),
          ],
        ),
      );
    },
  );
}

class _IntroTrail extends CustomPainter {
  final double s;
  _IntroTrail(this.s);
  @override
  void paint(Canvas canvas, Size size) {
    Path p(
      double x0,
      double y0,
      double x1,
      double y1,
      double x2,
      double y2,
      double x3,
      double y3,
    ) => Path()
      ..moveTo(x0 * s, y0)
      ..cubicTo(x1 * s, y1, x2 * s, y2, x3 * s, y3);
    final full = p(260, 40, 260, 110, 90, 110, 90, 170)
      ..cubicTo(90 * s, 230, 260 * s, 230, 260 * s, 290);
    final dash = Paint()
      ..color = C.lip
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final m in full.computeMetrics()) {
      for (double d = 0; d < m.length; d += 22) {
        canvas.drawPath(m.extractPath(d, d + 2), dash);
      }
    }
    canvas.drawPath(
      p(260, 40, 260, 110, 90, 110, 90, 170),
      Paint()
        ..color = C.green
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_IntroTrail old) => old.s != s;
}

class _InstitutesArt extends StatelessWidget {
  const _InstitutesArt();
  @override
  Widget build(BuildContext context) {
    Widget tile(double size, double r, Color c, Color e, double angle) =>
        Transform.rotate(
          angle: angle,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(r),
              boxShadow: [lip(e, 5)],
            ),
          ),
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        tile(84, 26, const Color(0xFF4C68EB), const Color(0xFF3447C8), -0.14),
        const SizedBox(width: 14),
        tile(104, 32, const Color(0xFF22B573), const Color(0xFF168A55), 0),
        const SizedBox(width: 14),
        tile(84, 26, const Color(0xFFE11D48), const Color(0xFFB0123A), 0.14),
      ],
    );
  }
}

class _CheerArt extends StatelessWidget {
  const _CheerArt();
  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: C.sun,
          borderRadius: BorderRadius.circular(44),
          boxShadow: [lip(C.sunDark, 7)],
        ),
        alignment: Alignment.center,
        child: const MIcon(
          MI.trophy,
          size: 72,
          color: C.sunInk,
          strokeWidth: 2,
        ),
      ),
      PositionedDirectional(
        top: 60,
        start: 80,
        child: Transform.rotate(
          angle: .5,
          child: Container(
            width: 14,
            height: 6,
            decoration: BoxDecoration(
              color: C.violet,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
      PositionedDirectional(
        bottom: 70,
        end: 70,
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: C.green,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  );
}
