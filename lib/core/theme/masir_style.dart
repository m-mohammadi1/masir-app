import 'package:flutter/material.dart';

import '/core/theme/masir_colors.dart';

/// Font family registered in pubspec.yaml (IRANSansX FaNum at real weights).
const String kMasirFont = 'Masir';

/// Type scale: four sizes, three weights (400 body, 600 label, 800 heading).
class MasirText {
  MasirText._();

  static const double displaySize = 28;
  static const double titleSize = 20;
  static const double bodySize = 16;
  static const double captionSize = 13;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight label = FontWeight.w600;
  static const FontWeight heavy = FontWeight.w800;

  static TextStyle display(Color color) => TextStyle(
    fontFamily: kMasirFont,
    fontSize: displaySize,
    fontWeight: heavy,
    height: 1.3,
    color: color,
  );

  static TextStyle title(Color color) => TextStyle(
    fontFamily: kMasirFont,
    fontSize: titleSize,
    fontWeight: heavy,
    height: 1.35,
    color: color,
  );

  static TextStyle body(Color color, {FontWeight weight = regular}) => TextStyle(
    fontFamily: kMasirFont,
    fontSize: bodySize,
    fontWeight: weight,
    height: 1.5,
    color: color,
  );

  static TextStyle caption(Color color, {FontWeight weight = regular}) =>
      TextStyle(
        fontFamily: kMasirFont,
        fontSize: captionSize,
        fontWeight: weight,
        height: 1.45,
        color: color,
      );
}

/// Radius scale.
class MasirRadius {
  MasirRadius._();

  static const double chip = 12;
  static const double card = 20;
  static const double sheet = 24;
  static const double pill = 999;
}

/// Depth is a 2px border plus a solid 4px lip, not a blurry shadow.
class Chunky {
  Chunky._();

  static const double lip = 4;
  static const double border = 2;

  /// Decoration for a card-like surface resting on [lipColor].
  static BoxDecoration surface(
    MasirColors c, {
    Color? fill,
    Color? borderColor,
    Color? lipColor,
    double radius = MasirRadius.card,
    bool pressed = false,
  }) {
    final edge = borderColor ?? c.border;
    final bottom = lipColor ?? c.lip;
    return BoxDecoration(
      color: fill ?? c.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border(
        top: BorderSide(color: edge, width: border),
        left: BorderSide(color: edge, width: border),
        right: BorderSide(color: edge, width: border),
        bottom: BorderSide(color: bottom, width: pressed ? border : lip),
      ),
    );
  }

  /// Decoration for a solid coloured control (button) with an edge lip.
  static BoxDecoration solid({
    required Color fill,
    required Color edge,
    double radius = 16,
    bool pressed = false,
  }) {
    return BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(radius),
      border: Border(
        bottom: BorderSide(color: edge, width: pressed ? 0 : lip),
      ),
    );
  }
}
