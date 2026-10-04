import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/widgets/unit_kit/answer_tile.dart';

class TrueFalseQuizLayout extends StatefulWidget {
  final UnitsQuestionModel question;
  final bool readOnly;

  const TrueFalseQuizLayout({
    super.key,
    required this.question,
    this.readOnly = false,
  });

  @override
  State<TrueFalseQuizLayout> createState() => _TrueFalseQuizLayoutState();
}

class _TrueFalseQuizLayoutState extends State<TrueFalseQuizLayout> {
  bool? correct;

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnswerTile(
          label: 'درست',
          badgeIcon: Icons.check_rounded,
          state: correct == true ? AnswerState.selected : AnswerState.idle,
          onTap: () => setState(() => correct = true),
        ),
        8.h,
        AnswerTile(
          label: 'نادرست',
          badgeIcon: Icons.close_rounded,
          state: correct == false ? AnswerState.selected : AnswerState.idle,
          onTap: () => setState(() => correct = false),
        ),
      ],
    );
  }
}
