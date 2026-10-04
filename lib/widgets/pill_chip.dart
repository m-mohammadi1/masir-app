import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';

enum PillTone { brand, neutral, success, sun, coral, onDark }

/// Small rounded label for topics, levels, counts and "free" badges.
class PillChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final PillTone tone;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  const PillChip(
    this.label, {
    super.key,
    this.icon,
    this.tone = PillTone.brand,
    this.selected = false,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Color bg;
    Color fg;
    switch (tone) {
      case PillTone.brand:
        bg = color != null ? color!.withValues(alpha: 0.14) : c.primaryTint;
        fg = color ?? c.primary;
      case PillTone.neutral:
        bg = c.border100;
        fg = c.inkMuted;
      case PillTone.success:
        bg = c.green100;
        fg = c.greenEdge;
      case PillTone.sun:
        bg = c.sunSoft;
        fg = c.sunEdge;
      case PillTone.coral:
        bg = c.coralSoft;
        fg = c.coralEdge;
      case PillTone.onDark:
        bg = Colors.white.withValues(alpha: 0.22);
        fg = Colors.white;
    }
    if (selected) {
      bg = color ?? c.primary;
      fg = c.onPrimary;
    }

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(MasirRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          CustomText.micro(label, color: fg, maxLines: 1),
        ],
      ),
    );
    if (onTap == null) return chip;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: chip,
    );
  }
}
