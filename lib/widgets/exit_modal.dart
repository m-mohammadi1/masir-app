import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/helper/custom_colors.dart';
import '../../../../widgets/custom_text.dart';
import 'custom_button.dart';
import 'custom_outline_button.dart';

class ExitModal extends StatelessWidget {
  final String text;
  final String? description;
  final String? deleteText;
  final Function? exitAction;

  const ExitModal({
    super.key,
    required this.text,
    this.exitAction,
    this.description,
    this.deleteText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          8.h,
          Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.borderF9,
            ),
            child: Center(
              child: CustomText("تاییدیه", fontWeight: FontWeight.w500),
            ),
          ),
          16.h,
          CustomText(text, fontSize: 16, fontWeight: FontWeight.w500),
          8.h,
          CustomText(
            description ?? "با بستن مرحله، تغییرات شما ذخیره نخواهد شد.",
            color: AppColor.text92,
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomOutlineButton(
                  title: "انصراف",
                  borderColor: ConstColors.red,
                  onTap: () {
                    CustomNavigator.pop();
                  },
                  textStyle: TextStyle(color: ConstColors.red),
                ),
              ),
              10.w,
              Expanded(
                child: CustomButton(
                  title: deleteText ?? "خروج",
                  onTap: () {
                    if (exitAction != null) {
                      exitAction!();
                    } else {
                      CustomNavigator.pop();
                      CustomNavigator.pop();
                    }
                  },
                  backgroundColor: ConstColors.red,
                ),
              ),
            ],
          ),
          16.h,
        ],
      ),
    );
  }
}
