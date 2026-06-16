import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class AppColor {
  static Color get primary => HiveService.isDarkMode ? DarkColors.primary : LightColors.primary;
  static Color get primary100 => HiveService.isDarkMode ? DarkColors.primary100 : LightColors.primary100;
  static Color get primary400 => HiveService.isDarkMode ? DarkColors.primary400 : LightColors.primary400;

  static Color get background => HiveService.isDarkMode ? DarkColors.white : LightColors.white;
  static Color get error => HiveService.isDarkMode ? DarkColors.white : LightColors.white;
  static Color get text => HiveService.isDarkMode ? DarkColors.text : LightColors.text;
  static Color get textGray => HiveService.isDarkMode ? DarkColors.textGray : LightColors.textGray;
  static Color get textDefault => HiveService.isDarkMode ? DarkColors.textDefault : LightColors.textDefault;
  static Color get text92 => HiveService.isDarkMode ? DarkColors.text92 : LightColors.text92;
  static Color get border => HiveService.isDarkMode ? DarkColors.border : LightColors.border;
  static Color get border100 => HiveService.isDarkMode ? DarkColors.border100 : LightColors.border100;
  static Color get border150 => HiveService.isDarkMode ? DarkColors.border150 : LightColors.border150;
  static Color get secondaryDisable => HiveService.isDarkMode ? DarkColors.secondaryDisable : LightColors.secondaryDisable;
  static Color get borderF9 => HiveService.isDarkMode ? DarkColors.borderF9 : LightColors.borderF9;
  static Color get secondary => HiveService.isDarkMode ? DarkColors.secondary : LightColors.secondary;
  static Color get green => HiveService.isDarkMode ? DarkColors.green : LightColors.green;
  static Color get green100 => HiveService.isDarkMode ? DarkColors.green100 : LightColors.green100;

  static Color get black => HiveService.isDarkMode ? DarkColors.black : LightColors.black;
  static Color get white => HiveService.isDarkMode ? DarkColors.white : LightColors.white;

  AppColor._();
}

class LightColors {
  static const Color primary = Color(0xFF6E8CFB);
  static const Color secondary = Color(0xFF3C467B);
  static const Color primary100 = Color(0xFFFEF3EA);
  static const Color primary400 = Color(0xFFF8A054);
  static const Color border = Color(0xFFE9E9E9);
  static const Color border100 = Color(0xFFF3F3F3);
  static const Color text = Color(0xFF252525);
  static const Color textGray = Color(0xFF666666);
  static const Color textDefault = Color(0xFF1E1D1D);
  static const Color text92 = Color(0xFF929292);
  static const Color border150 = Color(0xFFF5F5F5);
  static const Color secondaryDisable = Color(0xFFD3D3D3);
  static const Color green = Color(0xFF009966);
  static const Color green100 = Color(0xFFE5F5F0);

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color borderF9 = Color(0xFFF9F9F9);

  LightColors._();
}

class DarkColors {
  static const Color primary = Color(0xFFF68829);
  static const Color primary100 = Color(0xFFFEF3EA);
  static const Color primary400 = Color(0xFFF8A054);
  static const Color border = Color(0xFFE9E9E9);
  static const Color border100 = Color(0xFFF3F3F3);
  static const Color text = Color(0xFF252525);
  static const Color textGray = Color(0xFF666666);
  static const Color textDefault = Color(0xFF1E1D1D);
  static const Color text92 = Color(0xFF929292);
  static const Color border150 = Color(0xFFF5F5F5);
  static const Color secondary = Color(0xFF003047);
  static const Color secondaryDisable = Color(0xFFD3D3D3);
  static const Color green = Color(0xFF009966);
  static const Color green100 = Color(0xFFE5F5F0);
  static const Color borderF9 = Color(0xFFF9F9F9);

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  DarkColors._();
}

class ConstColors {
  static const Color red = Color(0xffEB5757);

  ConstColors._();
}
