import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/option_widget.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OptionWidget(
          title: 'درست',
          selected: correct == true,
          onTap: () => setState(() => correct = true),
        ),
        8.h,
        OptionWidget(
          title: 'غلط',
          selected: correct == false,
          onTap: () => setState(() => correct = false),
        ),
      ],
    );
  }
}
