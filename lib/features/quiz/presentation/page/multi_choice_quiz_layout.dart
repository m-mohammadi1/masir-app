import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/widgets/unit_kit/answer_tile.dart';

class MultiChoiceQuizLayout extends StatefulWidget {
  final UnitsQuestionModel question;
  final bool readOnly;

  const MultiChoiceQuizLayout({
    super.key,
    required this.question,
    this.readOnly = false,
  });

  @override
  State<MultiChoiceQuizLayout> createState() => _MultiChoiceQuizLayoutState();
}

class _MultiChoiceQuizLayoutState extends State<MultiChoiceQuizLayout> {
  int correct = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      return const SizedBox.shrink();
    }

    final options = widget.question.options ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(options.length, (index) {
        final optionIndex = index; // 0-based, as the API grades it
        return Padding(
          padding: EdgeInsets.only(bottom: index == options.length - 1 ? 0 : 8),
          child: AnswerTile(
            label: options[index],
            badge: index < kOptionLetters.length ? kOptionLetters[index] : null,
            state: correct == optionIndex
                ? AnswerState.selected
                : AnswerState.idle,
            onTap: () => setState(() => correct = optionIndex),
          ),
        );
      }),
    );
  }
}
