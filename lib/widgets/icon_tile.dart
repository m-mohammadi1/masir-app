import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';

enum IconTileTone { brand, success, sun, coral, neutral }

/// A 40px rounded tile with an icon in a soft tint.
class IconTile extends StatelessWidget {
  final IconData icon;
  final IconTileTone tone;
  final double size;

  const IconTile(
    this.icon, {
    super.key,
    this.tone = IconTileTone.brand,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg) = switch (tone) {
      IconTileTone.brand => (c.primaryTint, c.primary),
      IconTileTone.success => (c.green100, c.greenEdge),
      IconTileTone.sun => (c.sunSoft, c.sunEdge),
      IconTileTone.coral => (c.coralSoft, c.coral),
      IconTileTone.neutral => (c.border100, c.inkMuted),
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(MasirRadius.chip),
      ),
      child: Icon(icon, size: MasirIconSize.md + 2, color: fg),
    );
  }
}
