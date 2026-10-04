import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/features/main/data/models/request_quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/quiz_unit_content.dart';

const _unit = UnitsModel(
  id: 'unit-1',
  title: 'آزمون',
  type: 'quiz',
  payload: UnitsPayloadModel(
    passThreshold: 70,
    questions: [
      UnitsQuestionModel(
        id: 'q1',
        type: 'four_choice',
        text: 'سؤال',
        options: ['گزینه ۱', 'گزینه ۲', 'گزینه ۳', 'گزینه ۴'],
      ),
    ],
  ),
);

void main() {
  // The backend grades four-choice answers by 0-based option index, so the
  // number sent must be the option's position in the list.
  for (final entry in {
    'گزینه ۱': 0,
    'گزینه ۲': 1,
    'گزینه ۳': 2,
    'گزینه ۴': 3,
  }.entries) {
    testWidgets('choosing "${entry.key}" submits index ${entry.value}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      List<QuizSubmitAnswerModel>? sent;
      await tester.pumpWidget(
        MaterialApp(
          theme: light,
          locale: const Locale('fa'),
          builder: (context, c) =>
              Directionality(textDirection: TextDirection.rtl, child: c!),
          home: QuizUnitContent(
            data: _unit,
            isCompleted: false,
            onSubmit: (answers) => sent = answers,
            onBack: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text(entry.key));
      await tester.pump(const Duration(milliseconds: 300));

      final state = tester.state<QuizUnitContentState>(
        find.byType(QuizUnitContent),
      );
      sent = state.buildAnswers();

      expect(sent, hasLength(1));
      expect(sent!.single.questionId, 'q1');
      expect(sent!.single.answer, entry.value);
    });
  }
}
