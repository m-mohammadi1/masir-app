import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class AppColor {
  static Color get primary =>
      HiveService.isDarkMode ? DarkColors.primary : LightColors.primary;
  static Color get primary100 =>
      HiveService.isDarkMode ? DarkColors.primary100 : LightColors.primary100;
  static Color get primary400 =>
      HiveService.isDarkMode ? DarkColors.primary400 : LightColors.primary400;

  /// Page background (soft paper tint).
  static Color get background =>
      HiveService.isDarkMode ? DarkColors.pagePaper : LightColors.pagePaper;

  static Color get error =>
      HiveService.isDarkMode ? DarkColors.white : LightColors.white;

  /// Primary body text ("ink" on paper).
  static Color get text =>
      HiveService.isDarkMode ? DarkColors.ink : LightColors.ink;

  static Color get textGray =>
      HiveService.isDarkMode ? DarkColors.inkMuted : LightColors.inkMuted;

  static Color get textDefault =>
      HiveService.isDarkMode ? DarkColors.ink : LightColors.ink;

  static Color get text92 =>
      HiveService.isDarkMode ? DarkColors.text92 : LightColors.text92;

  /// Hairline borders on paper surfaces.
  static Color get border =>
      HiveService.isDarkMode ? DarkColors.paperEdge : LightColors.paperEdge;

  static Color get border100 =>
      HiveService.isDarkMode ? DarkColors.border100 : LightColors.border100;

  static Color get border150 =>
      HiveService.isDarkMode ? DarkColors.border150 : LightColors.border150;

  static Color get secondaryDisable => HiveService.isDarkMode
      ? DarkColors.secondaryDisable
      : LightColors.secondaryDisable;

  static Color get borderF9 =>
      HiveService.isDarkMode ? DarkColors.borderF9 : LightColors.borderF9;

  static Color get secondary =>
      HiveService.isDarkMode ? DarkColors.secondary : LightColors.secondary;

  static Color get green =>
      HiveService.isDarkMode ? DarkColors.green : LightColors.green;

  static Color get green100 =>
      HiveService.isDarkMode ? DarkColors.green100 : LightColors.green100;

  static Color get black =>
      HiveService.isDarkMode ? DarkColors.black : LightColors.black;

  /// Pure white — for text/icons on primary buttons, not page surfaces.
  static Color get white =>
      HiveService.isDarkMode ? DarkColors.white : LightColors.white;

  /// Elevated cards / sheets on the page background.
  static Color get surface =>
      HiveService.isDarkMode ? DarkColors.cardPaper : LightColors.cardPaper;

  static Color get pagePaper => background;

  static Color get paperEdge => border;

  static Color get ink => text;

  static Color get inkMuted => textGray;

  static Color get inkFaint =>
      HiveService.isDarkMode ? DarkColors.inkFaint : LightColors.inkFaint;

  static Color get locked =>
      HiveService.isDarkMode ? DarkColors.locked : LightColors.locked;

  static Color get success =>
      HiveService.isDarkMode ? DarkColors.success : LightColors.success;

  static Color get accent => primary;

  static Color get primaryTint =>
      HiveService.isDarkMode ? DarkColors.primaryTint : LightColors.primaryTint;

  static Color get trailWalked =>
      HiveService.isDarkMode ? DarkColors.trailWalked : LightColors.trailWalked;

  static Color get trailWalkedEdge => HiveService.isDarkMode
      ? DarkColors.trailWalkedEdge
      : LightColors.trailWalkedEdge;

  static Color get trailUnwalked => HiveService.isDarkMode
      ? DarkColors.trailUnwalked
      : LightColors.trailUnwalked;

  static Color get trailUnwalkedEdge => HiveService.isDarkMode
      ? DarkColors.trailUnwalkedEdge
      : LightColors.trailUnwalkedEdge;

  AppColor._();
}

class LightColors {
  static const Color primary = Color(0xFF7E42C5);
  static const Color secondary = Color(0xFF3C467B);
  static const Color primary100 = Color(0xFFF3EDFA);
  static const Color primary400 = Color(0xFF7E42C5);
  static const Color primaryTint = Color(0xFFF3EBFF);

  static const Color pagePaper = Color(0xFFF6F4EF);
  static const Color cardPaper = Color(0xFFFFFEFB);
  static const Color paperEdge = Color(0xFFE5E2D9);

  static const Color ink = Color(0xFF3A362F);
  static const Color inkMuted = Color(0xFF8B8779);
  static const Color inkFaint = Color(0xFFD2CFC4);
  static const Color locked = Color(0xFFB7B4A7);
  static const Color success = Color(0xFF2E7D4F);

  static const Color border = paperEdge;
  static const Color border100 = Color(0xFFEFEBE3);
  static const Color text = ink;
  static const Color textGray = inkMuted;
  static const Color textDefault = ink;
  static const Color text92 = Color(0xFF929292);
  static const Color border150 = Color(0xFFF0EDE6);
  static const Color secondaryDisable = Color(0xFFD3D3D3);
  static const Color green = Color(0xFF2E7D4F);
  static const Color green100 = Color(0xFFE8F3EC);

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color borderF9 = Color(0xFFF2F0EA);

  static const Color trailWalked = Color(0xFF6FAE86);
  static const Color trailWalkedEdge = Color(0xFF2E7D4F);
  static const Color trailUnwalked = Color(0xFFC3A6E6);
  static const Color trailUnwalkedEdge = Color(0xFF7E42C5);

  LightColors._();
}

class DarkColors {
  static const Color primary = Color(0xFF9B6BD4);
  static const Color primary100 = Color(0xFF2A2433);
  static const Color primary400 = Color(0xFF7E42C5);
  static const Color primaryTint = Color(0xFF3D3250);

  static const Color pagePaper = Color(0xFF1E1C18);
  static const Color cardPaper = Color(0xFF2A2722);
  static const Color paperEdge = Color(0xFF3D3930);

  static const Color ink = Color(0xFFF6F4EF);
  static const Color inkMuted = Color(0xFFB7B4A7);
  static const Color inkFaint = Color(0xFF5C574D);
  static const Color locked = Color(0xFF8A806D);
  static const Color success = Color(0xFF6FAE86);

  static const Color border = paperEdge;
  static const Color border100 = Color(0xFF333028);
  static const Color text = ink;
  static const Color textGray = inkMuted;
  static const Color textDefault = ink;
  static const Color text92 = Color(0xFF929292);
  static const Color border150 = Color(0xFF2F2C26);
  static const Color secondary = Color(0xFF9BA3C7);
  static const Color secondaryDisable = Color(0xFF555555);
  static const Color green = Color(0xFF6FAE86);
  static const Color green100 = Color(0xFF1E3328);
  static const Color borderF9 = Color(0xFF252219);

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  static const Color trailWalked = Color(0xFF6FAE86);
  static const Color trailWalkedEdge = Color(0xFF2E7D4F);
  static const Color trailUnwalked = Color(0xFF5A4578);
  static const Color trailUnwalkedEdge = Color(0xFF9B6BD4);

  DarkColors._();
}

class ConstColors {
  static const Color red = Color(0xffEB5757);

  ConstColors._();
}
