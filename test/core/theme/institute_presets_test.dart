import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/theme/institute_presets.dart';
import 'package:mohammad/core/theme/masir_colors.dart';

void main() {
  test('instituteColors teal light overrides primary and inherits the rest', () {
    final colors = instituteColors('teal', Brightness.light);
    final teal = kInstitutePresets['teal']!;

    expect(colors.primary, teal.primary);
    expect(colors.primaryTint, teal.primarySoft);
    expect(colors.primarySoft, teal.primarySoft);
    expect(colors.onPrimary, teal.onPrimary);
    expect(colors.accent, teal.primary);
    expect(colors.surface, MasirColors.light.surface);
    expect(colors.ink, MasirColors.light.ink);
    expect(colors.background, MasirColors.light.background);
  });

  test('instituteColors unknown key falls back to indigo', () {
    final colors = instituteColors('nonsense', Brightness.light);
    final indigo = instituteColors('indigo', Brightness.light);

    expect(colors.primary, indigo.primary);
    expect(colors.primaryTint, indigo.primaryTint);
    expect(colors.onPrimary, indigo.onPrimary);
  });
}
