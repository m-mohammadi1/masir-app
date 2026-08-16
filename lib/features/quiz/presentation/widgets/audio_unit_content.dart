import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/audio_player.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_content_framework.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class AudioUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;
  final Widget? banner;
  final Widget? footer;

  const AudioUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onComplete,
    required this.onBack,
    this.banner,
    this.footer,
  });

  String get _mediaUrl => data.payload?.mediaAccessUrl ?? '';

  @override
  Widget build(BuildContext context) {
    return UnitContentFramework(
      title: data.title ?? '',
      typeLabel: 'صوتی',
      isCompleted: isCompleted,
      instructionText: '',
      headerIcon: unitTeacherHeaderIcon(data.teachers),
      banner: banner,
      footer: footer,
      isSubmitting: isSubmitting,
      onComplete: onComplete,
      onBack: onBack,
      content: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: _mediaUrl.isNotEmpty
            ? CustomAudioPlayer(url: _mediaUrl, onChanged: (_) {})
            : CustomText(
                'فایل صوتی در دسترس نیست',
                fontSize: 14,
                color: context.colors.inkMuted,
              ),
      ),
    );
  }
}
