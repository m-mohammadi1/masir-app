import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';

/// Title of a page section with an optional text action on the other side.
/// Callers put [MasirSpace.inSection] (12) below it.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader(this.title, {super.key, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: MasirSpace.inSection),
      child: Row(
        children: [
          Expanded(child: CustomText.title(title, maxLines: 1)),
          if (actionLabel != null && onAction != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: MasirSpace.xs),
                child: CustomText.caption(actionLabel!, color: c.primary),
              ),
            ),
        ],
      ),
    );
  }
}
