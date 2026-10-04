import 'package:flutter/material.dart';

import '/core/theme/masir_colors.dart';

/// Font family registered in pubspec.yaml (IRANSansX FaNum at real weights).
const String kMasirFont = 'Masir';

/// Type roles. Screens never use raw font sizes; they pick a role.
///
/// | role       | size / weight |
/// |------------|---------------|
/// | display    | 28 / 800      |
/// | title      | 20 / 800      |
/// | headline   | 17 / 800      |
/// | body       | 15 / 500      |
/// | bodyStrong | 15 / 700      |
/// | caption    | 13 / 600      |
/// | micro      | 11 / 800      |
class MasirText {
  MasirText._();

  static const double displaySize = 28;
  static const double titleSize = 20;
  static const double headlineSize = 17;
  static const double bodySize = 15;
  static const double captionSize = 13;
  static const double microSize = 11;

  static const FontWeight regular = FontWeight.w500;
  static const FontWeight label = FontWeight.w600;
  static const FontWeight strong = FontWeight.w700;
  static const FontWeight heavy = FontWeight.w800;

  static TextStyle _style(
    Color color,
    double size,
    FontWeight weight,
    double height,
  ) => TextStyle(
    fontFamily: kMasirFont,
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
  );

  static TextStyle display(Color color) =>
      _style(color, displaySize, heavy, 1.3);

  static TextStyle title(Color color) => _style(color, titleSize, heavy, 1.35);

  static TextStyle headline(Color color) =>
      _style(color, headlineSize, heavy, 1.4);

  static TextStyle body(Color color, {FontWeight weight = regular}) =>
      _style(color, bodySize, weight, 1.5);

  static TextStyle bodyStrong(Color color) =>
      _style(color, bodySize, strong, 1.5);

  static TextStyle caption(Color color, {FontWeight weight = label}) =>
      _style(color, captionSize, weight, 1.45);

  static TextStyle micro(Color color) => _style(color, microSize, heavy, 1.3);
}

/// Spacing scale and the single horizontal page gutter.
class MasirSpace {
  MasirSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal gutter used by every page.
  static const double gutter = 20;

  /// Space between sections on a page.
  static const double section = 24;

  /// Space between a section header and its content.
  static const double inSection = 12;

  /// Padding inside cards.
  static const double card = 16;

  static const EdgeInsets pageH = EdgeInsets.symmetric(horizontal: gutter);
}

/// Icon sizes.
class MasirIconSize {
  MasirIconSize._();

  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
}

/// Radius roles: chip 12, row 16, card 20, hero/sheet 24, pill for
/// buttons and badges.
class MasirRadius {
  MasirRadius._();

  static const double chip = 12;
  static const double row = 16;
  static const double card = 20;
  static const double sheet = 24;
  static const double hero = 24;
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
    double radius = MasirRadius.row,
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
