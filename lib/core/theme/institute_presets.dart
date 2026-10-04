import 'package:flutter/material.dart';

import '/core/theme/masir_colors.dart';

/// A constrained institute brand: a fill, the darker "edge" used for the solid
/// bottom lip of chunky elements, and a soft tint for backgrounds.
class InstitutePreset {
  final Color primary;
  final Color edge;
  final Color primarySoft;
  final Color onPrimary;

  const InstitutePreset({
    required this.primary,
    required this.edge,
    required this.primarySoft,
    required this.onPrimary,
  });
}

const String kDefaultPreset = 'indigo';

const Map<String, InstitutePreset> kInstitutePresets = {
  'indigo': InstitutePreset(
    primary: Color(0xFF5B5BEF),
    edge: Color(0xFF4141C4),
    primarySoft: Color(0xFFEDEDFF),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'violet': InstitutePreset(
    primary: Color(0xFF7E42C5),
    edge: Color(0xFF5E2D9A),
    primarySoft: Color(0xFFF3EBFF),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'sky': InstitutePreset(
    primary: Color(0xFF1CA7EC),
    edge: Color(0xFF1280BA),
    primarySoft: Color(0xFFE5F5FD),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'teal': InstitutePreset(
    primary: Color(0xFF0D9488),
    edge: Color(0xFF0A6F66),
    primarySoft: Color(0xFFE0F5F2),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'emerald': InstitutePreset(
    primary: Color(0xFF22B573),
    edge: Color(0xFF168A55),
    primarySoft: Color(0xFFE2F7EC),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'amber': InstitutePreset(
    primary: Color(0xFFFFB020),
    edge: Color(0xFFD98E00),
    primarySoft: Color(0xFFFFF3D6),
    onPrimary: Color(0xFF2B2633),
  ),
  'rose': InstitutePreset(
    primary: Color(0xFFE11D48),
    edge: Color(0xFFB0123A),
    primarySoft: Color(0xFFFFE4EA),
    onPrimary: Color(0xFFFFFFFF),
  ),
  'slate': InstitutePreset(
    primary: Color(0xFF475569),
    edge: Color(0xFF334155),
    primarySoft: Color(0xFFEDF0F4),
    onPrimary: Color(0xFFFFFFFF),
  ),
};

InstitutePreset presetFor(String? key) =>
    kInstitutePresets[key] ?? kInstitutePresets[kDefaultPreset]!;

MasirColors instituteColors(String? presetKey, Brightness brightness) {
  final preset = presetFor(presetKey);
  final base = brightness == Brightness.dark ? MasirColors.dark : MasirColors.light;

  if (brightness == Brightness.light) {
    return base.copyWith(
      primary: preset.primary,
      primaryEdge: preset.edge,
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
    primaryEdge: Color.lerp(preset.edge, const Color(0xFF000000), 0.1)!,
    primaryTint: soft,
    onPrimary: preset.onPrimary,
    accent: primary,
  );
}
