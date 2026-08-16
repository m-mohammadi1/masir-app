import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/presentation/page/auth_screen.dart';
import '/features/intro/presentation/widget/intro_widget.dart';
import '/widgets/base_screen.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_outline_button.dart';

import '../../../../core/helper/assets.dart';
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

  List<_IntroModel> data = [
    _IntroModel(
      title: "intro_title_1",
      description: "intro_description_1",
      image: "intro_1",
    ),
    _IntroModel(
      title: "intro_title_2",
      description: "intro_description_2",
      image: "intro_2",
    ),
    _IntroModel(
      title: "intro_title_3",
      description: "intro_description_3",
      image: "intro_3",
    ),
  ];

  IntroStateBloc bloc = IntroStateBloc();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomImage(
              assets: "assets/png/intro_background.png",
              height: 450,
            ),
          ),
          Column(
            children: [
              25.h,
              CustomImage(assets: Assets.logo),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  reverse: true,
                  itemCount: 3,
                  onPageChanged: (value) {
                    bloc.add(IntroStateEvent.changeIndex(value: value));
                  },
                  itemBuilder: (context, index) =>
                      IntroWidget(
                        title: data[index].title,
                        description: data[index].description,
                        image: data[index].image,
                        index: index,
                      ),
                ),
              ),
              CustomButton(
                title: "next",
                onTap: () {
                  if (pageController.page != 2) {
                    pageController.nextPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    CustomNavigator.pushNamed(AuthScreen.routeName);
                  }
                },
              ),
              7.h,
              CustomOutlineButton(
                title: "skip",
                onTap: () {
                  CustomNavigator.pushNamed(AuthScreen.routeName);
                },
              ),
              30.h,
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: BlocProvider(
              create: (context) => bloc,
              child: Container(
                height: 8,
                margin: EdgeInsets.only(top: context.appSize.height * .56),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: BlocBuilder<IntroStateBloc, IntroStateState>(
                    builder: (context, state) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,

                        itemBuilder: (context, index) {
                          if (state.state != index) {
                            return Container(
                              width: 12,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: context.colors.border100,
                              ),
                            );
                          }
                          return Container(
                            width: 24,
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: context.colors.primary,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroModel {
  final String title, description, image;

  _IntroModel({
    required this.title,
    required this.description,
    required this.image,
  });
}
