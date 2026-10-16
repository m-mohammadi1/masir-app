import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/design/motion.dart';

Widget _host(Widget child, {bool reduced = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: child)),
  ),
);

void main() {
  test('circle reveal reaches the farthest corner at fraction 1', () {
    final clip = CircleRevealClipper(const Offset(0, 0), 1).getClip(const Size(300, 400));
    expect(clip.contains(const Offset(299, 399)), isTrue);
    final half = CircleRevealClipper(const Offset(0, 0), 0.5).getClip(const Size(300, 400));
    expect(half.contains(const Offset(299, 399)), isFalse);
  });

  testWidgets('pressable fires on tap-up and sinks while held', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(Center(
      child: MasirPressable(
        onTap: () => taps++,
        builder: (_, pressed) => SizedBox(width: 120, height: 48, child: Text(pressed ? 'down' : 'up')),
      ),
    )));
    final g = await tester.startGesture(tester.getCenter(find.text('up')));
    await tester.pump(MasirMotion.instant);
    expect(find.text('down'), findsOneWidget);
    expect(taps, 0, reason: 'nothing fires before release');
    await g.up();
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(find.text('up'), findsOneWidget);
  });

  testWidgets('count-up counts to the value in Persian digits', (tester) async {
    await tester.pumpWidget(_host(const MasirCountUp(value: 45, format: MasirCountUp.percent)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('۴۵٪'), findsNothing, reason: 'still counting');
    await tester.pumpAndSettle();
    expect(find.text('۴۵٪'), findsOneWidget);
  });

  testWidgets('reduced motion: count-up jumps straight to the value', (tester) async {
    await tester.pumpWidget(_host(const MasirCountUp(value: 45, format: MasirCountUp.percent), reduced: true));
    expect(find.text('۴۵٪'), findsOneWidget);
  });

  testWidgets('stagger plays on the first visit only', (tester) async {
    MasirStagger.reset();
    Widget list() => _host(const MasirStagger(id: 'list', children: [Text('a'), Text('b')]));
    await tester.pumpWidget(list());
    await tester.pump(const Duration(milliseconds: 10));
    expect(tester.widget<Opacity>(find.ancestor(of: find.text('a'), matching: find.byType(Opacity)).first).opacity, lessThan(1));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(list());
    expect(find.ancestor(of: find.text('a'), matching: find.byType(Opacity)), findsNothing, reason: 'coming back never replays');
  });

  testWidgets('tab stack shows only the selected tab and fades to a new one', (tester) async {
    Widget tabs(int i) => _host(MasirTabStack(index: i, children: const [Text('one'), Text('two')]));
    await tester.pumpWidget(tabs(0));
    expect(find.text('one'), findsOneWidget);
    expect(find.text('two'), findsNothing);
    await tester.pumpWidget(tabs(1));
    await tester.pump(const Duration(milliseconds: 40));
    expect(find.text('one'), findsOneWidget, reason: 'old tab is still fading out');
    await tester.pumpAndSettle();
    expect(find.text('one'), findsNothing);
    expect(find.text('two'), findsOneWidget);
  });
}
