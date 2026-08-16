import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/features/quiz/presentation/widgets/video_player.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class VideoUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;

  const VideoUnitContent({
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
        CustomAppBar(title: title, icon: unitTeacherHeaderIcon(data.teachers)),
        16.h,
        Row(
          children: [
            _VideoTypeBadge(label: data.type ?? 'video'),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_durationSeconds != null) ...[
                    CustomText(
                      'مدت زمان: ${_formatDuration(_durationSeconds!)}',
                      fontSize: 13,
                      color: context.colors.inkMuted,
                    ),
                    16.h,
                  ],
                  if (_mediaUrl.isNotEmpty)
                    CustomVideoPlayer(url: _mediaUrl)
                  else
                    CustomText(
                      'فایل ویدئو در دسترس نیست',
                      fontSize: 14,
                      color: context.colors.inkMuted,
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

class _VideoTypeBadge extends StatelessWidget {
  final String label;

  const _VideoTypeBadge({required this.label});

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
