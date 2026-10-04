import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keeps the app's voice casual: spoken Persian, no stiff official phrases.
void main() {
  const formal = {
    'لطفا': 'say it directly instead of "لطفا"',
    'لطفاً': 'say it directly instead of "لطفاً"',
    'می‌باشد': 'use "هست" / "ـه"',
    'نمایید': 'use the spoken "کن"',
    'فرمایید': 'use the spoken "کن"',
    'با موفقیت': 'say what happened ("ذخیره شد!")',
    'وجود ندارد': 'use "نیست" / "نداره"',
    'تاییدیه': 'ask a question instead',
    'تأییدیه': 'ask a question instead',
  };

  test('user-facing strings stay casual', () {
    final violations = <String>[];
    final roots = ['lib', 'packages/easy_helper/lib'];
    for (final root in roots) {
      final files = Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));
      for (final file in files) {
        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.trimLeft().startsWith('//')) continue;
          for (final entry in formal.entries) {
            if (line.contains(entry.key)) {
              violations.add(
                '${file.path}:${i + 1}  "${entry.key}" ${entry.value}',
              );
            }
          }
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
