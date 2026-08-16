import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_outline_button.dart';
import '/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

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
              borderRadius: BorderRadius.circular(8),
              color: context.colors.text92.withValues(alpha: .1),
            ),
            height: 45,
            alignment: Alignment.center,
            child: CustomText(
              "تایید شماره تلفن",
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          16.h,
          CustomText(
            "این شماره درسته؟",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          16.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                "کد فعال‌سازی که به شماره ",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.colors.text92,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: CustomText(
                  phoneNumber,
                  fontSize: 12,
                  color: context.colors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomText(
                " ارسال شده را وارد کنید.",
                fontSize: 12,
                color: context.colors.text92,
                fontWeight: FontWeight.w500,
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
              10.w,
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
