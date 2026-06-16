import '/core/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'custom_colors.dart';

ColorScheme get _scheme {
  if (HiveService.isDarkMode) {
    return ColorScheme.dark(
      primary: AppColor.primary,
      secondary: AppColor.white,
      brightness: Brightness.dark,
    );
  }
  return ColorScheme.light(
    primary: AppColor.primary,
    secondary: AppColor.white,
    brightness: Brightness.light,
  );
}

final ThemeData dark = ThemeData(
  fontFamily: 'YekanBakh',
  scaffoldBackgroundColor: AppColor.white,
  colorScheme: _scheme,
  primaryColor: AppColor.primary,
  // dividerTheme: DividerThemeData(color:AppColor.border),
  // secondaryHeaderColor: AppColor.secondary,
  // indicatorColor: AppColor.border,
  useMaterial3: true,
);

final ThemeData light = ThemeData(
  fontFamily: 'YekanBakh',
  scaffoldBackgroundColor: AppColor.white,
  colorScheme: _scheme,
  primaryColor: AppColor.primary,
  // dividerTheme: DividerThemeData(color:AppColor.border),
  // secondaryHeaderColor: AppColor.secondary,
  // indicatorColor: AppColor.border,
  useMaterial3: true,
);
