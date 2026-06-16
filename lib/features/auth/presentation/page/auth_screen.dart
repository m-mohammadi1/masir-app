import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/helper/custom_colors.dart';
import '/core/services/service_locator.dart';
import '/features/otp/presentation/page/otp_screen.dart';
import '/widgets/base_modal.dart';
import '/widgets/base_screen.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/custom_text_field.dart';

import '../../../../core/helper/assets.dart';
import '../../data/models/request_auth_model.dart';
import '../bloc/auth_bloc.dart';
import '../widget/verify_phone_bottom_sheet.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth";

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final phoneNumber = TextEditingController();

  final authBloc = inject<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          48.h,
          Center(child: CustomImage(assets: Assets.logo, height: 200,color: AppColor.secondary)),
          48.h,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText("سلام", fontSize: 20, fontWeight: FontWeight.bold),
                8.h,
                CustomText(
                  "خوش آمدید",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),

                24.h,
                CustomTextField(
                  controller: phoneNumber,
                  type: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  maxLength: 11,
                  hint: "09121111111",
                  onChanged: (_) {
                    authBloc.add(AuthEvent.refresh());
                  },
                  labelText: "شماره تلفن خود را وارد کنید".tr,
                  suffixIcon: SizedBox(
                    width: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColor.border150,
                        ),
                        8.w,
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CustomText(
                            "+98",
                            color: AppColor.text92,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              state.whenOrNull(
                success: (isLoading, data) {
                  CustomNavigator.pushNamed(
                    OtpScreen.routeName,
                    arguments: phoneNumber.text,
                  );
                },
                error: (isLoading, message) {
                  CustomToast.toast(context, message);
                },
              );
            },
            builder: (context, state) {
              return CustomButton(
                title: "ادامه",
                loading: state.isLoading,
                enable: phoneNumber.text.trim().isNotEmpty,
                onTap: () {
                  showCustomModal(
                    context: context,
                    callBack: (data) {
                      if (data == true) {
                        CustomNavigator.pushNamed(
                          OtpScreen.routeName,
                          arguments: phoneNumber.text,
                        );
                        // authBloc.add(
                        //   AuthEvent.auth(
                        //     params: RequestAuthModel(phone: phoneNumber.text),
                        //   ),
                        // );
                      }
                    },
                    child: VerifyPhoneBottomSheet(
                      phoneNumber: phoneNumber.text,
                    ),
                  );
                },
              );
            },
          ),

          8.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText("با زدن دکمه ثبت "),
              CustomText("باقوانین ", color: AppColor.primary),
              CustomText("موافقم"),
            ],
          ),
          48.h,
        ],
      ),
    );
  }
}
