import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '../core/helper/custom_colors.dart';
import 'custom_text.dart';

class TitleModal extends StatelessWidget {
  final String txt;
  const TitleModal({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    return          Container(
      height: 45,
      width: context.appSize.width,
      decoration: BoxDecoration(
        color: AppColor.borderF9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: CustomText(txt)),
    );
  }
}
