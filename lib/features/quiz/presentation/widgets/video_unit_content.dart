import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/video_player.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/unit_kit/unit_shell.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

/// A video: the player is a full-width 16:9 card right under the header.
class VideoUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;
  final Widget? banner;
  final Widget? footer;

  const VideoUnitContent({
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
    return UnitShell(
      type: 'video',
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
          fill: c.surface,
          edge: c.coralEdge,
          borderColor: c.coral,
          radius: MasirRadius.card,
          child: _mediaUrl.isNotEmpty
              ? CustomVideoPlayer(url: _mediaUrl)
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off_rounded,
                        size: MasirIconSize.xl,
                        color: c.inkFaint,
                      ),
                      const SizedBox(height: MasirSpace.sm),
                      CustomText.body(
                        'فایل ویدیو هنوز آماده نیست',
                        color: c.inkMuted,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
