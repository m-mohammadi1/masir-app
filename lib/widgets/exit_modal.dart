import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/custom_text.dart';
import 'custom_button.dart';
import 'custom_outline_button.dart';
import '/core/theme/theme_context.dart';

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
              borderRadius: BorderRadius.circular(14),
              color: context.colors.primaryTint,
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.25),
                width: 1.1,
              ),
            ),
            child: Center(
              child: CustomText(
                "تاییدیه",
                fontWeight: FontWeight.w500,
                color: context.colors.primary,
              ),
            ),
          ),
          16.h,
          CustomText(text, fontSize: 16, fontWeight: FontWeight.w500),
          8.h,
          CustomText(
            description ?? "با بستن مرحله، تغییرات شما ذخیره نخواهد شد.",
            color: context.colors.text92,
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomOutlineButton(
                  title: "انصراف",
                  borderColor: context.colors.error,
                  onTap: () {
                    CustomNavigator.pop();
                  },
                  textStyle: TextStyle(color: context.colors.error),
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
                  backgroundColor: context.colors.error,
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
