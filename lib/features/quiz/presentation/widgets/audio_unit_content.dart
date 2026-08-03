import '/core/helper/custom_colors.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/audio_player.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

class AudioUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;

  const AudioUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onComplete,
    required this.onBack,
  });

  String get _mediaUrl => data.payload?.mediaAccessUrl ?? '';

  int? get _durationSeconds => data.payload?.durationSeconds;

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
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
            _AudioTypeBadge(label: data.type ?? 'audio'),
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
                border: Border.all(color: AppColor.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_durationSeconds != null) ...[
                    CustomText(
                      'مدت زمان: ${_formatDuration(_durationSeconds!)}',
                      fontSize: 13,
                      color: AppColor.inkMuted,
                    ),
                    16.h,
                  ],
                  if (_mediaUrl.isNotEmpty)
                    CustomAudioPlayer(url: _mediaUrl, onChanged: (_) {})
                  else
                    CustomText(
                      'فایل صوتی در دسترس نیست',
                      fontSize: 14,
                      color: AppColor.inkMuted,
                    ),
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

class _AudioTypeBadge extends StatelessWidget {
  final String label;

  const _AudioTypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.primaryTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColor.primary,
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
