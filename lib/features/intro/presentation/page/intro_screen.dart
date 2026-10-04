import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/presentation/page/auth_screen.dart';
import '/features/intro/presentation/widget/intro_widget.dart';
import '/widgets/base_screen.dart';
import '/widgets/custom_button.dart';
import '/core/theme/masir_style.dart';
import '/widgets/custom_text.dart';

import '../../bloc/intro_state_bloc.dart';
import '/core/theme/theme_context.dart';

class IntroScreen extends StatefulWidget {
  static const String routeName = "/intro";

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final pageController = PageController();

  IntroStateBloc bloc = IntroStateBloc();

  void _next() {
    if ((pageController.page ?? 0).round() < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      CustomNavigator.pushNamed(AuthScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pages = [
      IntroWidget(
        title: "قدم به قدم جلو برو",
        description: "هر درس یک ایستگاه روی مسیره؛ جلو برو و پیشرفتت رو ببین.",
        icon: Icons.route_rounded,
        tint: c.primaryTint,
        edge: c.primaryEdge.withValues(alpha: 0.4),
        accent: c.primary,
      ),
      IntroWidget(
        title: "مؤسسه‌ت رو پیدا کن",
        description: "با کد دعوت وارد دنیای مؤسسه‌ات شو و دوره‌هاش رو شروع کن.",
        icon: Icons.apartment_rounded,
        tint: c.sunSoft,
        edge: c.sunEdge.withValues(alpha: 0.5),
        accent: c.sunEdge,
      ),
      IntroWidget(
        title: "تمرین کن و جشن بگیر",
        description: "آزمون بده، جواب‌هات رو مرور کن و مسیرت رو ادامه بده.",
        icon: Icons.emoji_events_rounded,
        tint: c.green100,
        edge: c.greenEdge.withValues(alpha: 0.5),
        accent: c.greenEdge,
      ),
    ];

    return BaseScreen(
      body: Column(
        children: [
          24.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "مسیر",
                fontSize: MasirText.titleSize,
                fontWeight: FontWeight.w800,
                color: c.primary,
              ),
              OnClick(
                onTap: () => CustomNavigator.pushNamed(AuthScreen.routeName),
                child: CustomText(
                  "رد کردن",
                  fontWeight: FontWeight.w800,
                  color: c.inkMuted,
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: pages.length,
              onPageChanged: (value) {
                bloc.add(IntroStateEvent.changeIndex(value: value));
              },
              itemBuilder: (context, index) => pages[index],
            ),
          ),
          BlocProvider(
            create: (context) => bloc,
            child: BlocBuilder<IntroStateBloc, IntroStateState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < pages.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 10,
                        width: state.state == i ? 28 : 10,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: state.state == i ? c.primary : c.border,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          28.h,
          CustomButton(title: "ادامه", height: 54, onTap: _next),
          28.h,
        ],
      ),
    );
  }
}
