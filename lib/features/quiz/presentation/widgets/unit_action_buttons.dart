import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';
import 'unit_top_bar.dart';

/// Primary action (complete / submit) + always-visible "back to path".
/// Hides the primary button when [showPrimary] is false (e.g. already completed).
class UnitActionButtons extends StatelessWidget {
  final bool showPrimary;
  final String primaryTitle;
  final bool isSubmitting;
  final VoidCallback? onPrimary;
  final VoidCallback onBack;

  const UnitActionButtons({
    super.key,
    required this.showPrimary,
    required this.primaryTitle,
    required this.onBack,
    this.onPrimary,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return UnitBottomBar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showPrimary)
            CustomButton(
              title: primaryTitle,
              loading: isSubmitting,
              onTap: onPrimary,
              variant: ButtonVariant.success,
              height: 54,
            )
          else
            CustomButton(
              title: 'بازگشت به مسیر',
              onTap: onBack,
              height: 54,
            ),
          if (showPrimary) ...[
            4.h,
            OnClick(
              onTap: onBack,
              child: SizedBox(
                height: 40,
                child: Center(
                  child: CustomText(
                    'بازگشت به مسیر',
                    color: context.colors.inkMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
