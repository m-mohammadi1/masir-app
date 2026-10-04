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

  /// Confirm button colour; red unless the action is harmless.
  final Color? confirmColor;

  const ExitModal({
    super.key,
    required this.text,
    this.exitAction,
    this.description,
    this.deleteText,
    this.confirmColor,
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
                "یه لحظه!",
                color: context.colors.primary,
              ),
            ),
          ),
          16.h,
          CustomText.headline(text),
          8.h,
          CustomText(
            description ?? "اگه الان بری، تغییراتت ذخیره نمی‌شه.",
            color: context.colors.inkMuted,
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomOutlineButton(
                  title: "نه، بمونم",
                  onTap: () {
                    CustomNavigator.pop();
                  },
                ),
              ),
              8.w,
              Expanded(
                child: CustomButton(
                  title: deleteText ?? "آره، برو",
                  onTap: () {
                    if (exitAction != null) {
                      exitAction!();
                    } else {
                      CustomNavigator.pop();
                      CustomNavigator.pop();
                    }
                  },
                  backgroundColor: confirmColor ?? context.colors.error,
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
