import 'package:flutter/material.dart';
import '/core/theme/masir_colors.dart';
import '/core/theme/theme_context.dart';

/// Roadmap tokens derived from the current [MasirColors] so the trail
/// follows light/dark (and later, institute) theming.
class PaperTheme {
  final MasirColors colors;

  const PaperTheme(this.colors);

  factory PaperTheme.of(BuildContext context) => PaperTheme(context.colors);

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
