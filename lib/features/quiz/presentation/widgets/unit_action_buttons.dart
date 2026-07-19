import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showPrimary) ...[
          CustomButton(
            title: primaryTitle,
            loading: isSubmitting,
            onTap: onPrimary,
          ),
          12.h,
        ],
        OnClick(
          onTap: onBack,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xffE7DEF8)),
            ),
            child: const CustomText(
              'بازگشت به مسیر',
              color: Color(0xff2F2146),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
