import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';

enum MasirCardTone { surface, tinted, brand }

/// The one card: radius 20, padding 16, chunky border and lip.
///
/// * `surface`: neutral card (lists, settings).
/// * `tinted`: soft brand tint (hints, "continue" strips).
/// * `brand`: solid primary (heroes).
class MasirCard extends StatelessWidget {
  final Widget child;
  final MasirCardTone tone;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;

  const MasirCard({
    super.key,
    required this.child,
    this.tone = MasirCardTone.surface,
    this.onTap,
    this.padding = const EdgeInsets.all(MasirSpace.card),
    this.radius = MasirRadius.card,
  });

  const MasirCard.tinted({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(MasirSpace.card),
    this.radius = MasirRadius.card,
  }) : tone = MasirCardTone.tinted;

  const MasirCard.brand({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(MasirSpace.card),
    this.radius = MasirRadius.hero,
  }) : tone = MasirCardTone.brand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return switch (tone) {
      MasirCardTone.surface => ChunkyBox(
        fill: c.surface,
        edge: c.lip,
        borderColor: c.border,
        radius: radius,
        padding: padding,
        onTap: onTap,
        child: child,
      ),
      MasirCardTone.tinted => ChunkyBox(
        fill: c.primaryTint,
        edge: c.primary.withValues(alpha: 0.35),
        borderColor: c.primary.withValues(alpha: 0.35),
        radius: radius,
        padding: padding,
        onTap: onTap,
        child: child,
      ),
      MasirCardTone.brand => ChunkyBox(
        fill: c.primary,
        edge: c.primaryEdge,
        radius: radius,
        padding: padding,
        onTap: onTap,
        child: child,
      ),
    };
  }
}
