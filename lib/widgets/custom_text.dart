import 'package:flutter/material.dart';
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
            fontFamily: true ? "IRANSans": fontFamily??( (fontWeight?.value ?? 400) >= 600
                ? "Pinar-Bold"
                : (fontWeight?.value ?? 400) == 500
                ? "Pinar-Medium"
                : "Pinar"),
            color: color ?? context.colors.text,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
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
    fontFamily: true
        ? "IRANSans"
        : (fontWeight?.value ?? 400) >= 600
        ? "Pinar-Bold"
        : (fontWeight?.value ?? 400) == 500
        ? "Pinar-Medium"
        : "Pinar",
    color: color ?? context.colors.text,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}
