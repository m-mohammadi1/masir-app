import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/assets.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/modal_title.dart';
import '/core/theme/theme_context.dart';

class ContactUsBottomSheet extends StatelessWidget {
  const ContactUsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleModal(txt: "ارتباط با ما"),
        12.h,

        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0088CC).withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomImage(assets: Assets.telegram, width: 50, height: 50),
                8.w,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText("پیام در تلگرام", fontWeight: FontWeight.w500),
                    4.h,
                    CustomText(
                      "گفت‌وگوی آسان و امن با پشتیبانی آنلاین",
                      fontSize: 11,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: context.colors.green.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomImage(assets: Assets.whatsapp, width: 50, height: 50),
                8.w,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText("پیام در واتساپ", fontWeight: FontWeight.w500),
                    4.h,
                    CustomText(
                      "گفت‌وگوی آسان و امن با پشتیبانی آنلاین",
                      fontSize: 11,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50).withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomImage(assets: Assets.phone, width: 50, height: 50),
                8.w,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText("تماس مستقیم", fontWeight: FontWeight.w500),
                    4.h,
                    CustomText(
                      "صحبت برای مشاوره و دریافت اطلاعات",
                      fontSize: 11,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        32.h,
      ],
    );
  }
}
