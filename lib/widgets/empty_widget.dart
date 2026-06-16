import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';
import '/widgets/custom_text.dart';

class EmptyWidget extends StatelessWidget {
  final String img, text, description;

  const EmptyWidget({
    super.key,
    required this.img,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImage(assets: "assets/empty/$img.svg"),
        16.h,
        CustomText(text, fontWeight: FontWeight.w500),
        4.h,
        CustomText(description, fontSize: 12, color: AppColor.text92),
      ],
    );
  }

}
