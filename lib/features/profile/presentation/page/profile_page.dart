import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/profile/presentation/widgets/choose_avatar_bottom_sheet.dart';
import 'package:mohammad/widgets/base_modal.dart';

import '../../../../core/helper/assets.dart';
import '../../../../core/helper/custom_colors.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/exit_modal.dart';
import '../../../about_us/presentation/page/about_us_page.dart';
import '../../../auth/presentation/page/auth_screen.dart';
import '../../../edit_profile/presentation/page/edit_profile_page.dart';
import '../widgets/contact_us_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final List<_MenuModel> _menus = [
    _MenuModel(
      title: "ویرایش اطلاعات",
      icon: Assets.mediumEdit,
      onTap: () => CustomNavigator.pushNamed(EditProfilePage.routeName),
    ),
    _MenuModel(
      title: "درباره ما",
      icon: Assets.aboutUs,
      onTap: () => CustomNavigator.pushNamed(AboutUsPage.routeName),
    ),
    _MenuModel(
      title: "ارتباط با ما",
      icon: Assets.aboutUs,
      onTap: () =>
          showCustomModal(context: context, child: ContactUsBottomSheet()),
    ),
    _MenuModel(
      title: "خروج از حساب كاربرى",
      icon: Assets.exit,
      onTap: () => showCustomModal(
        context: context,
        scrollControlDisabledMaxHeightRatio: .4,
        callBack: (_) {},
        child: ExitModal(
          text: "میخواهید از حساب کاربری خود خارج شوید؟",
          exitAction: () {
            HiveService.logout();
            CustomNavigator.go(AuthScreen.routeName);
          },
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          60.h,
          Center(
            child: OnClick(
              onTap: () {
                ChooseAvatarBottomSheet.show(context);
              },
              child: SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, right: 5),
                      child: CustomImage(
                        assets: Assets.banner,
                        radius: 90,
                        height: 60,
                        width: 60,
                        color: AppColor.primary,
                        fit: BoxFit.cover,
                      ),
                    ),
                    CustomImage(assets: Assets.edit, color: AppColor.secondary),
                  ],
                ),
              ),
            ),
          ),
          8.h,
          CustomText("مسعود رشیدی زاده"),

          // CustomTextField(controller: _firstNameController, labelText: "نام"),
          20.h,

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.borderF9.withValues(alpha: .8),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: ListView.builder(
                itemCount: _menus.length,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                itemBuilder: (context, index) {
                  return OnClick(
                    onTap: () => _menus[index].onTap(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          8.w,
                          CustomImage(
                            assets: _menus[index].icon,
                            color: AppColor.secondary,
                            width: 24,
                            height: 24,
                          ),
                          8.w,
                          CustomText(
                            _menus[index].title,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuModel {
  final String title, icon;
  final Function onTap;

  _MenuModel({required this.title, required this.icon, required this.onTap});
}
