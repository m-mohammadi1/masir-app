import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/option_widget.dart';

class HomeWorkQuizLayout extends StatefulWidget {
  final UnitsQuestionModel question;
  final bool readOnly;
  final ValueChanged<bool?>? onAnswerChanged;

  const HomeWorkQuizLayout({
    super.key,
    required this.question,
    this.readOnly = false,
    this.onAnswerChanged,
  });

  @override
  State<HomeWorkQuizLayout> createState() => _HomeWorkQuizLayoutState();
}

class _HomeWorkQuizLayoutState extends State<HomeWorkQuizLayout> {
  bool? correct;

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionWidget(
          title: 'خواندم',
          selected: correct == true,
          onTap: () {
            setState(() => correct = true);
            widget.onAnswerChanged?.call(true);
          },
        ),
        8.h,
        OptionWidget(
          title: 'فراموش کردم',
          selected: correct == false,
          onTap: () {
            setState(() => correct = false);
            widget.onAnswerChanged?.call(false);
          },
        ),
      ],
    );
  }
}
