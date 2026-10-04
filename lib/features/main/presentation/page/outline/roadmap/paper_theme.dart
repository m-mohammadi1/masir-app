import 'package:flutter/material.dart';

import '/core/theme/masir_colors.dart';
import '/core/theme/theme_context.dart';

/// Roadmap tokens.
///
/// A thin lens over the app palette (`context.colors`), so the roadmap follows
/// light/dark mode and the institute preset like every other screen.
class PaperTheme {
  final MasirColors colors;

  const PaperTheme(this.colors);

  factory PaperTheme.of(BuildContext context) => PaperTheme(context.colors);

  Color get background => colors.background;
  Color get surface => colors.surface;
  Color get border => colors.border;
  Color get lip => colors.lip;
  Color get ink => colors.ink;
  Color get inkMuted => colors.inkMuted;
  Color get inkFaint => colors.inkFaint;
  Color get locked => colors.locked;

  /// Institute primary.
  Color get accent => colors.primary;
  Color get accentEdge => colors.primaryEdge;
  Color get accentTint => colors.primaryTint;
  Color get onAccent => colors.onPrimary;

  /// Completed.
  Color get success => colors.green;
  Color get successEdge => colors.greenEdge;
  Color get successSoft => colors.green100;

  /// Milestones.
  Color get sun => colors.sun;
  Color get sunEdge => colors.sunEdge;
  Color get sunSoft => colors.sunSoft;

  /// Walked part of the trail: solid green ribbon with a darker lip.
  Color get trailWalked => colors.green;
  Color get trailWalkedEdge => colors.greenEdge;

  /// Part still ahead: a dashed neutral track.
  Color get trailUnwalked => colors.border;
  Color get trailUnwalkedEdge => colors.lip;
}
