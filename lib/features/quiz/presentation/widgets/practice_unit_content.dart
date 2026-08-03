import '/core/helper/custom_colors.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffE7DEF8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    'دستورالعمل',
                    fontSize: 13,
                    color: Color(0xff6E6884),
                  ),
                  12.h,
                  CustomText(
                    _instructions,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff2F2146),
                  ),
                  if (_attachmentUrl != null && _attachmentUrl!.isNotEmpty) ...[
                    16.h,
                    OnClick(
                      onTap: _openAttachment,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomText(
                            'مشاهده پیوست',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff7C3AED),
                          ),
                          4.w,
                          const Icon(
                            Icons.open_in_new,
                            size: 16,
                            color: Color(0xff7C3AED),
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
        color: const Color(0xffF3EBFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xff7C3AED),
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
        color: const Color(0xffE8F5E9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffA5D6A7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Color(0xff4CAF50),
          ),
          6.w,
          const CustomText(
            'تکمیل شده',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff4CAF50),
          ),
        ],
      ),
    );
  }
}
