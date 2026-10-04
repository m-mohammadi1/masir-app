import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_outline_button.dart';
import '/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';
import '/core/theme/masir_style.dart';

class VerifyPhoneBottomSheet extends StatelessWidget {
  final String phoneNumber;

  const VerifyPhoneBottomSheet({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          8.h,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MasirRadius.chip),
              color: context.colors.text92.withValues(alpha: .1),
            ),
            height: 45,
            alignment: Alignment.center,
            child: CustomText.body("تایید شماره تلفن"),
          ),

          16.h,
          CustomText.body("این شماره درسته؟"),
          16.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText.caption(
                "کد فعال‌سازی که به شماره ",
                color: context.colors.text92,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: CustomText.caption(
                  phoneNumber,
                  color: context.colors.secondary,
                ),
              ),
              CustomText.caption(
                " ارسال شده رو وارد کن.",
                color: context.colors.text92,
              ),
            ],
          ),
          16.h,

          Row(
            children: [
              Expanded(
                child: CustomOutlineButton(
                  title: "ویرایش شماره",
                  onTap: () {
                    CustomNavigator.pop();
                  },
                  borderColor: context.colors.primary,
                  textStyle: TextStyle(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              8.w,
              Expanded(
                child: CustomButton(
                  title: "بله درسته",
                  onTap: () {
                    CustomNavigator.pop(value: true);
                  },
                ),
              ),
            ],
          ),
          46.h,
        ],
      ),
    );
  }
}
