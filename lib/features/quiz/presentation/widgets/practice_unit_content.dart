import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '/core/theme/theme_context.dart';

class PracticeUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;

  const PracticeUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onComplete,
    required this.onBack,
  });

  String get _instructions => data.payload?.instructions ?? '';

  String? get _attachmentUrl => data.payload?.attachmentUrl;

  Future<void> _openAttachment() async {
    final url = _attachmentUrl;
    if (url == null || url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = data.title ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomAppBar(title: title),
        16.h,
        Row(
          children: [
            _PracticeTypeBadge(label: data.type ?? 'practice'),
            const Spacer(),
            if (isCompleted) const _CompletedBadge(),
          ],
        ),
        16.h,
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'دستورالعمل',
                    fontSize: 13,
                    color: context.colors.inkMuted,
                  ),
                  12.h,
                  CustomText(
                    _instructions,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.colors.ink,
                  ),
                  if (_attachmentUrl != null && _attachmentUrl!.isNotEmpty) ...[
                    16.h,
                    OnClick(
                      onTap: _openAttachment,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            'مشاهده پیوست',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.colors.primary,
                          ),
                          4.w,
                          Icon(
                            Icons.open_in_new,
                            size: 16,
                            color: context.colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        16.h,
        UnitActionButtons(
          showPrimary: !isCompleted,
          primaryTitle: 'تکمیل شد',
          isSubmitting: isSubmitting,
          onPrimary: onComplete,
          onBack: onBack,
        ),
        20.h,
      ],
    );
  }
}

class _PracticeTypeBadge extends StatelessWidget {
  final String label;

  const _PracticeTypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.primaryTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: context.colors.primary,
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.green100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.success.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: context.colors.success),
          6.w,
          CustomText(
            'تکمیل شده',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.colors.success,
          ),
        ],
      ),
    );
  }
}
