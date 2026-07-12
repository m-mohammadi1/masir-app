import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/audio_player.dart';

class AudioQuizLayout extends StatelessWidget {
  final UnitsQuestionModel question;
  final bool readOnly;

  const AudioQuizLayout({
    super.key,
    required this.question,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final audioUrl = question.options?.isNotEmpty == true
        ? question.options!.first
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAudioPlayer(
          onChanged: (value) {},
          url: audioUrl,
        ),
      ],
    );
  }
}
