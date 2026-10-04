import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_button.dart';

import '/core/theme/theme_context.dart';
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
    final c = context.colors;
    return BaseScreen(
      body: Column(
        children: [
          const CustomAppBar(title: "نتیجه امتحان"),
          20.h,
          _StatTile(label: "امتیاز", value: "1200", fill: c.primaryTint, edge: c.primaryEdge, accent: c.primary),
          12.h,
          _StatTile(label: "تعداد سوالات درست", value: "11", fill: c.green100, edge: c.greenEdge, accent: c.green),
          12.h,
          _StatTile(label: "تعداد سوالات غلط", value: "04", fill: c.coralSoft, edge: c.coralEdge, accent: c.coral),
          const Spacer(),
          CustomButton(title: "پایان", variant: ButtonVariant.success),
          20.h,
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color fill;
  final Color edge;
  final Color accent;

  const _StatTile({
    required this.label,
    required this.value,
    required this.fill,
    required this.edge,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return ChunkyBox(
      fill: fill,
      edge: edge,
      borderColor: accent,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, fontWeight: FontWeight.w700),
          CustomText(
            value,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: edge,
          ),
        ],
      ),
    );
  }
}
