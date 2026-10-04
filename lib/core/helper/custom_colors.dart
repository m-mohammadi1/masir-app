import 'package:flutter/material.dart';

/// Playful Masir palette.
///
/// 60% warm-white base, 30% ink, 10% brand violet. Signal colours (green, sun,
/// coral) are reserved for meaningful moments. Every strong colour has an
/// "edge" shade used for the solid bottom lip of chunky buttons and cards.
class LightColors {
  // Brand
  static const Color primary = Color(0xFF7E42C5);
  static const Color primaryEdge = Color(0xFF5E2D9A);
  static const Color secondary = Color(0xFF6F6A7C);
  static const Color primary100 = Color(0xFFF3EBFF);
  static const Color primary400 = Color(0xFF7E42C5);
  static const Color primaryTint = Color(0xFFF3EBFF);

  // Base
  static const Color pagePaper = Color(0xFFFFFCF5);
  static const Color cardPaper = Color(0xFFFFFFFF);
  static const Color paperEdge = Color(0xFFEFE8DA);
  static const Color lip = Color(0xFFE3D9C4);

  // Ink
  static const Color ink = Color(0xFF2B2633);
  static const Color inkMuted = Color(0xFF6F6A7C);
  static const Color inkFaint = Color(0xFFD9D3E0);
  static const Color locked = Color(0xFFB9B3C4);

  // Signals
  static const Color success = Color(0xFF3DBE6E);
  static const Color successEdge = Color(0xFF2A9553);
  static const Color green = Color(0xFF3DBE6E);
  static const Color green100 = Color(0xFFE4F7EB);
  static const Color sun = Color(0xFFFFB020);
  static const Color sunEdge = Color(0xFFD98E00);
  static const Color sunSoft = Color(0xFFFFF3D6);
  static const Color coral = Color(0xFFFF5A5F);
  static const Color coralEdge = Color(0xFFD13C41);
  static const Color coralSoft = Color(0xFFFFE5E6);

  // Legacy aliases kept so existing call sites keep compiling.
  static const Color border = paperEdge;
  static const Color border100 = Color(0xFFF4EEE1);
  static const Color text = ink;
  static const Color textGray = inkMuted;
  static const Color textDefault = ink;
  static const Color text92 = Color(0xFF929292);
  static const Color border150 = Color(0xFFF4EEE1);
  static const Color secondaryDisable = Color(0xFFD9D3E0);
  static const Color borderF9 = Color(0xFFF6F0E4);

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  static const Color trailWalked = Color(0xFF3DBE6E);
  static const Color trailWalkedEdge = Color(0xFF2A9553);
  static const Color trailUnwalked = Color(0xFFD9C4F2);
  static const Color trailUnwalkedEdge = Color(0xFF7E42C5);

  LightColors._();
}

class DarkColors {
  // Brand
  static const Color primary = Color(0xFF9B6BD4);
  static const Color primaryEdge = Color(0xFF6E43A3);
  static const Color secondary = Color(0xFFB4AEC2);
  static const Color primary100 = Color(0xFF2E2540);
  static const Color primary400 = Color(0xFF7E42C5);
  static const Color primaryTint = Color(0xFF332A47);

  // Base
  static const Color pagePaper = Color(0xFF17141D);
  static const Color cardPaper = Color(0xFF221E2B);
  static const Color paperEdge = Color(0xFF39334A);
  static const Color lip = Color(0xFF2C2739);

  // Ink
  static const Color ink = Color(0xFFF7F3FF);
  static const Color inkMuted = Color(0xFFB4AEC2);
  static const Color inkFaint = Color(0xFF5A5469);
  static const Color locked = Color(0xFF7D7790);

  // Signals
  static const Color success = Color(0xFF52D487);
  static const Color successEdge = Color(0xFF2F9B5C);
  static const Color green = Color(0xFF52D487);
  static const Color green100 = Color(0xFF1B3327);
  static const Color sun = Color(0xFFFFC04D);
  static const Color sunEdge = Color(0xFFD98E00);
  static const Color sunSoft = Color(0xFF3A2E14);
  static const Color coral = Color(0xFFFF7478);
  static const Color coralEdge = Color(0xFFD13C41);
  static const Color coralSoft = Color(0xFF3B1F22);

  // Legacy aliases
  static const Color border = paperEdge;
  static const Color border100 = Color(0xFF2E293C);
  static const Color text = ink;
  static const Color textGray = inkMuted;
  static const Color textDefault = ink;
  static const Color text92 = Color(0xFF929292);
  static const Color border150 = Color(0xFF2E293C);
  static const Color secondaryDisable = Color(0xFF555063);
  static const Color borderF9 = Color(0xFF1F1B28);

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  static const Color trailWalked = Color(0xFF52D487);
  static const Color trailWalkedEdge = Color(0xFF2F9B5C);
  static const Color trailUnwalked = Color(0xFF5A4578);
  static const Color trailUnwalkedEdge = Color(0xFF9B6BD4);

  DarkColors._();
}

class ConstColors {
  static const Color red = Color(0xffFF5A5F);

  ConstColors._();
}
