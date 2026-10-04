import 'package:flutter/material.dart';
import '/core/helper/jalali_format.dart';
import '/widgets/custom_text.dart';

/// A price in Persian digits with thousands separators, e.g. `۴۵۰٬۰۰۰ تومان`.
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
    return CustomText(
      priceFormatted ?? formatPrice(price ?? 0, unit: 'تومان'),
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
