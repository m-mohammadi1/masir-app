import 'package:flutter/material.dart';
import '/core/theme/masir_colors.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';

/// Shared chunky card: 2px border plus a solid 4px lip.
///
/// Name kept as `PaperCard` so existing call sites keep working.
class PaperCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  /// Soft tinted variant (e.g. highlight a "continue" card).
  final Color? tint;
  final Color? tintEdge;

  const PaperCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = MasirRadius.card,
    this.onTap,
    this.tint,
    this.tintEdge,
  });

  static BoxDecoration decoration(
    MasirColors colors, {
    double borderRadius = MasirRadius.card,
  }) {
    return Chunky.surface(colors, radius: borderRadius);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final card = ChunkyBox(
      fill: tint ?? c.surface,
      edge: tintEdge ?? c.lip,
      borderColor: tintEdge ?? c.border,
      radius: borderRadius,
      padding: padding ?? const EdgeInsets.all(16),
      onTap: onTap,
      child: child,
    );
    if (margin == null) return card;
    return Padding(padding: margin!, child: card);
  }
}
