import '/widgets/pressable.dart';
import '/features/auth/presentation/page/auth_screen.dart';
import 'dart:async';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/features/auth/data/models/request_submit_register_model.dart';
import 'package:mohammad/features/auth/presentation/bloc/submit_register/submit_register_bloc.dart';
import 'package:mohammad/features/register/presentation/page/register_page.dart';
import '/core/helper/go_back.dart';
import '/core/theme/masir_style.dart';
import '/features/auth/presentation/widgets/auth_text_field.dart';
import '/widgets/auth_hero.dart';
import '/widgets/masir_page.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import 'package:otp_text_field_v2/otp_field_style_v2.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import '../../../../core/services/service_locator.dart';
import '../bloc/otp_form/otp_form_bloc.dart';
import '/core/theme/theme_context.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String inviteCode;
  static const routeName = "/otp";

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.inviteCode,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _initialTime = 120; // 2 minutes = 120 seconds
  int _remainingTime = _initialTime;
  Timer? _timer;
  final _otpForm = inject<OtpFormBloc>();

  String otp = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingTime = _initialTime;
    _otpForm.add(OtpFormEvent.refreshEvent());
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        _otpForm.add(OtpFormEvent.refreshEvent());
      } else {
        _remainingTime--;
        _otpForm.add(OtpFormEvent.refreshEvent());
      }
    });
  }

  String get _formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String maskedPhoneMessage(String phoneNumber) {
    if (phoneNumber.length < 8 || !phoneNumber.startsWith('+')) {
      return "";
    }
    final match = RegExp(r'^\+(\d{1,4})').firstMatch(phoneNumber);
    if (match == null) return "";

    final countryCode = match.group(0)!;
    final remaining = phoneNumber.substring(countryCode.length);

    if (remaining.length < 4) return "";

    final last4 = remaining.substring(remaining.length - 4);
    final masked = '*' * 6;

    return '$countryCode$masked$last4';
  }

  final controller = OtpFieldControllerV2();
  final pass = TextEditingController();

  final bloc = inject<SubmitRegisterBloc>();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasirPage.focus(
      title: "تأیید شماره",
      onClose: () => goBack(context, fallback: AuthScreen.routeName),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.h,
          AuthHero(
            icon: Icons.sms_rounded,
            title: "کد تأییدت رو وارد کن",
            subtitleWidget: Column(
              children: [
                CustomText.body(
                  "کد ۶ رقمی به شماره‌ی",
                  color: context.colors.inkMuted,
                  textAlign: TextAlign.center,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomText.headline(
                    widget.phoneNumber,
                    color: context.colors.primary,
                  ),
                ),
                CustomText.body(
                  "پیامک شد.",
                  color: context.colors.inkMuted,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          12.h,
          Center(
            child: Pressable(
              onTap: () {
                CustomNavigator.pop();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: context.colors.primary,
                  ),
                  4.w,
                  CustomText.bodyStrong(
                    "ویرایش شماره",
                    color: context.colors.primary,
                  ),
                ],
              ),
            ),
          ),
          24.h,
          CustomText.caption(
            "یه رمز برای دفعه‌های بعد انتخاب کن",
            color: context.colors.inkMuted,
          ),
          8.h,
          AuthTextField(
            label: "رمز عبور",
            controller: pass,
            focusNode: FocusNode(),
            isPassword: true,
            action: TextInputAction.next,
            // onChanged: (_) => setState(() {}),
          ),
          40.h,
          BlocConsumer<SubmitRegisterBloc, SubmitRegisterState>(
            bloc: bloc,
            listener: (context, state) {
              state.whenOrNull(
                error: (isLoading, message) {
                  controller.clear();
                  CustomToast.toast(context, message);
                },
                success: (isLoading, data) {
                  CustomNavigator.go(RegisterPage.routeName);
                },
              );
            },
            builder: (context, state) => Column(
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: SizedBox(
                    height: 60,
                    child: OTPTextFieldV2(
                      controller: controller,
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceBetween,
                      fieldWidth: 48,
                      cursorColor: context.colors.primary,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      otpFieldStyle: OtpFieldStyle(
                        borderColor: context.colors.border,
                        enabledBorderColor: context.colors.border,
                        focusBorderColor: context.colors.primary,
                        backgroundColor: context.colors.surface,
                      ),

                      fieldStyle: FieldStyle.box,
                      textDirection: TextDirection.ltr,
                      outlineBorderRadius: MasirRadius.row,
                      autoFocus: false,
                      style: MasirText.title(context.colors.ink),
                      onChanged: (pin) {
                        _otpForm.add(OtpFormEvent.refreshEvent());
                      },
                      onCompleted: (pin) {
                        // CustomNavigator.go(RegisterPage.routeName);
                        // CustomNavigator.go(MainPage.routeName);
                        otp = pin;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocBuilder<OtpFormBloc, OtpFormState>(
                bloc: _otpForm,
                builder: (context, state) {
                  return _remainingTime == 0
                      ? CustomButton(
                          title: "دوباره بفرست",
                          width: 100,
                          height: 40,
                          onTap: () {
                            _startTimer();
                          },
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText.caption(
                              "کد نیومد؟ ",
                              color: context.colors.inkMuted,
                            ),
                            CustomText.caption(
                              "تا $_formattedTime دیگه دوباره می‌فرستیم",
                              color: context.colors.primary,
                            ),
                          ],
                        );
                },
              ),
            ],
          ),

          24.h,
          BlocBuilder<SubmitRegisterBloc, SubmitRegisterState>(
            bloc: bloc,
            builder: (context, state) {
              return CustomButton(
                title: "بزن بریم",
                loading: state.isLoading,
                onTap: () {
                  bloc.add(
                    SubmitRegisterEvent.submitRegister(
                      params: RequestSubmitRegisterModel(
                        phone: widget.phoneNumber,
                        inviteCode: widget.inviteCode,
                        smsCode: otp,
                        password: pass.text,
                      ),
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
}
