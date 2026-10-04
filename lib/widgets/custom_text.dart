import 'package:flutter/material.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLines;
  final TextStyle? style;

  const CustomText(
    this.text, {
    super.key,
    this.color,
    this.fontSize = 14,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      maxLines: maxLines,
      textAlign: textAlign,
      style:
          style ??
          TextStyle(
            fontFamily: fontFamily ?? kMasirFont,
            color: color ?? context.colors.text,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
    );
  }
}

/// Semantic variants of [CustomText] using the playful type scale.
class MasirTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double size;

  const MasirTitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.size = MasirText.titleSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

extension TR on String {
  String get tr {
    return this;
  }
}

TextStyle customTextStyle(
  BuildContext context, {
  double? fontSize,
  FontWeight? fontWeight,
  String? fontFamily,
  Color? color,
}) {
  return TextStyle(
    fontFamily: fontFamily ?? kMasirFont,
    color: color ?? context.colors.text,
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.w400,
  );
}
