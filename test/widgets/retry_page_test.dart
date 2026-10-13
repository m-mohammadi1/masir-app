import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host() => MaterialApp(
    home: Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RetryPage(
                backAccess: false,
                retryWidget: Text('retry'),
                backWidget: Text('back'),
                body: SizedBox(),
                background: SizedBox(),
              ),
            ),
          ),
          child: const Text('open'),
        ),
      ),
    ),
  );

  tearDown(() => GEasyHelper.retries = []);

  testWidgets('back drops the queued retries instead of keeping them', (
    tester,
  ) async {
    var ran = 0;
    GEasyHelper.retries = [() => ran++];
    await tester.pumpWidget(host());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('back'));
    await tester.pumpAndSettle();

    expect(find.text('open'), findsOneWidget);
    expect(GEasyHelper.retries, isEmpty);
    expect(ran, 0);
  });

  testWidgets('system back leaves the page and drops the queue too', (
    tester,
  ) async {
    GEasyHelper.retries = [() {}];
    await tester.pumpWidget(host());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('open'), findsOneWidget);
    expect(GEasyHelper.retries, isEmpty);
  });
}
