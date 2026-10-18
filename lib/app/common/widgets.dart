import 'package:flutter/material.dart';

import '/core/api/models.dart';
import '/design/design.dart';

/// Progress track with stations every 20% (Vitrine «مسیرهای من»): done
/// stations in the institute colour, the current one bigger.
class StationTrack extends StatelessWidget {
  final int percent;
  final InstitutePalette palette;
  final bool goalFlag;
  final double height;

  const StationTrack({
    super.key,
    required this.percent,
    required this.palette,
    this.goalFlag = false,
    this.height = 18,
  });

  @override
  Widget build(BuildContext context) {
    const stops = [0, 20, 40, 60, 80, 100];
    var currentPlaced = false;
    return Semantics(
      label: '${fa(percent)} درصد',
      child: SizedBox(
        height: height + 4,
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final dots = <Widget>[];
            for (final pos in stops) {
              final done = percent > 0 && pos < percent;
              var cur = false;
              if (!done && !currentPlaced && percent > 0) {
                cur = true;
                currentPlaced = true;
              }
              final last = pos == 100 && goalFlag;
              final size = cur ? 18.0 : 12.0;
              dots.add(
                PositionedDirectional(
                  start: (w * pos / 100 - size / 2).clamp(-2, w - size + 2),
                  top: (height + 4 - size) / 2,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: last
                          ? C.sun
                          : done
                          ? palette.p
                          : C.surface,
                      borderRadius: BorderRadius.circular(last ? 4 : size),
                      border: Border.all(
                        width: 3,
                        color: cur
                            ? palette.p
                            : done || last
                            ? C.surface
                            : palette.soft,
                      ),
                    ),
                  ),
                ),
              );
            }
            return Stack(
              clipBehavior: Clip.none,
              children: [
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  top: (height + 4) / 2 - 3,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: palette.soft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  width: w * percent.clamp(0, 100) / 100,
                  top: (height + 4) / 2 - 3,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: palette.p,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                ...dots,
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Logo with the institute's own lip under it (drop-shadow in the boards).
class LippedLogo extends StatelessWidget {
  final Brand brand;
  final double size;
  final bool inverted;
  final double lipHeight;
  const LippedLogo({
    super.key,
    required this.brand,
    this.size = 44,
    this.inverted = false,
    this.lipHeight = 3,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size + lipHeight,
    child: Stack(
      children: [
        Positioned(
          top: lipHeight,
          child: ClipPath(
            clipper: FrameClipper(brand.frame),
            child: Container(width: size, height: size, color: brand.palette.e),
          ),
        ),
        InstituteLogo(
          brand: brand,
          size: size,
          inverted: inverted,
          fontSize: size * .42,
        ),
      ],
    ),
  );
}

/// What a course's subscription state reads like on a card.
({String text, Color fg, Color bg})? accessBadge(CourseAccess a, int progress) {
  switch (a.state) {
    case AccessState.expired:
      return (text: 'اشتراک تموم شده', fg: C.coralText, bg: C.surface);
    case AccessState.expiring:
      return (
        text: '${fa(a.daysLeft ?? 0)} روز تا تمدید',
        fg: const Color(0xFF8A5A00),
        bg: C.surface,
      );
    case AccessState.active:
    case AccessState.freeCourse:
    case AccessState.trial:
      return (text: pct(progress), fg: C.greenText, bg: C.surface);
    case AccessState.guest:
      return null;
  }
}

/// Price line for a course card: «رایگان», «۲ واحد رایگان از ماهی ۲۴۰ هزار».
String priceLine(CourseCard c) {
  if (c.freeCourse) return 'رایگان';
  final from = c.fromPerMonth > 0 ? 'از ${perMonth(c.fromPerMonth)}' : '';
  if (c.previewUnits > 0) {
    return '${fa(c.previewUnits)} واحد رایگان $from'.trim();
  }
  return from;
}

/// Small rounded label over a cover («معرفی • ۱:۴۲»).
class VideoBadge extends StatelessWidget {
  final int seconds;
  const VideoBadge(this.seconds, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xA814101C),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MIcon(MI.play, size: 12, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          'معرفی • ${clock(seconds)}',
          style: T.of(12, FontWeight.w800, Colors.white),
        ),
      ],
    ),
  );
}
