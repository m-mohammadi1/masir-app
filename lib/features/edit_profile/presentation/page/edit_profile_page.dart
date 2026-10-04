import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/edit_profile/presentation/bloc/edit_password/edit_password_bloc.dart';
import 'package:mohammad/features/edit_profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/custom_text_field.dart';
import 'package:mohammad/widgets/masir_card.dart';
import 'package:mohammad/widgets/masir_page.dart';

import '../../../../core/services/hive_service.dart';
import '../../../auth/domain/entities/submit_username.dart';
import '../../data/models/request_edit_password_model.dart';
import '../../data/models/request_edit_profile_model.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = "/edit-profile";

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final editProfileBloc = inject<EditProfileBloc>();
  final editPasswordBloc = inject<EditPasswordBloc>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  static const int _minPasswordLength = 8;

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

  String? _validatePasswordFields() {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty) {
      return "رمز عبور فعلی‌ت رو وارد کن";
    }
    if (newPassword.isEmpty) {
      return "رمز عبور جدید رو وارد کن";
    }
    if (newPassword.length < _minPasswordLength) {
      return "رمز جدید باید حداقل $_minPasswordLength کاراکتر باشه";
    }
    if (confirmPassword.isEmpty) {
      return "تکرار رمز عبور رو وارد کن";
    }
    if (newPassword != confirmPassword) {
      return "رمز جدید و تکرارش یکی نیست";
    }
    if (currentPassword == newPassword) {
      return "رمز جدید باید با رمز فعلی فرق داشته باشه";
    }
    return null;
  }

  void _onChangePassword() {
    final error = _validatePasswordFields();
    if (error != null) {
      CustomToast.toast(context, error);
      return;
    }

    editPasswordBloc.add(
      EditPasswordEvent.editPassword(
        params: RequestEditPasswordModel(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      ),
    );
  }

  void _clearPasswordFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MasirPage.detail(
      title: 'ویرایش اطلاعات',
      children: [
        CustomText.caption(
          'اسم و رمزت رو اینجا درست کن',
          color: context.colors.inkMuted,
        ),
        const SizedBox(height: MasirSpace.xl),
        _buildProfileSection(),
        const SizedBox(height: MasirSpace.lg),
        _buildSecuritySection(),
      ],
    );
  }

  Widget _buildProfileSection() {
    return MasirCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.person_rounded,
                color: context.colors.primary,
                size: 22,
              ),
              8.w,
              CustomText.headline("پروفایل"),
            ],
          ),
          Divider(height: 30, color: context.colors.border),
          CustomText.caption("نام", color: context.colors.inkMuted),
          8.h,
          CustomTextField(
            controller: _nameController,
            hint: "اسمت رو وارد کن",
            textDirection: TextDirection.rtl,
          ),
          16.h,
          CustomText.caption("شماره موبایل", color: context.colors.inkMuted),
          8.h,
          CustomTextField(
            controller: _phoneController,
            enabled: false,
            backgroundColor: context.colors.primaryTint,
            textDirection: TextDirection.ltr,
          ),
          16.h,
          CustomText.caption("نام کاربری", color: context.colors.inkMuted),
          8.h,
          CustomTextField(
            controller: _usernameController,
            hint: "نام کاربری‌ت رو وارد کن",
            textDirection: TextDirection.ltr,
          ),
          16.h,
          BlocConsumer<EditProfileBloc, EditProfileState>(
            bloc: editProfileBloc,
            listener: (context, state) {
              state.whenOrNull(
                error: (isLoading, message) {
                  CustomToast.toast(context, message);
                },
                success: (isLoading, data) {
                  final current = HiveService.user;
                  if (current != null) {
                    HiveService.setUser(
                      User(
                        id: data.id ?? current.id,
                        phone: data.phone ?? current.phone,
                        username: data.username ?? current.username,
                        name: data.name ?? _nameController.text.trim(),
                      ),
                    );
                  }
                  CustomToast.toast(
                    context,
                    "ذخیره شد!",
                    type: Type.success,
                  );
                },
              );
            },
            builder: (context, state) {
              return CustomButton(
                title: "ذخیره",
                loading: state.isLoading,
                onTap: () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) {
                    CustomToast.toast(context, "اسمت رو وارد کن");
                    return;
                  }
                  editProfileBloc.add(
                    EditProfileEvent.editProfile(
                      params: RequestEditProfileModel(name: name),
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
    return MasirCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.lock_rounded, color: context.colors.primary, size: 22),
              8.w,
              CustomText.headline("امنیت"),
            ],
          ),
          Divider(height: 30, color: context.colors.border),
          CustomText.caption("رمز عبور فعلی", color: context.colors.inkMuted),
          8.h,
          CustomTextField(
            controller: _currentPasswordController,
            isPassword: true,
            hint: "رمز عبور فعلی‌ت رو وارد کن",
          ),
          16.h,
          CustomText.caption("رمز عبور جدید", color: context.colors.inkMuted),
          8.h,
          CustomTextField(
            controller: _newPasswordController,
            isPassword: true,
            hint: "رمز عبور جدید رو وارد کن",
          ),
          16.h,
          CustomText.caption("تکرار رمز عبور", color: context.colors.inkMuted),
          8.h,
          CustomTextField(
            controller: _confirmPasswordController,
            isPassword: true,
            hint: "رمز عبور جدید رو دوباره بنویس",
          ),
          16.h,
          BlocConsumer<EditPasswordBloc, EditPasswordState>(
            bloc: editPasswordBloc,
            listener: (context, state) {
              state.whenOrNull(
                error: (isLoading, message) {
                  CustomToast.toast(context, message);
                },
                success: (isLoading, data) {
                  _clearPasswordFields();
                  CustomToast.toast(
                    context,
                    "رمزت عوض شد",
                    type: Type.success,
                  );
                },
              );
            },
            builder: (context, state) {
              return CustomButton(
                title: "ذخیره",
                loading: state.isLoading,
                onTap: _onChangePassword,
              );
            },
          ),
        ],
      ),
    );
  }
}
