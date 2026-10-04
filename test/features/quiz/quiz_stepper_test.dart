import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/features/main/data/models/request_quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/quiz_unit_content.dart';
import 'package:mohammad/widgets/custom_button.dart';

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
        text: 'پرسش اول',
        options: ['الف۱', 'ب۱', 'ج۱', 'د۱'],
      ),
      UnitsQuestionModel(
        id: 'q2',
        type: 'four_choice',
        text: 'پرسش دوم',
        options: ['الف۲', 'ب۲', 'ج۲', 'د۲'],
      ),
      UnitsQuestionModel(id: 'q3', type: 'true_false', text: 'پرسش سوم'),
    ],
  ),
);

Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
}

bool _enabled(WidgetTester tester, String title) => tester
    .widget<CustomButton>(
      find.ancestor(of: find.text(title), matching: find.byType(CustomButton)),
    )
    .enable;

void main() {
  Future<List<List<QuizSubmitAnswerModel>>> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final sent = <List<QuizSubmitAnswerModel>>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: light,
        locale: const Locale('fa'),
        builder: (context, c) =>
            Directionality(textDirection: TextDirection.rtl, child: c!),
        home: QuizUnitContent(
          data: _unit,
          isCompleted: false,
          onSubmit: sent.add,
          onBack: () {},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    return sent;
  }

  testWidgets('"بعدی" stays disabled until the question is answered', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('سؤال ۱ از ۳'), findsOneWidget);
    expect(_enabled(tester, 'بعدی'), isFalse);

    await tester.tap(find.text('بعدی'));
    await _settle(tester);
    expect(find.text('سؤال ۱ از ۳'), findsOneWidget);

    await tester.tap(find.text('ب۱'));
    await tester.pump();
    expect(_enabled(tester, 'بعدی'), isTrue);
    await _settle(tester);
  });

  testWidgets('picking an answer does not move on by itself', (tester) async {
    await pump(tester);

    await tester.tap(find.text('ب۱'));
    await _settle(tester);
    expect(find.text('سؤال ۱ از ۳'), findsOneWidget);
    expect(_enabled(tester, 'بعدی'), isTrue);

    await tester.tap(find.text('بعدی'));
    await _settle(tester);
    expect(find.text('سؤال ۲ از ۳'), findsOneWidget);
  });

  testWidgets('the last question has the submit button and sends all', (
    tester,
  ) async {
    final sent = await pump(tester);

    await tester.tap(find.text('ب۱'));
    await tester.pump();
    await tester.tap(find.text('بعدی'));
    await _settle(tester);
    await tester.tap(find.text('الف۲'));
    await tester.pump();
    await tester.tap(find.text('بعدی'));
    await _settle(tester);

    expect(find.text('سؤال ۳ از ۳'), findsOneWidget);
    expect(find.text('بعدی'), findsNothing);
    expect(find.text('مرور پاسخ‌ها'), findsNothing);
    expect(_enabled(tester, 'ارسال پاسخ'), isFalse);

    await tester.tap(find.text('درست'));
    await _settle(tester);
    expect(_enabled(tester, 'ارسال پاسخ'), isTrue);

    await tester.tap(find.text('ارسال پاسخ'));
    await tester.pump();

    expect(sent, hasLength(1));
    expect(sent.single.map((a) => a.questionId), ['q1', 'q2', 'q3']);
    expect(sent.single.map((a) => a.answer), [1, 0, true]);
  });

  testWidgets('"قبلی" goes back and keeps the earlier answer', (tester) async {
    final sent = await pump(tester);

    await tester.tap(find.text('ب۱'));
    await tester.pump();
    await tester.tap(find.text('بعدی'));
    await _settle(tester);
    await tester.tap(find.text('قبلی'));
    await _settle(tester);
    expect(find.text('سؤال ۱ از ۳'), findsOneWidget);

    await tester.tap(find.text('ج۱'));
    await tester.pump();
    await tester.tap(find.text('بعدی'));
    await _settle(tester);
    await tester.tap(find.text('الف۲'));
    await tester.pump();
    await tester.tap(find.text('بعدی'));
    await _settle(tester);
    await tester.tap(find.text('نادرست'));
    await _settle(tester);
    await tester.tap(find.text('ارسال پاسخ'));
    await tester.pump();

    expect(sent.single.map((a) => a.answer), [2, 0, false]);
  });

  testWidgets('reset() returns to the first question and clears answers', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('ب۱'));
    await _settle(tester);

    tester.state<QuizUnitContentState>(find.byType(QuizUnitContent)).reset();
    await _settle(tester);

    expect(find.text('سؤال ۱ از ۳'), findsOneWidget);
    expect(_enabled(tester, 'بعدی'), isFalse);
  });
}
