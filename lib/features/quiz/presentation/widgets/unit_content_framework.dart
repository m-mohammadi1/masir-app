import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

class UnitContentFramework extends StatelessWidget {
  final String title;
  final String typeLabel;
  final bool isCompleted;
  final String instructionText;
  final String? attachmentUrl;
  final Widget? content;
  final VoidCallback? onComplete;
  final VoidCallback onBack;
  final String primaryButtonTitle;
  final bool isSubmitting;

  const UnitContentFramework({
    super.key,
    required this.title,
    required this.typeLabel,
    required this.isCompleted,
    required this.instructionText,
    required this.onBack,
    this.attachmentUrl,
    this.content,
    this.onComplete,
    this.primaryButtonTitle = 'تکمیل شد',
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomAppBar(title: title),
        16.h,
        Row(
          children: [
            _TypeBadge(label: typeLabel),
            if (isCompleted) ...[8.w, _CompletedBadge()],
          ],
        ),
        16.h,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InstructionCard(
                  instructionText: instructionText,
                  attachmentUrl: attachmentUrl,
                ),
                if (content != null) ...[16.h, content!],
              ],
            ),
          ),
        ),
        16.h,
        UnitActionButtons(
          showPrimary: !isCompleted,
          primaryTitle: primaryButtonTitle,
          isSubmitting: isSubmitting,
          onPrimary: onComplete,
          onBack: onBack,
        ),
        20.h,
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;

  const _TypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColor.surface,
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.green100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.success.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: AppColor.success),
          6.w,
          CustomText(
            'تکمیل شده',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.success,
          ),
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final String instructionText;
  final String? attachmentUrl;

  const _InstructionCard({required this.instructionText, this.attachmentUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText('دستورالعمل', fontSize: 13, color: AppColor.inkMuted),
          12.h,
          CustomText(
            instructionText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.ink,
          ),
          if (attachmentUrl != null && attachmentUrl!.isNotEmpty) ...[
            16.h,
            OnClick(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    'مشاهده پیوست',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                  4.w,
                  Icon(Icons.open_in_new, size: 16, color: AppColor.primary),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
