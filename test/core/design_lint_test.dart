import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keeps screens on the design tokens: no raw font sizes, raw radii or
/// shadows under `lib/features`. The video player is the only exception (it
/// needs a black scrim over video). The roadmap is not exempt.
void main() {
  final rules = <String, RegExp>{
    'raw fontSize literal (use CustomText roles / MasirText)': RegExp(
      r'fontSize:\s*\d',
    ),
    'raw BorderRadius.circular literal (use MasirRadius)': RegExp(
      r'BorderRadius\.circular\(\s*\d',
    ),
    'BoxShadow (depth comes from ChunkyBox lips)': RegExp(r'BoxShadow'),
  };

  const allowed = {'video_player.dart'};

  test('lib/features follows the design tokens', () {
    final violations = <String>[];
    final files = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .where((f) => !allowed.any(f.path.endsWith));

    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        for (final rule in rules.entries) {
          if (rule.value.hasMatch(line)) {
            violations.add('${file.path}:${i + 1}  ${rule.key}');
          }
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
