import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/features/auth/data/models/request_auth_model.dart';
import 'package:mohammad/features/auth/data/models/request_login_model.dart';
import 'package:mohammad/features/auth/presentation/bloc/login/login_bloc.dart';
import '../../../main/presentation/page/main_page.dart';
import '/core/services/service_locator.dart';
import '/features/otp/presentation/page/otp_screen.dart';
import '/widgets/base_modal.dart';
import '/widgets/base_screen.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/custom_text_field.dart';

import '../bloc/auth_bloc.dart';
import '../widget/verify_phone_bottom_sheet.dart';

class _AuthColors {
  static const purple = Color(0xFF7E42C5);
  static const background = Color(0xFFF8F6FC);
  static const subtitle = Color(0xFF929292);
  static const border = Color(0xFFE9E9E9);
  static const focusFill = Color(0xFFF3EDFA);

  _AuthColors._();
}

enum _AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth";

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  _AuthMode _mode = _AuthMode.login;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _phoneController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _inviteCodeFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final authBloc = inject<AuthBloc>();
  final loginBloc = inject<LoginBloc>();

  bool get _isLoginValid =>
      _usernameController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty;

  bool get _isRegisterValid =>
      _inviteCodeController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final node in [
      _usernameFocus,
      _passwordFocus,
      _inviteCodeFocus,
      _phoneFocus,
    ]) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _inviteCodeController.dispose();
    _phoneController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _inviteCodeFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _switchMode(_AuthMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
  }

  void _onRegisterNext() {
    showCustomModal(
      context: context,
      callBack: (data) {
        if (data == true) {
          authBloc.add(
            AuthEvent.auth(
              params: RequestAuthModel(
                phone: _phoneController.text,
                inviteCode: _inviteCodeController.text,
              ),
            ),
          );
        }
      },
      child: VerifyPhoneBottomSheet(phoneNumber: _phoneController.text),
    );
  }

  void _onLogin() {
    loginBloc.add(
      LoginEvent.login(
        params: RequestLoginModel(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      backgroundColor: _AuthColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.1,
                  colors: [
                    _AuthColors.purple.withValues(alpha: 0.14),
                    _AuthColors.background.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: _AuthCard(
                child: _mode == _AuthMode.login
                    ? _buildLoginContent()
                    : _buildRegisterContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _AuthLogo(),
        20.h,
        const CustomText(
          "ورود به اپ مسیر",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        8.h,
        const CustomText(
          "نام کاربری و رمز عبور خود را وارد کنید",
          fontSize: 13,
          color: _AuthColors.subtitle,
          textAlign: TextAlign.center,
        ),
        28.h,
        _AuthTextField(
          label: "نام کاربری",
          controller: _usernameController,
          focusNode: _usernameFocus,
          onChanged: (_) => setState(() {}),
        ),
        16.h,
        _AuthTextField(
          label: "رمز عبور",
          controller: _passwordController,
          focusNode: _passwordFocus,
          isPassword: true,
          action: TextInputAction.done,
          onChanged: (_) => setState(() {}),
        ),
        28.h,
        BlocConsumer<LoginBloc, LoginState>(
          bloc: loginBloc,
          listener: (context, state) {
            state.whenOrNull(
              error: (isLoading, message) {
                CustomToast.toast(context, message);
              },
              success: (isLoading, data) {
                CustomNavigator.go(MainPage.routeName);
              },
            );
          },
          builder: (context, state) {
            return CustomButton(
              title: "ورود",
              enable: _isLoginValid,
              loading: state.isLoading,
              backgroundColor: _AuthColors.purple,
              enableColor: _AuthColors.purple.withValues(alpha: 0.45),
              buttonSizeRadius: 10,
              onTap: _onLogin,
            );
          },
        ),
        20.h,
        _AuthLink(
          text: "فراموشی رمز عبور",
          onTap: () {
            CustomToast.toast(context, "به زودی");
          },
        ),
        12.h,
        _AuthLink(
          text: "حساب ندارید؟ ثبت ‌نام",
          onTap: () => _switchMode(_AuthMode.register),
        ),
      ],
    );
  }

  Widget _buildRegisterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CustomText(
          "ثبت ‌نام",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        8.h,
        const CustomText(
          "کد دعوت و شماره موبایل خود را وارد کنید",
          fontSize: 13,
          color: _AuthColors.subtitle,
          textAlign: TextAlign.center,
        ),
        28.h,
        _AuthTextField(
          label: "کد دعوت",
          controller: _inviteCodeController,
          focusNode: _inviteCodeFocus,
          textDirection: TextDirection.ltr,
          onChanged: (_) {
            authBloc.add(AuthEvent.refresh());
            setState(() {});
          },
        ),
        16.h,
        _AuthTextField(
          label: "شماره موبایل",
          controller: _phoneController,
          focusNode: _phoneFocus,
          type: TextInputType.phone,
          textDirection: TextDirection.ltr,
          maxLength: 11,
          action: TextInputAction.done,
          onChanged: (_) {
            authBloc.add(AuthEvent.refresh());
            setState(() {});
          },
        ),
        28.h,
        BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state) {
            state.whenOrNull(
              success: (isLoading, data) {
                CustomNavigator.pushNamed(
                  OtpScreen.routeName,
                  arguments: {
                    "phoneNumber": _phoneController.text,
                    "inviteCode": _inviteCodeController.text,
                  },
                );
              },
              error: (isLoading, message) {
                CustomToast.toast(context, message);
              },
            );
          },
          builder: (context, state) {
            return CustomButton(
              title: "بعدی",
              loading: state.isLoading,
              enable: _isRegisterValid,
              backgroundColor: _AuthColors.purple,
              enableColor: _AuthColors.purple.withValues(alpha: 0.45),
              buttonSizeRadius: 10,
              onTap: _onRegisterNext,
            );
          },
        ),
        20.h,
        _AuthLink(
          text: "حساب دارید؟ ورود",
          onTap: () => _switchMode(_AuthMode.login),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  final Widget child;

  const _AuthCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AuthLogo extends StatelessWidget {
  const _AuthLogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: _AuthColors.purple,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: const CustomText(
            "R/",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final TextInputType? type;
  final TextDirection? textDirection;
  final int? maxLength;
  final TextInputAction action;
  final ValueChanged<String>? onChanged;

  const _AuthTextField({
    required this.label,
    required this.controller,
    required this.focusNode,
    this.isPassword = false,
    this.type,
    this.textDirection,
    this.maxLength,
    this.action = TextInputAction.next,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;

    return CustomTextField(
      controller: controller,
      currentFocus: focusNode,
      labelText: label,
      isPassword: isPassword,
      type: type,
      textDirection: textDirection,
      maxLength: maxLength,
      action: action,
      onChanged: onChanged,
      textFieldRadius: 10,
      borderColor: isFocused ? _AuthColors.purple : _AuthColors.border,
      backgroundColor: isFocused ? _AuthColors.focusFill : Colors.white,
      labelStyle: customTextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF252525),
      ),
    );
  }
}

class _AuthLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _AuthLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: CustomText(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: _AuthColors.purple,
            decoration: TextDecoration.underline,
            decorationColor: _AuthColors.purple,
          ),
        ),
      ),
    );
  }
}
