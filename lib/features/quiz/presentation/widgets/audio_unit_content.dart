import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/audio_player.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/unit_kit/unit_shell.dart';
import 'package:mohammad/widgets/unit_kit/unit_type_style.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

/// An audio lesson: a "now playing" card with a wave, big play button, ±15s
/// skips and playback speed.
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

  String? get _meta {
    final seconds = data.payload?.durationSeconds ?? 0;
    if (seconds <= 0) return null;
    return '${faDigits((seconds / 60).ceil())} دقیقه';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = UnitTypeStyle.of(context, 'audio');
    return UnitShell(
      type: 'audio',
      title: data.title ?? '',
      isCompleted: isCompleted,
      meta: _meta,
      headerIcon: unitTeacherHeaderIcon(data.teachers),
      banner: banner,
      footer: footer,
      isSubmitting: isSubmitting,
      onComplete: onComplete,
      onBack: onBack,
      children: [
        ChunkyBox(
          fill: style.tint,
          edge: style.edge,
          borderColor: style.accent,
          radius: MasirRadius.card,
          padding: const EdgeInsets.all(MasirSpace.xl - MasirSpace.xs),
          child: _mediaUrl.isNotEmpty
              ? CustomAudioPlayer(url: _mediaUrl, onChanged: (_) {})
              : Column(
                  children: [
                    Icon(
                      Icons.headset_off_rounded,
                      size: MasirIconSize.xl,
                      color: c.inkFaint,
                    ),
                    const SizedBox(height: MasirSpace.sm),
                    CustomText.body(
                      'فایل صوتی هنوز آماده نیست',
                      color: c.inkMuted,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
