import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import '/features/quiz/presentation/widgets/unit_top_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

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
  final Widget? headerIcon;
  final Widget? banner;
  final Widget? footer;
  final VoidCallback? onAttachmentTap;

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
    this.headerIcon,
    this.banner,
    this.footer,
    this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UnitTopBar(
          title: title,
          onClose: onBack,
          trailing: headerIcon,
        ),
        14.h,
        Row(
          children: [
            PillChip(typeLabel),
            if (isCompleted) ...[
              8.w,
              const PillChip(
                'تکمیل شده',
                icon: Icons.check_circle_rounded,
                tone: PillTone.success,
              ),
            ],
          ],
        ),
        if (banner != null) ...[12.h, banner!],
        16.h,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (instructionText.isNotEmpty)
                  _InstructionCard(
                    instructionText: instructionText,
                    attachmentUrl: attachmentUrl,
                    onAttachmentTap: onAttachmentTap,
                  ),
                if (content != null) ...[
                  if (instructionText.isNotEmpty) 16.h,
                  content!,
                ],
                if (footer != null) ...[16.h, footer!],
              ],
            ),
          ),
        ),
        UnitActionButtons(
          showPrimary: !isCompleted,
          primaryTitle: primaryButtonTitle,
          isSubmitting: isSubmitting,
          onPrimary: onComplete,
          onBack: onBack,
        ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final String instructionText;
  final String? attachmentUrl;
  final VoidCallback? onAttachmentTap;

  const _InstructionCard({
    required this.instructionText,
    this.attachmentUrl,
    this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'دستورالعمل',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: c.primary,
          ),
          10.h,
          CustomText(
            instructionText,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.ink,
          ),
          if (attachmentUrl != null && attachmentUrl!.isNotEmpty) ...[
            16.h,
            OnClick(
              onTap: onAttachmentTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_file_rounded, size: 18, color: c.primary),
                  4.w,
                  CustomText(
                    'مشاهده پیوست',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: c.primary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
