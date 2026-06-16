import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_button.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../widgets/base_screen.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_text.dart';
import '../bloc/quiz_bloc.dart';

class EndQuizPage extends StatefulWidget {
  static const String routeName = "/end-quiz";

  const EndQuizPage({super.key});

  @override
  State<EndQuizPage> createState() => _EndQuizPageState();
}

class _EndQuizPageState extends State<EndQuizPage> {

  final QuizBloc bloc = inject<QuizBloc>();


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        children: [
          CustomAppBar(title: "نتیجه امتحان"),
          20.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText("امتیاز:"),
              CustomText("1200"),
            ],
          ),
          8.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText("تعداد سوالات درست:"),
              CustomText("11"),
            ],
          ),
          8.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText("تعداد سوالات غلط:"),
              CustomText("04"),
            ],
          ),
          8.h,
          Spacer(),
          CustomButton(title: "پایان"),
        ],
      ),
    );
  }
}
