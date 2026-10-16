import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/app/state/error_recovery.dart';

class _Throws extends StatelessWidget {
  const _Throws();
  @override
  Widget build(BuildContext context) => throw StateError('boom');
}

void main() {
  testWidgets('a page that throws while building offers a way out', (tester) async {
    final original = ErrorWidget.builder;
    ErrorWidget.builder = (details) => BrokenView(details: details);
    try {
      await tester.pumpWidget(const MaterialApp(home: _Throws()));
      expect(tester.takeException(), isA<StateError>());
      expect(find.text('این صفحه درست باز نشد'), findsOneWidget);
      expect(find.text('دوباره امتحان کن'), findsOneWidget);
      expect(find.text('برگشت به ویترین'), findsOneWidget);
    } finally {
      ErrorWidget.builder = original;
    }
  });

  testWidgets('an error outside a build raises the recovery bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RecoveryBar(child: Scaffold(body: Text('page')))));
    expect(find.text('یه چیزی درست کار نکرد'), findsNothing);

    AppErrors.report(StateError('async'));
    await tester.pump();
    await tester.pump();
    expect(find.text('یه چیزی درست کار نکرد'), findsOneWidget);
    expect(find.text('page'), findsOneWidget, reason: 'the page stays underneath');

    await tester.tap(find.byTooltip('بستن'));
    await tester.pump();
    expect(find.text('یه چیزی درست کار نکرد'), findsNothing);
  });
}
