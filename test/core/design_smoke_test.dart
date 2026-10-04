import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/core/theme/institute_presets.dart';
import 'package:mohammad/core/theme/institute_themed.dart';
import 'package:mohammad/features/quiz/presentation/widgets/option_widget.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_top_bar.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/icon_tile.dart';
import 'package:mohammad/widgets/list_row.dart';
import 'package:mohammad/widgets/masir_card.dart';
import 'package:mohammad/widgets/masir_page.dart';
import 'package:mohammad/widgets/section_header.dart';
import 'package:mohammad/widgets/stat_tile.dart';
import 'package:mohammad/widgets/state_view.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import 'package:mohammad/widgets/progress_pill.dart';

Widget _host(ThemeData theme, Widget child) => MaterialApp(
  theme: theme,
  locale: const Locale('fa'),
  builder: (context, c) =>
      Directionality(textDirection: TextDirection.rtl, child: c!),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void _noop() {}

void main() {
  for (final entry in {'light': light, 'dark': dark}.entries) {
    testWidgets('design primitives render without errors (${entry.key})', (
      tester,
    ) async {
      var theme = entry.value;
      await tester.pumpWidget(
        _host(
          theme,
          ListView(
            children: [
              UnitTopBar(title: 'عنوان درس', onClose: () {}, progress: 40),
              const SizedBox(height: 12),
              const OptionWidget(title: 'گزینه', selected: true),
              const SizedBox(height: 12),
              const OptionWidget(title: 'گزینه دوم'),
              const SizedBox(height: 12),
              const Wrap(
                children: [
                  PillChip('مقدماتی'),
                  PillChip('رایگان', tone: PillTone.sun),
                  PillChip('درست', tone: PillTone.success),
                  PillChip('نادرست', tone: PillTone.coral),
                ],
              ),
              const ProgressPill(value: 60),
              CustomButton(title: 'ادامه', onTap: () {}),
              CustomButton(
                title: 'ادامه',
                variant: ButtonVariant.success,
                onTap: () {},
              ),
              CustomButton(title: 'غیرفعال', enable: false),
              ChunkyBox(
                fill: Colors.white,
                edge: Colors.grey,
                onTap: () {},
                child: const Text('x'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  // Every page variant, in both modes, under two institute presets (and none).
  final variants = <String, Widget Function()>{
    'tab (children)': () => MasirPage.tab(
      title: 'خانه',
      subtitle: 'سلام',
      children: [
        const SectionHeader('دوره‌ها', actionLabel: 'همه', onAction: _noop),
        MasirCard(child: const Text('کارت')),
        ListRow.menu(
          icon: Icons.person_rounded,
          title: 'پروفایل',
          onTap: _noop,
        ),
        const Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.bolt_rounded,
                value: '۱۲',
                label: 'امتیاز',
              ),
            ),
          ],
        ),
      ],
    ),
    'tab (body)': () => const MasirPage.tab(
      title: 'مؤسسه‌ها',
      body: StateView.empty(text: 'خالیه', description: 'چیزی نیست'),
    ),
    'detail': () => MasirPage.detail(
      title: 'جزئیات',
      stickyBottom: CustomButton(title: 'شروع', onTap: () {}),
      children: const [IconTile(Icons.star_rounded), Text('متن')],
    ),
    'focus': () => MasirPage.focus(
      title: 'درس',
      progress: 40,
      onClose: () {},
      stickyBottom: CustomButton(title: 'ادامه', onTap: () {}),
      children: const [Text('محتوا')],
    ),
    'plain': () => const MasirPage.plain(body: Center(child: Text('ساده'))),
    'loading': () => const MasirPage.detail(
      title: 'در حال بارگذاری',
      body: StateView.loading(variant: SkeletonVariant.detail),
    ),
    'error': () => MasirPage.detail(
      title: 'خطا',
      body: StateView.error(message: 'مشکلی پیش اومد', retry: () {}),
    ),
  };

  for (final mode in {'light': light, 'dark': dark}.entries) {
    for (final preset in <String?>[null, 'violet', 'ocean']) {
      for (final v in variants.entries) {
        testWidgets(
          'page ${v.key} renders (${mode.key}, ${preset ?? 'global'})',
          (tester) async {
            await tester.pumpWidget(
              MaterialApp(
                theme: mode.value,
                locale: const Locale('fa'),
                builder: (context, c) =>
                    Directionality(textDirection: TextDirection.rtl, child: c!),
                home: InstituteThemed(preset: preset, child: v.value()),
              ),
            );
            await tester.pump(const Duration(milliseconds: 800));
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  testWidgets('institute presets produce valid colour sets', (tester) async {
    for (final key in ['violet', 'ocean', 'sunset', 'unknown']) {
      final p = presetFor(key);
      expect(p.primary.a, 1);
      expect(p.edge, isNot(p.primary));
    }
  });
}
