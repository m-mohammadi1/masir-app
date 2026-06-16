import 'package:flutter/material.dart';
import '/core/helper/helper_extension.dart';
import '/widgets/custom_text.dart';

class PriceWidget extends StatelessWidget {
  final num? price;
  final String? priceFormatted;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const PriceWidget({
    super.key,
    this.price,
    this.priceFormatted,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: CustomText(priceFormatted ??"${price.toPrice} تومان", fontSize: fontSize, color: color , fontWeight: fontWeight,));
  }
}
