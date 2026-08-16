import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';

/// Roadmap tokens — const aliases to [LightColors] for use in const widgets.
/// Elsewhere in the app prefer [AppColor] (respects dark mode).
class PaperTheme {
  PaperTheme._();

  static const Color pagePaper = LightColors.pagePaper;
  static const Color cardPaper = LightColors.cardPaper;
  static const Color paperEdge = LightColors.paperEdge;
  static const Color ink = LightColors.ink;
  static const Color inkMuted = LightColors.inkMuted;
  static const Color inkFaint = LightColors.inkFaint;
  static const Color locked = LightColors.locked;
  static const Color accent = LightColors.primary;
  static const Color success = LightColors.success;
  static const Color trailWalked = LightColors.trailWalked;
  static const Color trailWalkedEdge = LightColors.trailWalkedEdge;
  static const Color trailUnwalked = LightColors.trailUnwalked;
  static const Color trailUnwalkedEdge = LightColors.trailUnwalkedEdge;
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
