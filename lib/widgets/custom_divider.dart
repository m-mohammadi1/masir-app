import 'package:easy_helper/easy_helper.dart';

import '/core/helper/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;
  final double? height;
  final Color? borderColor;

  const CustomDivider({
    super.key,
    this.indent,
    this.endIndent,
    this.borderColor,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.appSize.width,
      height: height,
      color: borderColor ?? AppColor.border,
      margin: EdgeInsetsDirectional.only(
        start: indent ?? 0,
        end: endIndent ?? 0,
      ),
    );
  }
}
