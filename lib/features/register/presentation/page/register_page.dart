import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/auth_app_bar.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/date_picker.dart';

import '../../../../core/helper/assets.dart';
import '../../../../core/helper/custom_colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../main/presentaion/page/main_page.dart';
import '../../../profile/presentation/widgets/choose_avatar_bottom_sheet.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = "/register";

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _btdController = TextEditingController(text: "1375/01/01");

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        children: [
          AuthAppBar(title: "ثبت نام"),
          20.h,
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
                    CustomImage(
                      assets: Assets.banner,
                      radius: 90,
                      height: 60,
                      width: 60,
                      color: AppColor.primary,
                      fit: BoxFit.cover,
                    ),
                    CustomImage(assets: Assets.edit, color: AppColor.secondary),
                  ],
                ),
              ),
            ),
          ),
          16.h,
          CustomTextField(
            controller: _nameController,
            labelText: "نام",
            hint: "نام خود را وارد کنید",
          ),
          8.h,
          CustomTextField(
            controller: _lastNameController,
            labelText: "نام خانوادگی",
            hint: "نام خانوادگی خود را وارد کنید",
          ),
          8.h,

          CustomTextField(
            controller: _btdController,
            enabled: false,
            onTap: () {
              CustomDatePicker.show(
                context: context,
                onChange: (v) {
                  setState(() {
                    _btdController.text = v;
                  });
                },
                initialValue: _btdController.text,
              );
            },
            labelText: "تاریخ تولد",
            hint: "1380/05/17",
          ),
          8.h,
          CustomTextField(
            controller: _phoneNumberController,
            enabled: false,
            labelText: "شماره تلفن",
            hint: "09135280019",
          ),
          20.h,
          CustomButton(title: "ثبت نام", onTap: () {
            CustomNavigator.go(MainPage.routeName);
          },),
        ],
      ),
    );
  }
}
