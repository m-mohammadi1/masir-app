import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import '/core/theme/masir_colors.dart';
import '/core/theme/masir_style.dart';

ThemeData _buildTheme(Brightness brightness) {
  final colors = brightness == Brightness.dark
      ? MasirColors.dark
      : MasirColors.light;
  final scheme = brightness == Brightness.dark
      ? ColorScheme.dark(
          primary: colors.primary,
          secondary: colors.secondary,
          surface: colors.surface,
          onSurface: colors.ink,
          error: colors.coral,
          brightness: Brightness.dark,
        )
      : ColorScheme.light(
          primary: colors.primary,
          secondary: colors.secondary,
          surface: colors.surface,
          onSurface: colors.ink,
          error: colors.coral,
          brightness: Brightness.light,
        );

  OutlineInputBorder inputBorder(Color color, [double width = 2]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(MasirRadius.row),
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    fontFamily: kMasirFont,
    brightness: brightness,
    scaffoldBackgroundColor: colors.background,
    colorScheme: scheme,
    primaryColor: colors.primary,
    cardColor: colors.surface,
    dividerColor: colors.border,
    dividerTheme: DividerThemeData(color: colors.border, thickness: 2),
    useMaterial3: true,
    extensions: [colors],
    splashFactory: NoSplash.splashFactory,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      },
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MasirRadius.sheet),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MasirRadius.sheet),
        side: BorderSide(color: colors.border, width: 2),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      border: inputBorder(colors.border),
      enabledBorder: inputBorder(colors.border),
      focusedBorder: inputBorder(colors.primary),
      errorBorder: inputBorder(colors.coral),
      focusedErrorBorder: inputBorder(colors.coral),
      disabledBorder: inputBorder(colors.border100),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: colors.surface,
        foregroundColor: colors.ink,
        elevation: 0,
        side: BorderSide(color: colors.border, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: kMasirFont,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MasirRadius.row),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: kMasirFont,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MasirRadius.row),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: const TextStyle(
          fontFamily: kMasirFont,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MasirRadius.row),
        ),
      ),
    ),
  );
}

final ThemeData dark = _buildTheme(Brightness.dark);
final ThemeData light = _buildTheme(Brightness.light);
