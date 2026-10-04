import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';

/// Small stat card: icon, value and label (course length, units, ...).
class StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      radius: MasirRadius.row,
      padding: const EdgeInsets.symmetric(
        vertical: MasirSpace.md,
        horizontal: MasirSpace.sm,
      ),
      child: Column(
        children: [
          Icon(icon, color: c.primary, size: MasirIconSize.md + 2),
          const SizedBox(height: 4),
          CustomText.bodyStrong(value, color: c.ink, maxLines: 1),
          CustomText.caption(label, color: c.inkMuted, maxLines: 1),
        ],
      ),
    );
  }
}
