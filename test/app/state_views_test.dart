import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/design/design.dart';

Widget _host(Widget child) => MaterialApp(
  builder: (context, c) => Directionality(textDirection: TextDirection.rtl, child: c!),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('empty state shows its action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_host(Center(
      child: EmptyState(icon: MI.megaphone, title: 'اطلاعیه‌ای نیست', body: 'بعداً سر بزن', action: 'ادامه یادگیری', onAction: () => tapped = true),
    )));
    expect(find.text('اطلاعیه‌ای نیست'), findsOneWidget);
    await tester.tap(find.text('ادامه یادگیری'));
    expect(tapped, isTrue);
  });

  testWidgets('offline page retries and goes back', (tester) async {
    var retried = 0, back = 0;
    await tester.pumpWidget(_host(OfflineView(onRetry: () => retried++, onBack: () => back++)));
    expect(find.text('به سرور وصل نشدیم!'), findsOneWidget);
    await tester.tap(find.text('دوباره امتحان کن'));
    await tester.tap(find.text('برگردیم'));
    expect((retried, back), (1, 1));
  });

  testWidgets('inline error keeps the rest of the page', (tester) async {
    var retried = false;
    await tester.pumpWidget(_host(InlineError(body: 'دوره‌ها نیومد', onRetry: () => retried = true)));
    await tester.tap(find.text('دوباره امتحان کن'));
    expect(retried, isTrue);
  });
}
