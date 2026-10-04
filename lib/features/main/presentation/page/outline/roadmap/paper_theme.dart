import 'package:flutter/material.dart';
import '/core/theme/masir_colors.dart';

/// Frozen roadmap palette.
///
/// The roadmap deliberately keeps its original warm "paper" look while the rest
/// of the app moves to the playful design system. These values are hard-coded
/// (not read from the app palette) so changing global tokens never restyles
/// the trail.
class RoadmapPalette {
  RoadmapPalette._();

  static const MasirColors light = MasirColors(
    primary: Color(0xFF7E42C5),
    primaryEdge: Color(0xFF5E2D9A),
    primary100: Color(0xFFF3EDFA),
    primary400: Color(0xFF7E42C5),
    primaryTint: Color(0xFFF3EBFF),
    secondary: Color(0xFF3C467B),
    background: Color(0xFFF6F4EF),
    surface: Color(0xFFFFFEFB),
    error: Color(0xFFEB5757),
    coral: Color(0xFFEB5757),
    coralEdge: Color(0xFFC03F3F),
    coralSoft: Color(0xFFFFE5E6),
    ink: Color(0xFF3A362F),
    inkMuted: Color(0xFF8B8779),
    inkFaint: Color(0xFFD2CFC4),
    text92: Color(0xFF929292),
    border: Color(0xFFE5E2D9),
    lip: Color(0xFFE5E2D9),
    border100: Color(0xFFEFEBE3),
    border150: Color(0xFFF0EDE6),
    borderF9: Color(0xFFF2F0EA),
    secondaryDisable: Color(0xFFD3D3D3),
    green: Color(0xFF2E7D4F),
    green100: Color(0xFFE8F3EC),
    greenEdge: Color(0xFF2E7D4F),
    sun: Color(0xFFFFB020),
    sunEdge: Color(0xFFD98E00),
    sunSoft: Color(0xFFFFF3D6),
    black: Color(0xFF000000),
    white: Color(0xFFFFFFFF),
    locked: Color(0xFFB7B4A7),
    success: Color(0xFF2E7D4F),
    trailWalked: Color(0xFF6FAE86),
    trailWalkedEdge: Color(0xFF2E7D4F),
    trailUnwalked: Color(0xFFC3A6E6),
    trailUnwalkedEdge: Color(0xFF7E42C5),
    accent: Color(0xFF7E42C5),
    onPrimary: Color(0xFFFFFFFF),
  );

  static const MasirColors dark = MasirColors(
    primary: Color(0xFF9B6BD4),
    primaryEdge: Color(0xFF6E43A3),
    primary100: Color(0xFF2A2433),
    primary400: Color(0xFF7E42C5),
    primaryTint: Color(0xFF3D3250),
    secondary: Color(0xFF9BA3C7),
    background: Color(0xFF1E1C18),
    surface: Color(0xFF2A2722),
    error: Color(0xFFEB5757),
    coral: Color(0xFFEB5757),
    coralEdge: Color(0xFFC03F3F),
    coralSoft: Color(0xFF3B1F22),
    ink: Color(0xFFF6F4EF),
    inkMuted: Color(0xFFB7B4A7),
    inkFaint: Color(0xFF5C574D),
    text92: Color(0xFF929292),
    border: Color(0xFF3D3930),
    lip: Color(0xFF3D3930),
    border100: Color(0xFF333028),
    border150: Color(0xFF2F2C26),
    borderF9: Color(0xFF252219),
    secondaryDisable: Color(0xFF555555),
    green: Color(0xFF6FAE86),
    green100: Color(0xFF1E3328),
    greenEdge: Color(0xFF2E7D4F),
    sun: Color(0xFFFFC04D),
    sunEdge: Color(0xFFD98E00),
    sunSoft: Color(0xFF3A2E14),
    black: Color(0xFF000000),
    white: Color(0xFFFFFFFF),
    locked: Color(0xFF8A806D),
    success: Color(0xFF6FAE86),
    trailWalked: Color(0xFF6FAE86),
    trailWalkedEdge: Color(0xFF2E7D4F),
    trailUnwalked: Color(0xFF5A4578),
    trailUnwalkedEdge: Color(0xFF9B6BD4),
    accent: Color(0xFF9B6BD4),
    onPrimary: Color(0xFFFFFFFF),
  );

  static MasirColors forBrightness(Brightness b) =>
      b == Brightness.dark ? dark : light;

  /// Wraps [child] in a theme whose [MasirColors] are the frozen roadmap
  /// palette, so shared widgets (text, app bar, buttons) inside the roadmap
  /// keep today's colours.
  static Widget scope(BuildContext context, {required Widget child}) {
    final base = Theme.of(context);
    final colors = forBrightness(base.brightness);
    return Theme(
      data: base.copyWith(
        scaffoldBackgroundColor: colors.background,
        extensions: [colors],
      ),
      child: child,
    );
  }
}

/// Roadmap tokens. Always read from the frozen [RoadmapPalette].
class PaperTheme {
  final MasirColors colors;

  const PaperTheme(this.colors);

  factory PaperTheme.of(BuildContext context) =>
      PaperTheme(RoadmapPalette.forBrightness(Theme.of(context).brightness));

  Color get pagePaper => colors.pagePaper;
  Color get cardPaper => colors.cardPaper;
  Color get paperEdge => colors.paperEdge;
  Color get ink => colors.ink;
  Color get inkMuted => colors.inkMuted;
  Color get inkFaint => colors.inkFaint;
  Color get locked => colors.locked;
  Color get accent => colors.accent;
  Color get success => colors.success;
  Color get trailWalked => colors.trailWalked;
  Color get trailWalkedEdge => colors.trailWalkedEdge;
  Color get trailUnwalked => colors.trailUnwalked;
  Color get trailUnwalkedEdge => colors.trailUnwalkedEdge;
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
