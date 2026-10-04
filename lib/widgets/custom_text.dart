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
    this.fontSize = MasirText.bodySize,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.style,
  });

  /// Role constructors. Prefer these over raw [fontSize] on screens.
  const CustomText.display(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : fontSize = MasirText.displaySize,
       fontWeight = MasirText.heavy,
       fontFamily = null,
       style = null;

  const CustomText.title(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : fontSize = MasirText.titleSize,
       fontWeight = MasirText.heavy,
       fontFamily = null,
       style = null;

  const CustomText.headline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : fontSize = MasirText.headlineSize,
       fontWeight = MasirText.heavy,
       fontFamily = null,
       style = null;

  const CustomText.body(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : fontSize = MasirText.bodySize,
       fontWeight = MasirText.regular,
       fontFamily = null,
       style = null;

  const CustomText.bodyStrong(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : fontSize = MasirText.bodySize,
       fontWeight = MasirText.strong,
       fontFamily = null,
       style = null;

  const CustomText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    FontWeight? weight,
  }) : fontSize = MasirText.captionSize,
       fontWeight = weight ?? MasirText.label,
       fontFamily = null,
       style = null;

  const CustomText.micro(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : fontSize = MasirText.microSize,
       fontWeight = MasirText.heavy,
       fontFamily = null,
       style = null;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      textAlign: textAlign,
      style:
          style ??
          TextStyle(
            fontFamily: fontFamily ?? kMasirFont,
            color: color ?? context.colors.text,
            fontSize: fontSize,
            fontWeight: fontWeight ?? MasirText.regular,
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
    fontWeight: fontWeight ?? MasirText.regular,
  );
}
