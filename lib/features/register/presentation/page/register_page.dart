import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/auth/data/models/request_submit_username_model.dart';
import 'package:mohammad/features/auth/presentation/bloc/submit_username/submit_username_bloc.dart';
import 'package:mohammad/widgets/base_screen.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../main/presentation/page/main_page.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = "/register";

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();

  final bloc = inject<SubmitUsernameBloc>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        children: [
          48.h,
          Center(
            child: ChunkyBox(
              fill: context.colors.primaryTint,
              edge: context.colors.primary.withValues(alpha: 0.35),
              radius: 28,
              width: 84,
              height: 88,
              alignment: Alignment.center,
              child: Icon(
                Icons.person_rounded,
                size: 44,
                color: context.colors.primary,
              ),
            ),
          ),
          20.h,
          CustomText(
            "اسمت رو انتخاب کن",
            fontSize: MasirText.displaySize,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center,
          ),
          8.h,
          CustomText(
            "با این نام کاربری وارد مسیر می‌شی",
            color: context.colors.inkMuted,
            textAlign: TextAlign.center,
          ),
          32.h,
          CustomTextField(
            controller: _nameController,
            labelText: "نام کاربری",
            hint: "نام کاربری خود را وارد کنید",
          ),
          Spacer(),
          20.h,
          BlocConsumer<SubmitUsernameBloc, SubmitUsernameState>(
            bloc: bloc,
            listener: (context, state) {
              state.whenOrNull(
                success: (isLoading, data) {
                  CustomNavigator.go(MainPage.routeName);
                },
                error: (isLoading, message) {
                  CustomToast.toast(context, message);
                },
              );
            },
            builder: (context, state) {
              return CustomButton(
                loading: state.isLoading,
                title: "تایید",
                onTap: () {
                  bloc.add(
                    SubmitUsernameEvent.submitUsername(
                      params: RequestSubmitUsernameModel(
                        data: _nameController.text,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          30.h,
        ],
      ),
    );
  }
}
