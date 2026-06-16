import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';

class AppStyle {
  static BoxDecoration decoration({
    double radius = 12,
    Color? color,
    Color? bgColor,
  }) => BoxDecoration(
    color: bgColor ?? Colors.transparent,
    border: Border.all(color: color ?? AppColor.border),
    borderRadius: BorderRadius.circular(radius),
  );

  AppStyle._();
}
