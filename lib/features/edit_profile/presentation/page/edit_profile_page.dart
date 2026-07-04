import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/edit_profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/custom_text_field.dart';

import '../../../../core/services/hive_service.dart';
import '../../../auth/domain/entities/submit_username.dart';
import '../../data/models/request_edit_profile_model.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = "/edit-profile";

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final editProfileBloc = inject<EditProfileBloc>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = HiveService.user;
    _nameController.text = user?.name ?? "";
    _phoneController.text = user?.phone ?? "";
    _usernameController.text = user?.username ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "ویرایش اطلاعات"),
          12.h,
          CustomText(
            "نام و رمز عبور خود را مدیریت کنید",
            fontSize: 13,
            color: Color(0xff6E6884),
          ),
          20.h,
          Expanded(
            child: ListView(
              children: [
                _buildProfileSection(),
                16.h,
                _buildSecuritySection(),
                40.h,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE7DEF8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.person_outline, color: Color(0xff7C3AED), size: 22),
              8.w,
              CustomText(
                "پروفایل",
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Divider(height: 30, color: Color(0xffE7DEF8)),
          CustomText(
            "نام",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff6E6884),
          ),
          8.h,
          CustomTextField(
            controller: _nameController,
            hint: "نام خود را وارد کنید",
            textDirection: TextDirection.rtl,
          ),
          16.h,
          CustomText(
            "شماره موبایل",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff6E6884),
          ),
          8.h,
          CustomTextField(
            controller: _phoneController,
            enabled: false,
            backgroundColor: Color(0xffF5F3F8),
            textDirection: TextDirection.ltr,
          ),
          16.h,
          CustomText(
            "نام کاربری",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff6E6884),
          ),
          8.h,
          CustomTextField(
            controller: _usernameController,
            hint: "نام کاربری خود را وارد کنید",
            textDirection: TextDirection.ltr,
          ),
          20.h,
          BlocBuilder<EditProfileBloc, EditProfileState>(
            bloc: editProfileBloc,
            builder: (context, state) {
              final isLoading = state.whenOrNull(loading: (isLoading) => isLoading) ?? false;
              return CustomButton(
                title: "ذخیره",
                loading: isLoading,
                onTap: () {
                  editProfileBloc.add(
                    EditProfileEvent.editProfile(
                      params: RequestEditProfileModel(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE7DEF8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline, color: Color(0xff7C3AED), size: 22),
              8.w,
              CustomText(
                "امنیت",
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Divider(height: 30, color: Color(0xffE7DEF8)),
          CustomText(
            "رمز عبور فعلی",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff6E6884),
          ),
          8.h,
          CustomTextField(
            controller: _currentPasswordController,
            isPassword: true,
            hint: "رمز عبور فعلی را وارد کنید",
          ),
          16.h,
          CustomText(
            "رمز عبور جدید",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff6E6884),
          ),
          8.h,
          CustomTextField(
            controller: _newPasswordController,
            isPassword: true,
            hint: "رمز عبور جدید را وارد کنید",
          ),
          16.h,
          CustomText(
            "تکرار رمز عبور",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff6E6884),
          ),
          8.h,
          CustomTextField(
            controller: _confirmPasswordController,
            isPassword: true,
            hint: "رمز عبور جدید را تکرار کنید",
          ),
          20.h,
          CustomButton(
            title: "ذخیره",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
