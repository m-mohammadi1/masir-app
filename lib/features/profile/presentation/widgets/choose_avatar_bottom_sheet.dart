import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/base_modal.dart';
import 'package:mohammad/widgets/custom_button.dart';

import '../../../../core/helper/assets.dart';
import '../../../../core/helper/custom_colors.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/dynamic_height_grid_view.dart';

class ChooseAvatarBottomSheet {
  static void show(BuildContext context) {
    showCustomModal(
      context: context,
      child: _ChooseAvatarBottomSheet(),
      isScrollControlled: true,
    );
  }
}

class _ChooseAvatarBottomSheet extends StatelessWidget {
  const _ChooseAvatarBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          "انتخاب عکس پروفایل",
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DynamicHeightGridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            itemCount: 6,
            padding: EdgeInsets.only(top: 20),
            builder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.border150,
                  border: Border.all(color: AppColor.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomImage(
                        assets: Assets.banner,
                        height: 100,
                        radius: 8,
                      ),
                    ),
                    8.h,
                    CustomText(
                      "آواتار".tr,
                      fontSize: 14,
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        20.h,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomButton(title: "انتخاب و ذخیره"),
        ),
        20.h,
      ],
    );
  }
}
