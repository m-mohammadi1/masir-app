import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/video_player.dart';
import 'package:mohammad/widgets/custom_text.dart';

class VideoQuizLayout extends StatelessWidget {
  final UnitsQuestionModel question;
  final bool readOnly;
  final String? mediaUrl;

  const VideoQuizLayout({
    super.key,
    required this.question,
    this.readOnly = false,
    this.mediaUrl,
  });

  String get _videoUrl {
    if (mediaUrl != null && mediaUrl!.isNotEmpty) {
      return mediaUrl!;
    }
    if (question.options?.isNotEmpty == true) {
      return question.options!.first;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = _videoUrl;

    if (videoUrl.isEmpty) {
      return CustomText(
        'فایل ویدئو در دسترس نیست',
        fontSize: 14,
        color: AppColor.inkMuted,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [CustomVideoPlayer(url: videoUrl)],
    );
  }
}
