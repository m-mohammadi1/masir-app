import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/custom_text.dart';
import 'custom_button.dart';
import 'custom_outline_button.dart';
import '/core/theme/theme_context.dart';
import '/core/theme/masir_style.dart';

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
              borderRadius: BorderRadius.circular(MasirRadius.row),
              color: context.colors.primaryTint,
            ),
            child: Center(
              child: CustomText.bodyStrong(
                "تاییدیه",
                color: context.colors.primary,
              ),
            ),
          ),
          16.h,
          CustomText.headline(text),
          8.h,
          CustomText(
            description ?? "اگه الان خارج بشی، تغییراتت ذخیره نمی‌شه.",
            color: context.colors.inkMuted,
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomOutlineButton(
                  title: "انصراف",
                  onTap: () {
                    CustomNavigator.pop();
                  },
                ),
              ),
              8.w,
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
