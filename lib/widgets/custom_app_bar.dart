import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/widgets/back_button.dart';

import 'custom_text.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Function? backAction;

  const CustomAppBar({super.key, required this.title, this.icon, this.backAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomBackButton(backAction: backAction),
        8.w,
        CustomText(title, fontWeight: FontWeight.w500),
        if (icon != null) ...[
          Spacer(),
          icon!
        ],
      ],
    );
  }
}
