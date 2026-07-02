import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/auth/data/models/request_submit_username_model.dart';
import 'package:mohammad/features/auth/presentation/bloc/submit_username/submit_username_bloc.dart';
import 'package:mohammad/widgets/auth_app_bar.dart';
import 'package:mohammad/widgets/base_screen.dart';
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
          20.h,
          AuthAppBar(title: "ثبت نام کاربری"),
          60.h,
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
