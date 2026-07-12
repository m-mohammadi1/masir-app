import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/bloc/video/video_view_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/video_player.dart';

class VideoQuizLayout extends StatelessWidget {
  final UnitsQuestionModel question;
  final bool readOnly;

  VideoQuizLayout({
    super.key,
    required this.question,
    this.readOnly = false,
  });

  final VideoViewModel videoViewModel = VideoViewModel();

  @override
  Widget build(BuildContext context) {
    final videoUrl = question.options?.isNotEmpty == true
        ? question.options!.first
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomVideoPlayer(url: videoUrl, videoViewModel: videoViewModel),
      ],
    );
  }
}
