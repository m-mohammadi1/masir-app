import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';

/// Empty state that always guides: icon bubble, headline, one line of help
/// and an optional call to action.
class EmptyWidget extends StatelessWidget {
  final String text;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyWidget({
    super.key,
    required this.text,
    required this.description,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primaryTint,
              ),
              child: Icon(icon, size: 44, color: colors.primary),
            ),
            24.h,
            CustomText(
              text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.ink,
              textAlign: TextAlign.center,
            ),
            8.h,
            CustomText(
              description,
              fontSize: 13,
              color: colors.inkMuted,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              24.h,
              CustomButton(title: actionLabel, onTap: onAction, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}
