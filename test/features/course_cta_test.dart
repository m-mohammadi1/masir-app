import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/feedback/masir_feedback.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/features/home/page/detail_course_page.dart';

Widget _host({
  required bool subscribed,
  VoidCallback? onRegister,
  VoidCallback? onRoadmap,
}) => MaterialApp(
  theme: light,
  home: Scaffold(
    body: Directionality(
      textDirection: TextDirection.rtl,
      child: CourseCta(
        subscribed: subscribed,
        busy: false,
        priceLabel: 'رایگان',
        onRegister: onRegister ?? () {},
        onRoadmap: onRoadmap ?? () {},
      ),
    ),
  ),
);

void main() {
  setUp(() => MasirFeedback.isEnabled = () => false);

  testWidgets('not subscribed: sign-up and roadmap are both offered', (
    tester,
  ) async {
    var registered = 0;
    var opened = 0;
    await tester.pumpWidget(
      _host(
        subscribed: false,
        onRegister: () => registered++,
        onRoadmap: () => opened++,
      ),
    );

    expect(find.text('ثبت‌نام'), findsOneWidget);
    expect(find.text('مسیر یادگیری'), findsOneWidget);
    expect(find.text('رایگان'), findsOneWidget);

    await tester.tap(find.text('ثبت‌نام'));
    await tester.tap(find.text('مسیر یادگیری'));
    expect(registered, 1);
    expect(opened, 1);
  });

  testWidgets('subscribed: only the roadmap button, no sign-up', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpWidget(_host(subscribed: true, onRoadmap: () => opened++));

    expect(find.text('ثبت‌نام'), findsNothing);
    expect(find.text('رایگان'), findsNothing);
    expect(find.text('مسیر یادگیری'), findsOneWidget);

    await tester.tap(find.text('مسیر یادگیری'));
    expect(opened, 1);
  });
}
