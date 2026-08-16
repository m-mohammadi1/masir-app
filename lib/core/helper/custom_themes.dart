import 'package:flutter/material.dart';
import '/core/theme/masir_colors.dart';

ThemeData _buildTheme(Brightness brightness) {
  final colors =
      brightness == Brightness.dark ? MasirColors.dark : MasirColors.light;
  final scheme = brightness == Brightness.dark
      ? ColorScheme.dark(
          primary: colors.primary,
          secondary: colors.secondary,
          surface: colors.surface,
          onSurface: colors.ink,
          brightness: Brightness.dark,
        )
      : ColorScheme.light(
          primary: colors.primary,
          secondary: colors.secondary,
          surface: colors.surface,
          onSurface: colors.ink,
          brightness: Brightness.light,
        );

  return ThemeData(
    fontFamily: 'YekanBakh',
    brightness: brightness,
    scaffoldBackgroundColor: colors.background,
    colorScheme: scheme,
    primaryColor: colors.primary,
    cardColor: colors.surface,
    dividerColor: colors.border,
    dividerTheme: DividerThemeData(color: colors.border, thickness: 1),
    useMaterial3: true,
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.secondaryDisable),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: colors.surface,
        foregroundColor: colors.ink,
        elevation: 1.5,
        shadowColor: colors.ink.withValues(alpha: 0.16),
        side: BorderSide(color: colors.border, width: 1.1),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.white,
        elevation: 3,
        shadowColor: colors.primary.withValues(alpha: 0.35),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}

final ThemeData dark = _buildTheme(Brightness.dark);
final ThemeData light = _buildTheme(Brightness.light);
