import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/widgets/masir_notice.dart';

Widget _host(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? light,
  home: Scaffold(
    body: Directionality(
      textDirection: TextDirection.rtl,
      child: Align(alignment: Alignment.topCenter, child: child),
    ),
  ),
);

void main() {
  for (final tone in NoticeTone.values) {
    for (final entry in {'light': light, 'dark': dark}.entries) {
      testWidgets('notice is medium sized (${tone.name}, ${entry.key})', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(390 * 3, 844 * 3);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _host(
            MasirNotice(
              title: 'دمت گرم!',
              message: 'درس بعدی: زمان حال',
              tone: tone,
            ),
            theme: entry.value,
          ),
        );
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('دمت گرم!'), findsOneWidget);
        expect(find.text('درس بعدی: زمان حال'), findsOneWidget);
        final size = tester.getSize(find.byType(MasirNotice));
        expect(size.height, inInclusiveRange(MasirNotice.minHeight, 110));
        expect(size.width, lessThanOrEqualTo(MasirNotice.maxWidth));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('a long single-line error stays inside the size bounds', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        MasirNotice(
          title:
              'اینترنتت قطعه یا ضعیفه، یه نگاه بنداز و دوباره امتحان کن. ' * 4,
          tone: NoticeTone.error,
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    final size = tester.getSize(find.byType(MasirNotice));
    expect(size.height, inInclusiveRange(MasirNotice.minHeight, 130));
    expect(tester.takeException(), isNull);
  });
}
