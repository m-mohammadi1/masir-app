import 'package:flutter/material.dart';

import 'tokens.dart';

/// An institute colour: p = primary, e = edge (lip under buttons), on = text
/// on p, soft = tinted backgrounds, ink = coloured text on paper. Every pair is
/// contrast-checked; institutes pick one of 32 (16 hues x bright/deep).
@immutable
class InstitutePalette {
  final String key;
  final Color p;
  final Color e;
  final Color on;
  final Color soft;
  final Color ink;
  final String nameFa;

  const InstitutePalette({
    required this.key,
    required this.p,
    required this.e,
    required this.on,
    required this.soft,
    required this.ink,
    required this.nameFa,
  });

  /// Light palettes take dark text on buttons.
  bool get darkText => on.computeLuminance() < 0.5;

  /// Amber institutes collide with the reward colour, so their paths and
  /// rewards use a deeper green instead of sun (Main board note).
  bool get clashesWithSun => key == '70b' || key == '90b';

  @override
  bool operator ==(Object other) => other is InstitutePalette && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Masir's own space is always violet.
const masirPalette = InstitutePalette(
  key: 'masir',
  p: C.violet,
  e: C.violetDark,
  on: Color(0xFFFFFFFF),
  soft: C.violetSoft,
  ink: C.violetDark,
  nameFa: 'بنفش مسیر',
);

const List<int> paletteHues = [330, 350, 10, 30, 50, 70, 90, 110, 130, 150, 170, 190, 210, 230, 250, 270];

const Map<String, InstitutePalette> institutePalettes = {
  '330b': InstitutePalette(key: '330b', p: Color(0xFFB942B3), e: Color(0xFF981D93), on: Color(0xFFFFFFFF), soft: Color(0xFFFCE9FA), ink: Color(0xFF722C6E), nameFa: 'سرخابی روشن'),
  '330d': InstitutePalette(key: '330d', p: Color(0xFF873482), e: Color(0xFF681264), on: Color(0xFFFFFFFF), soft: Color(0xFFFCE9FA), ink: Color(0xFF722C6E), nameFa: 'سرخابی عمیق'),
  '350b': InstitutePalette(key: '350b', p: Color(0xFFCB378C), e: Color(0xFFA9056E), on: Color(0xFFFFFFFF), soft: Color(0xFFFFE9F3), ink: Color(0xFF7E2757), nameFa: 'صورتی روشن'),
  '350d': InstitutePalette(key: '350d', p: Color(0xFF942D66), e: Color(0xFF73054B), on: Color(0xFFFFFFFF), soft: Color(0xFFFFE9F3), ink: Color(0xFF7E2757), nameFa: 'صورتی عمیق'),
  '10b': InstitutePalette(key: '10b', p: Color(0xFFD63260), e: Color(0xFFB10045), on: Color(0xFFFFFFFF), soft: Color(0xFFFEEAED), ink: Color(0xFF84253D), nameFa: 'اناری روشن'),
  '10d': InstitutePalette(key: '10d', p: Color(0xFF9C2A47), e: Color(0xFF7A002D), on: Color(0xFFFFFFFF), soft: Color(0xFFFEEAED), ink: Color(0xFF84253D), nameFa: 'اناری عمیق'),
  '30b': InstitutePalette(key: '30b', p: Color(0xFFD93828), e: Color(0xFFB30C01), on: Color(0xFFFFFFFF), soft: Color(0xFFFFEBE7), ink: Color(0xFF86281D), nameFa: 'قرمز روشن'),
  '30d': InstitutePalette(key: '30d', p: Color(0xFF9E2E21), e: Color(0xFF7C0600), on: Color(0xFFFFFFFF), soft: Color(0xFFFFEBE7), ink: Color(0xFF86281D), nameFa: 'قرمز عمیق'),
  '50b': InstitutePalette(key: '50b', p: Color(0xFFF57404), e: Color(0xFFC85D02), on: Color(0xFF2F1100), soft: Color(0xFFFEECE2), ink: Color(0xFF7B3702), nameFa: 'نارنجی روشن'),
  '50d': InstitutePalette(key: '50d', p: Color(0xFF8F4100), e: Color(0xFF672C00), on: Color(0xFFFFFFFF), soft: Color(0xFFFEECE2), ink: Color(0xFF7B3702), nameFa: 'نارنجی عمیق'),
  '70b': InstitutePalette(key: '70b', p: Color(0xFFFFA92B), e: Color(0xFFD98B09), on: Color(0xFF281600), soft: Color(0xFFFEEDDB), ink: Color(0xFF6C4302), nameFa: 'کهربایی روشن'),
  '70d': InstitutePalette(key: '70d', p: Color(0xFF7E4F04), e: Color(0xFF5A3700), on: Color(0xFFFFFFFF), soft: Color(0xFFFEEDDB), ink: Color(0xFF6C4302), nameFa: 'کهربایی عمیق'),
  '90b': InstitutePalette(key: '90b', p: Color(0xFFE6B70B), e: Color(0xFFC19906), on: Color(0xFF221901), soft: Color(0xFFF8F0DA), ink: Color(0xFF5F4A04), nameFa: 'زعفرانی روشن'),
  '90d': InstitutePalette(key: '90d', p: Color(0xFF705800), e: Color(0xFF4F3D03), on: Color(0xFFFFFFFF), soft: Color(0xFFF8F0DA), ink: Color(0xFF5F4A04), nameFa: 'زعفرانی عمیق'),
  '110b': InstitutePalette(key: '110b', p: Color(0xFFBFC002), e: Color(0xFF9F9F02), on: Color(0xFF1C1C00), soft: Color(0xFFF1F2DC), ink: Color(0xFF505103), nameFa: 'لیمویی روشن'),
  '110d': InstitutePalette(key: '110d', p: Color(0xFF5F5F01), e: Color(0xFF434301), on: Color(0xFFFFFFFF), soft: Color(0xFFF1F2DC), ink: Color(0xFF505103), nameFa: 'لیمویی عمیق'),
  '130b': InstitutePalette(key: '130b', p: Color(0xFF8BCF23), e: Color(0xFF72AD04), on: Color(0xFF112001), soft: Color(0xFFEAF5E0), ink: Color(0xFF385802), nameFa: 'پسته‌ای روشن'),
  '130d': InstitutePalette(key: '130d', p: Color(0xFF426801), e: Color(0xFF2E4902), on: Color(0xFFFFFFFF), soft: Color(0xFFEAF5E0), ink: Color(0xFF385802), nameFa: 'پسته‌ای عمیق'),
  '150b': InstitutePalette(key: '150b', p: Color(0xFF04BE58), e: Color(0xFF059A46), on: Color(0xFF00220A), soft: Color(0xFFE3F6E6), ink: Color(0xFF035D28), nameFa: 'سبز روشن'),
  '150d': InstitutePalette(key: '150d', p: Color(0xFF046E30), e: Color(0xFF004E20), on: Color(0xFFFFFFFF), soft: Color(0xFFE3F6E6), ink: Color(0xFF035D28), nameFa: 'سبز عمیق'),
  '170b': InstitutePalette(key: '170b', p: Color(0xFF04B991), e: Color(0xFF049675), on: Color(0xFF012118), soft: Color(0xFFDDF7ED), ink: Color(0xFF035B46), nameFa: 'زمردی روشن'),
  '170d': InstitutePalette(key: '170d', p: Color(0xFF046B53), e: Color(0xFF034C3A), on: Color(0xFFFFFFFF), soft: Color(0xFFDDF7ED), ink: Color(0xFF035B46), nameFa: 'زمردی عمیق'),
  '190b': InstitutePalette(key: '190b', p: Color(0xFF0CAFA8), e: Color(0xFF018D87), on: Color(0xFF00201E), soft: Color(0xFFDAF7F4), ink: Color(0xFF025956), nameFa: 'فیروزه‌ای روشن'),
  '190d': InstitutePalette(key: '190d', p: Color(0xFF056965), e: Color(0xFF004A47), on: Color(0xFFFFFFFF), soft: Color(0xFFDAF7F4), ink: Color(0xFF025956), nameFa: 'فیروزه‌ای عمیق'),
  '210b': InstitutePalette(key: '210b', p: Color(0xFF0DABC0), e: Color(0xFF028A9B), on: Color(0xFF001F24), soft: Color(0xFFDAF6FB), ink: Color(0xFF025763), nameFa: 'آسمانی روشن'),
  '210d': InstitutePalette(key: '210d', p: Color(0xFF056774), e: Color(0xFF004952), on: Color(0xFFFFFFFF), soft: Color(0xFFDAF6FB), ink: Color(0xFF025763), nameFa: 'آسمانی عمیق'),
  '230b': InstitutePalette(key: '230b', p: Color(0xFF0AA6DA), e: Color(0xFF0886B0), on: Color(0xFF001E2B), soft: Color(0xFFDFF4FF), ink: Color(0xFF045571), nameFa: 'آبی روشن'),
  '230d': InstitutePalette(key: '230d', p: Color(0xFF056484), e: Color(0xFF03465E), on: Color(0xFFFFFFFF), soft: Color(0xFFDFF4FF), ink: Color(0xFF045571), nameFa: 'آبی عمیق'),
  '250b': InstitutePalette(key: '250b', p: Color(0xFF0177CC), e: Color(0xFF005A9D), on: Color(0xFFFFFFFF), soft: Color(0xFFE5F2FF), ink: Color(0xFF014F8A), nameFa: 'لاجوردی روشن'),
  '250d': InstitutePalette(key: '250d', p: Color(0xFF025DA1), e: Color(0xFF014174), on: Color(0xFFFFFFFF), soft: Color(0xFFE5F2FF), ink: Color(0xFF014F8A), nameFa: 'لاجوردی عمیق'),
  '270b': InstitutePalette(key: '270b', p: Color(0xFF4C68EB), e: Color(0xFF3447C8), on: Color(0xFFFFFFFF), soft: Color(0xFFEBF0FE), ink: Color(0xFF334593), nameFa: 'نیلی روشن'),
  '270d': InstitutePalette(key: '270d', p: Color(0xFF3B51AE), e: Color(0xFF24338D), on: Color(0xFFFFFFFF), soft: Color(0xFFEBF0FE), ink: Color(0xFF334593), nameFa: 'نیلی عمیق'),
};

InstitutePalette paletteFor(String? key) =>
    institutePalettes[key] ?? institutePalettes['270b']!;
