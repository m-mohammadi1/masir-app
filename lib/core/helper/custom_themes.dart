import '/core/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'custom_colors.dart';

ColorScheme get _scheme {
  if (HiveService.isDarkMode) {
    return ColorScheme.dark(
      primary: AppColor.primary,
      secondary: AppColor.secondary,
      surface: AppColor.surface,
      onSurface: AppColor.ink,
      brightness: Brightness.dark,
    );
  }
  return ColorScheme.light(
    primary: AppColor.primary,
    secondary: AppColor.secondary,
    surface: AppColor.surface,
    onSurface: AppColor.ink,
    brightness: Brightness.light,
  );
}

ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    fontFamily: 'YekanBakh',
    brightness: brightness,
    scaffoldBackgroundColor: AppColor.background,
    colorScheme: _scheme,
    primaryColor: AppColor.primary,
    cardColor: AppColor.surface,
    dividerColor: AppColor.border,
    dividerTheme: DividerThemeData(color: AppColor.border, thickness: 1),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.background,
      foregroundColor: AppColor.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColor.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.primary, width: 1.5),
      ),
    ),
  );
}

final ThemeData dark = _buildTheme(Brightness.dark);
final ThemeData light = _buildTheme(Brightness.light);
