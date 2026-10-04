import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/core/theme/institute_themed.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/audio_unit_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/html_unit_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/practice_unit_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/video_unit_content.dart';

const _lesson = UnitsModel(
  id: 'u1',
  title: 'درس نمونه',
  type: 'html',
  payload: UnitsPayloadModel(
    body: '<p>این یک متن آزمایشی برای درس است که کمی طولانی هم هست.</p>',
  ),
);

const _practice = UnitsModel(
  id: 'u2',
  title: 'تمرین نمونه',
  type: 'practice',
  payload: UnitsPayloadModel(
    instructions: 'یک پاراگراف درباره‌ی خودت بنویس.',
    attachmentUrl: 'https://example.com/file.pdf',
  ),
);

const _video = UnitsModel(
  id: 'u3',
  title: 'ویدیو نمونه',
  type: 'video',
  payload: UnitsPayloadModel(mediaAccessUrl: '', durationSeconds: 300),
);

const _audio = UnitsModel(
  id: 'u4',
  title: 'صوت نمونه',
  type: 'audio',
  payload: UnitsPayloadModel(mediaAccessUrl: ''),
);

void main() {
  final screens = <String, Widget Function(bool done)>{
    'lesson': (done) => HtmlUnitContent(
      data: _lesson,
      isCompleted: done,
      onComplete: () {},
      onBack: () {},
    ),
    'practice': (done) => PracticeUnitContent(
      data: _practice,
      isCompleted: done,
      onComplete: () {},
      onBack: () {},
    ),
    'video (empty url)': (done) => VideoUnitContent(
      data: _video,
      isCompleted: done,
      onComplete: () {},
      onBack: () {},
    ),
    'audio (empty url)': (done) => AudioUnitContent(
      data: _audio,
      isCompleted: done,
      onComplete: () {},
      onBack: () {},
    ),
  };

  for (final mode in {'light': light, 'dark': dark}.entries) {
    for (final preset in <String?>[null, 'violet']) {
      for (final screen in screens.entries) {
        for (final done in [false, true]) {
          testWidgets(
            '${screen.key} renders (${mode.key}, ${preset ?? 'global'}, '
            '${done ? 'completed' : 'open'})',
            (tester) async {
              tester.view.physicalSize = const Size(390 * 3, 844 * 3);
              tester.view.devicePixelRatio = 3;
              addTearDown(tester.view.reset);

              await tester.pumpWidget(
                MaterialApp(
                  theme: mode.value,
                  locale: const Locale('fa'),
                  builder: (context, c) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: c!,
                  ),
                  home: InstituteThemed(
                    preset: preset,
                    child: screen.value(done),
                  ),
                ),
              );
              await tester.pump(const Duration(milliseconds: 800));
              expect(tester.takeException(), isNull);
            },
          );
        }
      }
    }
  }
}
