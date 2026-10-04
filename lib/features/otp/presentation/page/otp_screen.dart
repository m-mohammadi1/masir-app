import 'dart:async';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/features/auth/data/models/request_submit_register_model.dart';
import 'package:mohammad/features/auth/presentation/bloc/submit_register/submit_register_bloc.dart';
import 'package:mohammad/features/register/presentation/page/register_page.dart';
import '../../../../widgets/custom_text_field.dart';
import '/widgets/back_button.dart';
import '/widgets/base_screen.dart';
import '/core/theme/masir_style.dart';
import '/widgets/chunky_box.dart';
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
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomBackButton(),
          32.h,
          Center(
            child: ChunkyBox(
              fill: context.colors.primaryTint,
              edge: context.colors.primary.withValues(alpha: 0.35),
              radius: 28,
              width: 84,
              height: 88,
              alignment: Alignment.center,
              child: Icon(
                Icons.sms_rounded,
                size: 40,
                color: context.colors.primary,
              ),
            ),
          ),
          20.h,
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                CustomText(
                  "کد تأییدت رو وارد کن",
                  fontSize: MasirText.displaySize,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                ),
                8.h,
                CustomText(
                  "کد ۶ رقمی به شماره‌ی",
                  color: context.colors.inkMuted,
                  textAlign: TextAlign.center,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomText(
                    widget.phoneNumber,
                    color: context.colors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                CustomText(
                  "پیامک شد.",
                  color: context.colors.inkMuted,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          12.h,
          Center(
            child: OnClick(
              onTap: () {
                CustomNavigator.pop();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded,
                      size: 16, color: context.colors.primary),
                  6.w,
                  CustomText(
                    "ویرایش شماره",
                    color: context.colors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ),
          24.h,
          CustomText(
            "برای ورودهای بعدی یک رمز عبور انتخاب کن",
            fontSize: 12,
            color: context.colors.inkMuted,
          ),
          8.h,
          _AuthTextField(
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
                      outlineBorderRadius: 16,
                      autoFocus: false,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Masir',
                        color: context.colors.ink,
                      ),
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
                if (state.isLoading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomLoading(),
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
                          title: "ارسال مجدد",
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
                            CustomText(
                              "هنوز کد رو دریافت نکردید؟ ارسال مجدد در ",
                              fontSize: 13,
                              color: context.colors.inkMuted,
                            ),
                            CustomText(
                              "$_formattedTime ${"ثانیه"}",
                              color: context.colors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
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
                title: "تایید",
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
