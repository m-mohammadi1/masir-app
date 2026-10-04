import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/icon_tile.dart';

/// A tappable row: leading (usually an [IconTile] or avatar), title, optional
/// subtitle and trailing (chevron by default when tappable).
class ListRow extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;
  final bool highlighted;

  const ListRow({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
    this.highlighted = false,
  });

  /// Convenience for the common "icon tile + label" menu row.
  ListRow.menu({
    super.key,
    required IconData icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
  }) : leading = IconTile(
         icon,
         tone: danger ? IconTileTone.coral : IconTileTone.brand,
       ),
       highlighted = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final edge = danger
        ? c.coral.withValues(alpha: 0.4)
        : highlighted
        ? c.primary.withValues(alpha: 0.5)
        : c.border;
    final lip = danger
        ? c.coral.withValues(alpha: 0.4)
        : highlighted
        ? c.primary.withValues(alpha: 0.5)
        : c.lip;
    return ChunkyBox(
      fill: highlighted ? c.primaryTint : c.surface,
      edge: lip,
      borderColor: edge,
      radius: MasirRadius.row,
      padding: const EdgeInsets.symmetric(
        horizontal: MasirSpace.lg,
        vertical: MasirSpace.md,
      ),
      onTap: onTap,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: MasirSpace.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.bodyStrong(
                  title,
                  color: danger ? c.coral : c.ink,
                  maxLines: 1,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  CustomText.caption(subtitle!, color: c.inkMuted, maxLines: 2),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            Icon(Icons.chevron_left_rounded, color: c.locked),
        ],
      ),
    );
  }
}
