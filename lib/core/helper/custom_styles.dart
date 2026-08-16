import 'package:flutter/material.dart';
import '/core/theme/masir_colors.dart';

class AppStyle {
  static BoxDecoration decoration({
    double radius = 12,
    Color? color,
    Color? bgColor,
    MasirColors? colors,
  }) => BoxDecoration(
    color: bgColor ?? Colors.transparent,
    border: Border.all(color: color ?? colors?.border ?? MasirColors.light.border),
    borderRadius: BorderRadius.circular(radius),
  );

  AppStyle._();
}
