import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/base_modal.dart';
import 'package:mohammad/widgets/custom_button.dart';

import '../../../../core/helper/assets.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/dynamic_height_grid_view.dart';
import '/core/theme/theme_context.dart';
import '/core/theme/masir_style.dart';

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
        CustomText.headline("انتخاب عکس پروفایل"),
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
                  color: context.colors.border150,
                  border: Border.all(color: context.colors.border),
                  borderRadius: BorderRadius.circular(MasirRadius.row),
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
                        radius: MasirRadius.chip,
                      ),
                    ),
                    8.h,
                    CustomText.body(
                      "آواتار".tr,
                      color: context.colors.secondary,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        16.h,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomButton(title: "انتخاب و ذخیره"),
        ),
        16.h,
      ],
    );
  }
}
