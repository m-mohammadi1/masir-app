import 'package:flutter/material.dart';

import '/core/theme/theme_context.dart';

/// The look of each kind of roadmap node, in one place: the roadmap pin and
/// the unit screen both read from here, so a video is the same coral video
/// everywhere.
class UnitTypeStyle {
  final String label;
  final IconData icon;

  /// Label for the main "I'm done" action of this kind of unit.
  final String doneLabel;

  /// Soft background, strong foreground and the matching lip colour.
  final Color tint;
  final Color accent;
  final Color edge;

  const UnitTypeStyle({
    required this.label,
    required this.icon,
    required this.doneLabel,
    required this.tint,
    required this.accent,
    required this.edge,
  });

  static String labelOf(String? type) => switch (type) {
    'html' => 'درس',
    'practice' => 'تمرین',
    'quiz' => 'آزمون',
    'audio' => 'صوتی',
    'video' => 'ویدیو',
    _ => type ?? '',
  };

  static IconData iconOf(String? type) => switch (type) {
    'html' => Icons.menu_book_rounded,
    'practice' => Icons.edit_note_rounded,
    'quiz' => Icons.quiz_rounded,
    'audio' => Icons.headphones_rounded,
    'video' => Icons.play_circle_rounded,
    _ => Icons.article_rounded,
  };

  static String doneLabelOf(String? type) => switch (type) {
    'html' => 'خوندم',
    'practice' => 'انجامش دادم',
    'video' => 'دیدم',
    'audio' => 'گوش دادم',
    'quiz' => 'ارسال پاسخ',
    _ => 'تکمیل شد',
  };

  static UnitTypeStyle of(BuildContext context, String? type) {
    final c = context.colors;
    final (tint, accent, edge) = switch (type) {
      'practice' => (c.sunSoft, c.sun, c.sunEdge),
      'video' => (c.coralSoft, c.coral, c.coralEdge),
      'audio' => (c.primary100, c.primary400, c.primaryEdge),
      'quiz' => (c.green100, c.green, c.greenEdge),
      _ => (c.primaryTint, c.primary, c.primaryEdge),
    };
    return UnitTypeStyle(
      label: labelOf(type),
      icon: iconOf(type),
      doneLabel: doneLabelOf(type),
      tint: tint,
      accent: accent,
      edge: edge,
    );
  }
}
