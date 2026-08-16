import 'package:flutter/material.dart';

import '/core/theme/masir_colors.dart';

class InstitutePreset {
  final Color primary;
  final Color primarySoft;
  final Color onPrimary;

  const InstitutePreset({
    required this.primary,
    required this.primarySoft,
    required this.onPrimary,
  });
}

const String kDefaultPreset = 'indigo';

const Map<String, InstitutePreset> kInstitutePresets = {
  'indigo': InstitutePreset(
    primary: Color(0xFF4F46E5),
    primarySoft: Color(0xFFEEF2FF),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'violet': InstitutePreset(
    primary: Color(0xFF7C3AED),
    primarySoft: Color(0xFFF5F3FF),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'sky': InstitutePreset(
    primary: Color(0xFF0284C7),
    primarySoft: Color(0xFFF0F9FF),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'teal': InstitutePreset(
    primary: Color(0xFF0D9488),
    primarySoft: Color(0xFFF0FDFA),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'emerald': InstitutePreset(
    primary: Color(0xFF059669),
    primarySoft: Color(0xFFECFDF5),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'amber': InstitutePreset(
    primary: Color(0xFFD97706),
    primarySoft: Color(0xFFFFFBEB),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'rose': InstitutePreset(
    primary: Color(0xFFE11D48),
    primarySoft: Color(0xFFFFF1F2),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'slate': InstitutePreset(
    primary: Color(0xFF475569),
    primarySoft: Color(0xFFF8FAFC),
    onPrimary: Color(0xFFFFFFFF),
  ),
};

MasirColors instituteColors(String? presetKey, Brightness brightness) {
  final preset = kInstitutePresets[presetKey] ?? kInstitutePresets[kDefaultPreset]!;
  final base = brightness == Brightness.dark ? MasirColors.dark : MasirColors.light;

  if (brightness == Brightness.light) {
    return base.copyWith(
      primary: preset.primary,
      primaryTint: preset.primarySoft,
      onPrimary: preset.onPrimary,
      accent: preset.primary,
    );
  }

  final primary = Color.lerp(preset.primary, const Color(0xFFFFFFFF), 0.16)!;
  final soft = Color.alphaBlend(
    preset.primary.withValues(alpha: 0.18),
    base.surface,
  );

  return base.copyWith(
    primary: primary,
    primaryTint: soft,
    onPrimary: preset.onPrimary,
    accent: primary,
  );
}
