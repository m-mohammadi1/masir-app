import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/app/common/lesson_blocks.dart';

Widget _host(Widget child) => MaterialApp(
  builder: (context, c) => Directionality(textDirection: TextDirection.rtl, child: c!),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  testWidgets('lesson blocks render natively', (tester) async {
    await tester.pumpWidget(_host(const LessonBlocks(payload: {
      'blocks': [
        {'type': 'h', 'level': 2, 'text': [{'t': 'سه قدم'}]},
        {'type': 'p', 'text': [{'t': 'قبل از '}, {'t': 'لیسنینگ', 'b': true, 'h': 'sun'}]},
        {'type': 'list', 'style': 'number', 'items': [{'text': [{'t': 'دستورالعمل رو بخون.'}]}, {'text': [{'t': 'علامت بزن.'}]}]},
        {'type': 'callout', 'style': 'tip', 'items': [{'text': [{'t': 'جا ننداز.'}]}]},
        {'type': 'callout', 'style': 'example', 'items': [{'ltr': true, 'text': [{'t': 'The library is closed.'}]}]},
        {'type': 'image', 'image_id': 'gone', 'size': 'full'},
        {'type': 'divider'},
      ],
      'images': {},
    })));
    expect(find.text('سه قدم'), findsOneWidget);
    expect(find.text('قبل از لیسنینگ', findRichText: true), findsOneWidget);
    expect(find.text('۱'), findsOneWidget);
    expect(find.text('۲'), findsOneWidget);
    expect(find.text('نکته'), findsOneWidget);
    expect(find.text('یه نمونه'), findsOneWidget);
    // An image deleted from the file store is skipped, not broken.
    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('legacy lessons fall back to HTML', () {
    expect(LessonBlocks.has({'body': '<p>x</p>'}), isFalse);
    expect(LessonBlocks.has({'blocks': [{'type': 'p'}]}), isTrue);
  });
}
