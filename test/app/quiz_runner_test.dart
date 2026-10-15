import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/app/unit/quiz_view.dart';

Widget _host(Widget child) => MaterialApp(
  builder: (context, c) => Directionality(textDirection: TextDirection.rtl, child: c!),
  home: Scaffold(body: child),
);

void main() {
  const questions = [
    QuizQuestion(id: 'q1', type: 'true_false', text: 'آیا درسته؟', options: []),
    QuizQuestion(id: 'q2', type: 'four_choice', text: 'کدوم؟', options: ['یک', 'دو', 'سه', 'چهار']),
  ];

  testWidgets('next waits for an answer, the last question sends', (tester) async {
    await tester.pumpWidget(_host(QuizRunner(unitId: 'u', title: 'آزمون', questions: questions, onExit: () {}, onResult: (_) {})));
    expect(find.text('سؤال ۱ از ۲'), findsOneWidget);

    await tester.tap(find.text('بعدی'));
    await tester.pump();
    expect(find.text('سؤال ۱ از ۲'), findsOneWidget, reason: 'no answer yet');

    await tester.tap(find.text('درست'));
    await tester.pump();
    await tester.tap(find.text('بعدی'));
    await tester.pumpAndSettle();
    expect(find.text('سؤال ۲ از ۲'), findsOneWidget);
    expect(find.text('ارسال پاسخ'), findsOneWidget);
    expect(find.text('سه'), findsOneWidget);
  });

  testWidgets('leaving after answering asks first', (tester) async {
    var left = false;
    await tester.pumpWidget(_host(QuizRunner(unitId: 'u', title: 'آزمون', questions: questions, onExit: () => left = true, onResult: (_) {})));
    await tester.tap(find.text('درست'));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('خروج از آزمون'));
    await tester.pumpAndSettle();
    expect(find.text('وسط آزمون می‌ری؟'), findsOneWidget);
    await tester.tap(find.text('خروج'));
    await tester.pumpAndSettle();
    expect(left, isTrue);
  });
}
