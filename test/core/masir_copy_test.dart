import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/copy/masir_copy.dart';

void main() {
  DateTime at(int hour) => DateTime(2026, 10, 4, hour);

  group('greeting', () {
    test('follows the time of day', () {
      expect(
        MasirCopy.greeting('علی', now: at(2)),
        'شب بخیر علی، هنوز بیداری؟',
      );
      expect(MasirCopy.greeting('علی', now: at(8)), 'صبح بخیر علی');
      expect(MasirCopy.greeting('علی', now: at(13)), 'ظهرت بخیر علی');
      expect(MasirCopy.greeting('علی', now: at(18)), 'عصر بخیر علی');
      expect(MasirCopy.greeting('علی', now: at(22)), 'شب بخیر علی');
    });

    test('falls back to a friendly hello without a name', () {
      expect(MasirCopy.greeting(null, now: at(8)), 'سلام رفیق');
      expect(MasirCopy.greeting('  ', now: at(8)), 'سلام رفیق');
    });
  });

  group('rotating phrases', () {
    tearDown(() => MasirCopy.random = Random());

    test('are pinned by a seeded random', () {
      MasirCopy.random = Random(7);
      final first = [MasirCopy.cheer(), MasirCopy.nearMiss()];
      MasirCopy.random = Random(7);
      final second = [MasirCopy.cheer(), MasirCopy.nearMiss()];
      expect(second, first);
      expect(first.every((s) => s.isNotEmpty), isTrue);
    });
  });
}
