import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/feedback/masir_feedback.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/pressable.dart';

Widget _host(Widget child, {bool reduceMotion = false}) => MaterialApp(
  builder: (context, c) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
    child: c!,
  ),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  setUp(() => MasirFeedback.isEnabled = () => false);

  for (final reduce in [false, true]) {
    testWidgets('ChunkyBox taps and presses (reduced motion: $reduce)', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          ChunkyBox(
            fill: Colors.white,
            edge: Colors.grey,
            width: 100,
            height: 50,
            onTap: () => taps++,
            child: const SizedBox(),
          ),
          reduceMotion: reduce,
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(ChunkyBox)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 300));

      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Pressable taps (reduced motion: $reduce)', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          Pressable(onTap: () => taps++, child: const Text('x')),
          reduceMotion: reduce,
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(taps, 1);
    });
  }

  testWidgets('ChunkyBox without onTap does not react', (tester) async {
    await tester.pumpWidget(
      _host(
        const ChunkyBox(
          fill: Colors.white,
          edge: Colors.grey,
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );
    expect(find.byType(GestureDetector), findsNothing);
  });
}
