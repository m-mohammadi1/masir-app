import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';

/// The one hero block shared by auth, OTP, register and intro: a chunky icon
/// tile, a display title and a muted subtitle.
class AuthHero extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;

  const AuthHero({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ChunkyBox(
            fill: c.primaryTint,
            edge: c.primaryEdge.withValues(alpha: 0.4),
            radius: MasirRadius.hero,
            width: 88,
            height: 92,
            alignment: Alignment.center,
            child: Icon(icon, size: MasirIconSize.xl, color: c.primary),
          ),
        ),
        const SizedBox(height: MasirSpace.lg),
        CustomText.display(title, textAlign: TextAlign.center),
        if (subtitle != null) ...[
          const SizedBox(height: MasirSpace.xs),
          CustomText.body(
            subtitle!,
            color: c.inkMuted,
            textAlign: TextAlign.center,
          ),
        ],
        if (subtitleWidget != null) ...[
          const SizedBox(height: MasirSpace.xs),
          subtitleWidget!,
        ],
      ],
    );
  }
}
