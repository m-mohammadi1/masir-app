import 'package:flutter/material.dart';

/// Fixed colours of the Masir design system (masir-design/tokens/design-tokens.json).
/// Institute colours never replace these: green = progress/correct,
/// coral = errors/wrong, sun = rewards, paper background, ink text.
class C {
  C._();

  static const paper = Color(0xFFFFFCF5);
  static const surface = Color(0xFFFFFFFF);
  static const sand = Color(0xFFF6F1E6);
  static const sandLight = Color(0xFFFBF8F2);
  static const border = Color(0xFFEFE8DA);
  static const lip = Color(0xFFE3D9C4);
  static const ink = Color(0xFF2B2633);
  static const body = Color(0xFF4A4458);
  static const muted = Color(0xFF6F6A7C);
  static const locked = Color(0xFFE9E5EF);
  static const lockedLip = Color(0xFFB9B3C4);
  static const disabledText = Color(0xFFB9B3C4);

  static const violet = Color(0xFF7E42C5);
  static const violetDark = Color(0xFF5E2D9A);
  static const violetSoft = Color(0xFFEEE4F9);
  static const violetBorder = Color(0xFFD9C7F0);
  static const onVioletMuted = Color(0xFFEADCFB);

  static const green = Color(0xFF3DBE6E);
  static const greenDark = Color(0xFF2A9455);
  static const greenText = Color(0xFF1E7A45);
  static const greenSoft = Color(0xFFE5F6EC);

  static const sun = Color(0xFFFFB020);
  static const sunDark = Color(0xFFD98E00);
  static const sunText = Color(0xFF6B4300);
  static const sunInk = Color(0xFF3D2600);
  static const sunSoft = Color(0xFFFFF4DC);
  static const sunBorder = Color(0xFFFFD27A);
  static const sunLip = Color(0xFFF3D9A0);

  static const coral = Color(0xFFFF5A5F);
  static const coralDark = Color(0xFFD63C42);
  static const coralText = Color(0xFFB3262B);
  static const coralTextDark = Color(0xFF8C1D22);
  static const coralSoft = Color(0xFFFFF1F1);
  static const coralBorder = Color(0xFFFFC9CB);
  static const coralInputBg = Color(0xFFFFF5F5);

  static const toast = Color(0xFF2B2633);
  static const toastMuted = Color(0xFFD9D3E6);
  static const scrim = Color(0x6B14101C);

  // Dark mode.
  static const darkPaper = Color(0xFF17141D);
  static const darkSurface = Color(0xFF221E2B);
  static const darkBorder = Color(0xFF39334A);
  static const darkLip = Color(0xFF0E0C12);
  static const darkInk = Color(0xFFF7F3FF);
  static const darkMuted = Color(0xFFCFC7DF);
  static const darkViolet = Color(0xFF9B6BD4);
}

/// Font family registered in pubspec.yaml (IRANSansX FaNum: Persian digits).
const String kFont = 'Masir';

/// Type scale: display 28/800, title 20/800, heading 17/700, body 15/500,
/// caption 13/600, micro 11/700. Long titles: max 2 lines, then ellipsis.
class T {
  T._();

  static TextStyle _s(double size, FontWeight w, Color c, double h) =>
      TextStyle(
        fontFamily: kFont,
        fontSize: size,
        fontWeight: w,
        color: c,
        height: h,
      );

  static TextStyle display([Color c = C.ink]) =>
      _s(28, FontWeight.w800, c, 1.4);
  static TextStyle title([Color c = C.ink]) => _s(20, FontWeight.w800, c, 1.4);
  static TextStyle heading([Color c = C.ink]) =>
      _s(17, FontWeight.w700, c, 1.5);
  static TextStyle body([Color c = C.ink]) => _s(15, FontWeight.w500, c, 1.7);
  static TextStyle caption([Color c = C.muted]) =>
      _s(13, FontWeight.w600, c, 1.6);
  static TextStyle micro([Color c = C.muted]) =>
      _s(11, FontWeight.w700, c, 1.4);

  /// Any size/weight in the design's family.
  static TextStyle of(
    double size,
    FontWeight w, [
    Color c = C.ink,
    double h = 1.5,
  ]) => _s(size, w, c, h);
}

class R {
  R._();
  static const chip = 999.0;
  static const button = 16.0;
  static const input = 16.0;
  static const card = 20.0;
  static const cardLarge = 24.0;
  static const sheet = 24.0;
  static const tile = 14.0;
}

class Gap {
  Gap._();
  static const page = 16.0;
  static const pageWide = 20.0;
  static const touch = 44.0;
  static const buttonHeight = 56.0;
  static const secondaryHeight = 52.0;
  static const inputHeight = 54.0;
}

/// The "lip": things sit on a solid edge, never a blurred shadow.
BoxShadow lip(Color color, [double dy = 4]) =>
    BoxShadow(color: color, offset: Offset(0, dy), blurRadius: 0);

/// White card with a 2px border and a 4px lip (radius 20).
BoxDecoration cardDecoration({
  Color fill = C.surface,
  Color border = C.border,
  Color lipColor = C.lip,
  double radius = R.card,
  double lipHeight = 4,
}) => BoxDecoration(
  color: fill,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: border, width: 2),
  boxShadow: lipHeight > 0 ? [lip(lipColor, lipHeight)] : null,
);

/// Persian digits for numbers that come from data (IRANSansX FaNum already
/// shapes digits, but text from the API or `toString` may carry Latin ones).
String fa(Object? v) {
  const d = '۰۱۲۳۴۵۶۷۸۹';
  return v.toString().replaceAllMapped(_latinDigit, (m) => d[int.parse(m[0]!)]);
}

final _latinDigit = RegExp(r'[0-9]');
