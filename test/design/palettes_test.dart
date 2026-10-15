import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/design/palettes.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final hi = la > lb ? la : lb, lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  test('32 institute palettes: 16 hues, bright and deep', () {
    expect(institutePalettes.length, 32);
    for (final h in paletteHues) {
      expect(institutePalettes.containsKey('${h}b'), isTrue, reason: '${h}b');
      expect(institutePalettes.containsKey('${h}d'), isTrue, reason: '${h}d');
    }
  });

  test('button text stays readable on every palette', () {
    for (final p in institutePalettes.values) {
      expect(_contrast(p.p, p.on), greaterThanOrEqualTo(3.0), reason: p.key);
    }
  });

  test('unknown keys fall back to a real palette', () {
    expect(paletteFor('nope').key, '270b');
    expect(paletteFor(null).key, '270b');
  });
}
