import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/core/theme/institute_presets.dart';
import 'package:mohammad/core/theme/masir_colors.dart';
import 'package:mohammad/features/quiz/presentation/widgets/option_widget.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_top_bar.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import 'package:mohammad/widgets/progress_pill.dart';

Widget _host(ThemeData theme, Widget child) => MaterialApp(
  theme: theme,
  locale: const Locale('fa'),
  builder: (context, c) => Directionality(textDirection: TextDirection.rtl, child: c!),
  home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)),
);

void main() {
  for (final entry in {'light': light, 'dark': dark}.entries) {
    testWidgets('design primitives render without errors (${entry.key})', (tester) async {
      var theme = entry.value;
      await tester.pumpWidget(_host(theme, ListView(children: [
        UnitTopBar(title: 'عنوان درس', onClose: () {}, progress: 40),
        const SizedBox(height: 12),
        const OptionWidget(title: 'گزینه', selected: true),
        const SizedBox(height: 12),
        const OptionWidget(title: 'گزینه دوم'),
        const SizedBox(height: 12),
        const Wrap(children: [
          PillChip('مقدماتی'),
          PillChip('رایگان', tone: PillTone.sun),
          PillChip('درست', tone: PillTone.success),
          PillChip('نادرست', tone: PillTone.coral),
        ]),
        const ProgressPill(value: 60),
        CustomButton(title: 'ادامه', onTap: () {}),
        CustomButton(title: 'ادامه', variant: ButtonVariant.success, onTap: () {}),
        CustomButton(title: 'غیرفعال', enable: false),
        ChunkyBox(fill: Colors.white, edge: Colors.grey, onTap: () {}, child: const Text('x')),
      ])));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('institute presets produce valid colour sets', (tester) async {
    for (final key in ['violet', 'ocean', 'sunset', 'unknown']) {
      final p = presetFor(key);
      expect(p.primary.a, 1);
      expect(p.edge, isNot(p.primary));
    }
  });
}
