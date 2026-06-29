import 'dart:async';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/features/register/presentation/page/register_page.dart';
import '/core/helper/assets.dart';
import '/core/helper/custom_colors.dart';
import '/features/main/presentaion/page/main_page.dart';
import '/features/otp/data/models/request_otp_model.dart';
import '/widgets/back_button.dart';
import '/widgets/base_screen.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import 'package:otp_text_field_v2/otp_field_style_v2.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import '../../../../core/services/service_locator.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_form/otp_form_bloc.dart';

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
  final otpBloc = inject<OtpBloc>();
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
          64.h,
          Column(
            children: [
              Row(
                children: [
                  CustomImage(assets: Assets.light, height: 24),
                  5.w,
                  CustomText(
                    "وارد كردن كد تأييد",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              8.h,
              Row(
                children: [
                  CustomText(
                    "کدتایید به شماره",
                    fontWeight: FontWeight.w500,
                    color: AppColor.text92,
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomText(
                      " ${widget.phoneNumber} ",
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomText(
                    "ارسال شده را وارد کنید.",
                    color: AppColor.text92,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          16.h,
          OnClick(
            onTap: () {
              CustomNavigator.pop();
            },
            child: Row(
              children: [
                CustomText(
                  "شماره موبایل اشتباه است؟",
                  color: AppColor.text92,
                  fontSize: 12,
                ),
                6.w,
                CustomText(
                  "ویرایش شماره",
                  color: AppColor.primary,
                  fontSize: 12,
                ),
                4.w,
                CustomImage(assets: Assets.edit),
              ],
            ),
          ),
          40.h,
          BlocConsumer<OtpBloc, OtpState>(
            bloc: otpBloc,
            listener: (context, state) {
              state.whenOrNull(
                error: (isLoading, message) {
                  controller.clear();
                  CustomToast.toast(context, message);
                },
                success: (isLoading, data) {
                  CustomNavigator.go(MainPage.routeName);
                },
              );
            },
            builder: (context, state) => Column(
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: SizedBox(
                    // height: 60,
                    child: OTPTextFieldV2(
                      controller: controller,
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceBetween,
                      fieldWidth: 60,
                      cursorColor: AppColor.primary,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      otpFieldStyle: OtpFieldStyle(
                        borderColor: AppColor.primary,
                        focusBorderColor: AppColor.primary,
                        backgroundColor: AppColor.borderF9,
                      ),

                      fieldStyle: FieldStyle.box,
                      textDirection: TextDirection.ltr,
                      outlineBorderRadius: 8,
                      autoFocus: true,
                      style: TextStyle(fontSize: 17),
                      onChanged: (pin) {
                        _otpForm.add(OtpFormEvent.refreshEvent());
                      },
                      onCompleted: (pin) {
                        CustomNavigator.go(RegisterPage.routeName);
                        // CustomNavigator.go(MainPage.routeName);
                        otp = pin;
                        otpBloc.add(
                          OtpEvent.otp(
                            params: RequestOtpModel(
                              code: otp,
                              identifier: widget.phoneNumber,
                            ),
                          ),
                        );
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
                              fontSize: 12,
                            ),
                            CustomText(
                              "$_formattedTime ${"ثانیه"}",
                              color: AppColor.primary,
                              fontSize: 12,
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
