import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';

@immutable
class MasirColors extends ThemeExtension<MasirColors> {
  final Color primary;
  final Color primary100;
  final Color primary400;
  final Color primaryTint;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color ink;
  final Color inkMuted;
  final Color inkFaint;
  final Color text92;
  final Color border;
  final Color border100;
  final Color border150;
  final Color borderF9;
  final Color secondaryDisable;
  final Color green;
  final Color green100;
  final Color black;
  final Color white;
  final Color locked;
  final Color success;
  final Color trailWalked;
  final Color trailWalkedEdge;
  final Color trailUnwalked;
  final Color trailUnwalkedEdge;
  final Color accent;
  final Color onPrimary;

  const MasirColors({
    required this.primary,
    required this.primary100,
    required this.primary400,
    required this.primaryTint,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.ink,
    required this.inkMuted,
    required this.inkFaint,
    required this.text92,
    required this.border,
    required this.border100,
    required this.border150,
    required this.borderF9,
    required this.secondaryDisable,
    required this.green,
    required this.green100,
    required this.black,
    required this.white,
    required this.locked,
    required this.success,
    required this.trailWalked,
    required this.trailWalkedEdge,
    required this.trailUnwalked,
    required this.trailUnwalkedEdge,
    required this.accent,
    required this.onPrimary,
  });

  Color get pagePaper => background;
  Color get cardPaper => surface;
  Color get paperEdge => border;
  Color get text => ink;
  Color get textGray => inkMuted;
  Color get textDefault => ink;
  Color get primarySoft => primaryTint;

  static const light = MasirColors(
    primary: LightColors.primary,
    primary100: LightColors.primary100,
    primary400: LightColors.primary400,
    primaryTint: LightColors.primaryTint,
    secondary: LightColors.secondary,
    background: LightColors.pagePaper,
    surface: LightColors.cardPaper,
    error: ConstColors.red,
    ink: LightColors.ink,
    inkMuted: LightColors.inkMuted,
    inkFaint: LightColors.inkFaint,
    text92: LightColors.text92,
    border: LightColors.paperEdge,
    border100: LightColors.border100,
    border150: LightColors.border150,
    borderF9: LightColors.borderF9,
    secondaryDisable: LightColors.secondaryDisable,
    green: LightColors.green,
    green100: LightColors.green100,
    black: LightColors.black,
    white: LightColors.white,
    locked: LightColors.locked,
    success: LightColors.success,
    trailWalked: LightColors.trailWalked,
    trailWalkedEdge: LightColors.trailWalkedEdge,
    trailUnwalked: LightColors.trailUnwalked,
    trailUnwalkedEdge: LightColors.trailUnwalkedEdge,
    accent: LightColors.primary,
    onPrimary: LightColors.white,
  );

  static const dark = MasirColors(
    primary: DarkColors.primary,
    primary100: DarkColors.primary100,
    primary400: DarkColors.primary400,
    primaryTint: DarkColors.primaryTint,
    secondary: DarkColors.secondary,
    background: DarkColors.pagePaper,
    surface: DarkColors.cardPaper,
    error: ConstColors.red,
    ink: DarkColors.ink,
    inkMuted: DarkColors.inkMuted,
    inkFaint: DarkColors.inkFaint,
    text92: DarkColors.text92,
    border: DarkColors.paperEdge,
    border100: DarkColors.border100,
    border150: DarkColors.border150,
    borderF9: DarkColors.borderF9,
    secondaryDisable: DarkColors.secondaryDisable,
    green: DarkColors.green,
    green100: DarkColors.green100,
    black: DarkColors.black,
    white: DarkColors.white,
    locked: DarkColors.locked,
    success: DarkColors.success,
    trailWalked: DarkColors.trailWalked,
    trailWalkedEdge: DarkColors.trailWalkedEdge,
    trailUnwalked: DarkColors.trailUnwalked,
    trailUnwalkedEdge: DarkColors.trailUnwalkedEdge,
    accent: DarkColors.primary,
    onPrimary: DarkColors.white,
  );

  @override
  MasirColors copyWith({
    Color? primary,
    Color? primary100,
    Color? primary400,
    Color? primaryTint,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? error,
    Color? ink,
    Color? inkMuted,
    Color? inkFaint,
    Color? text92,
    Color? border,
    Color? border100,
    Color? border150,
    Color? borderF9,
    Color? secondaryDisable,
    Color? green,
    Color? green100,
    Color? black,
    Color? white,
    Color? locked,
    Color? success,
    Color? trailWalked,
    Color? trailWalkedEdge,
    Color? trailUnwalked,
    Color? trailUnwalkedEdge,
    Color? accent,
    Color? onPrimary,
  }) {
    return MasirColors(
      primary: primary ?? this.primary,
      primary100: primary100 ?? this.primary100,
      primary400: primary400 ?? this.primary400,
      primaryTint: primaryTint ?? this.primaryTint,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      inkFaint: inkFaint ?? this.inkFaint,
      text92: text92 ?? this.text92,
      border: border ?? this.border,
      border100: border100 ?? this.border100,
      border150: border150 ?? this.border150,
      borderF9: borderF9 ?? this.borderF9,
      secondaryDisable: secondaryDisable ?? this.secondaryDisable,
      green: green ?? this.green,
      green100: green100 ?? this.green100,
      black: black ?? this.black,
      white: white ?? this.white,
      locked: locked ?? this.locked,
      success: success ?? this.success,
      trailWalked: trailWalked ?? this.trailWalked,
      trailWalkedEdge: trailWalkedEdge ?? this.trailWalkedEdge,
      trailUnwalked: trailUnwalked ?? this.trailUnwalked,
      trailUnwalkedEdge: trailUnwalkedEdge ?? this.trailUnwalkedEdge,
      accent: accent ?? this.accent,
      onPrimary: onPrimary ?? this.onPrimary,
    );
  }

  @override
  MasirColors lerp(ThemeExtension<MasirColors>? other, double t) {
    if (other is! MasirColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return MasirColors(
      primary: mix(primary, other.primary),
      primary100: mix(primary100, other.primary100),
      primary400: mix(primary400, other.primary400),
      primaryTint: mix(primaryTint, other.primaryTint),
      secondary: mix(secondary, other.secondary),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      error: mix(error, other.error),
      ink: mix(ink, other.ink),
      inkMuted: mix(inkMuted, other.inkMuted),
      inkFaint: mix(inkFaint, other.inkFaint),
      text92: mix(text92, other.text92),
      border: mix(border, other.border),
      border100: mix(border100, other.border100),
      border150: mix(border150, other.border150),
      borderF9: mix(borderF9, other.borderF9),
      secondaryDisable: mix(secondaryDisable, other.secondaryDisable),
      green: mix(green, other.green),
      green100: mix(green100, other.green100),
      black: mix(black, other.black),
      white: mix(white, other.white),
      locked: mix(locked, other.locked),
      success: mix(success, other.success),
      trailWalked: mix(trailWalked, other.trailWalked),
      trailWalkedEdge: mix(trailWalkedEdge, other.trailWalkedEdge),
      trailUnwalked: mix(trailUnwalked, other.trailUnwalked),
      trailUnwalkedEdge: mix(trailUnwalkedEdge, other.trailUnwalkedEdge),
      accent: mix(accent, other.accent),
      onPrimary: mix(onPrimary, other.onPrimary),
    );
  }
}
