import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';
import '/widgets/pill_chip.dart';
import '/widgets/unit_kit/unit_type_style.dart';

/// Top of every unit screen: a tinted type badge, the type label, the title
/// and one meta line (reading time, question count, ...).
class UnitHeader extends StatelessWidget {
  final String type;
  final String title;
  final String? meta;
  final bool isCompleted;

  const UnitHeader({
    super.key,
    required this.type,
    required this.title,
    this.meta,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = UnitTypeStyle.of(context, type);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 10),
          child: child,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: style.tint,
              borderRadius: BorderRadius.circular(MasirRadius.row),
              border: Border.all(color: style.accent, width: Chunky.border),
            ),
            child: Icon(
              style.icon,
              size: MasirIconSize.xl - 4,
              color: style.accent,
            ),
          ),
          const SizedBox(width: MasirSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText.micro(style.label, color: style.accent),
                    if (meta != null && meta!.isNotEmpty) ...[
                      const SizedBox(width: MasirSpace.sm),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: c.inkFaint,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: MasirSpace.sm),
                      Flexible(
                        child: CustomText.caption(
                          meta!,
                          color: c.inkMuted,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                CustomText.title(title, maxLines: 3),
                if (isCompleted) ...[
                  const SizedBox(height: MasirSpace.sm),
                  const PillChip(
                    'تکمیل شده',
                    icon: Icons.check_circle_rounded,
                    tone: PillTone.success,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
