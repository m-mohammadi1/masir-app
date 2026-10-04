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
import '/core/theme/masir_style.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_button.dart';
import '/widgets/pill_chip.dart';
import '/widgets/custom_text.dart';
import '/widgets/custom_text_field.dart';

import '../bloc/auth_bloc.dart';
import '../widget/verify_phone_bottom_sheet.dart';
import '/core/theme/theme_context.dart';


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
      backgroundColor: context.colors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AuthLogo(),
              16.h,
              CustomText(
                _mode == _AuthMode.login ? "خوش برگشتی!" : "بیا شروع کنیم",
                fontSize: MasirText.displaySize,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
              6.h,
              CustomText(
                _mode == _AuthMode.login
                    ? "نام کاربری و رمز عبورت رو وارد کن"
                    : "کد دعوت و شماره موبایلت رو وارد کن",
                fontSize: 14,
                color: context.colors.inkMuted,
                textAlign: TextAlign.center,
              ),
              24.h,
              _ModeTabs(mode: _mode, onChanged: _switchMode),
              24.h,
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: KeyedSubtree(
                  key: ValueKey(_mode),
                  child: _mode == _AuthMode.login
                      ? _buildLoginContent()
                      : _buildRegisterContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: const PillChip(
            'کد دعوتِ مؤسسه',
            icon: Icons.confirmation_number_rounded,
            tone: PillTone.sun,
          ),
        ),
        8.h,
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

class _ModeTabs extends StatelessWidget {
  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  const _ModeTabs({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget tab(String label, _AuthMode m) {
      final selected = mode == m;
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(m),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? c.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(MasirRadius.pill),
              border: selected
                  ? Border.all(color: c.primary, width: Chunky.border)
                  : null,
            ),
            child: CustomText(
              label,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: selected ? c.primary : c.inkMuted,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.border100,
        borderRadius: BorderRadius.circular(MasirRadius.pill),
      ),
      child: Row(
        children: [
          tab('ورود', _AuthMode.login),
          tab('ثبت‌نام', _AuthMode.register),
        ],
      ),
    );
  }
}

class _AuthLogo extends StatelessWidget {
  const _AuthLogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChunkyBox(
        fill: context.colors.primary,
        edge: context.colors.primaryEdge,
        radius: 24,
        width: 84,
        height: 88,
        alignment: Alignment.center,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CustomText(
            "R/",
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: context.colors.onPrimary,
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
      textFieldRadius: 16,
      borderColor: isFocused ? context.colors.primary : context.colors.border,
      backgroundColor: isFocused ? context.colors.primary100 : context.colors.surface,
      labelStyle: customTextStyle(
        context,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: context.colors.ink,
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
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
