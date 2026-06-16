import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/assets.dart';
import '/core/helper/custom_colors.dart';

class CustomBackButton extends StatelessWidget {
  final Function? backAction;

  const CustomBackButton({super.key, this.backAction});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: OnClick(
        onTap: () {
          if (backAction != null) {
            backAction!();
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: AppColor.text92.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: CustomImage(assets: Assets.arrowBack),
          ),
        ),
      ),
    );
  }
}
