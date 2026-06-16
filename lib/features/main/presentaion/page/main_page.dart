import 'dart:io';

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/home/page/home_page.dart';
import 'package:mohammad/features/profile/presentation/page/profile_page.dart';
import '../../../home/page/courses_page.dart';
import '/core/helper/assets.dart';
import '/core/helper/custom_colors.dart';
import '/widgets/custom_text.dart';

class MainPage extends StatefulWidget {
  static const String routeName = "/";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ProfilePage(),
      CoursesPage(),
      HomePage(),
    ];
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (index == 0) {
          setState(() {
            index = 1;
          });
        } else {
          exit(0);
        }
      },
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: pages[index]),
            Container(
              height: 99,
              width: context.appSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.border.withValues(alpha: .5),
                    blurRadius: 8,
                    spreadRadius: 8,
                  ),
                ],
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OnClick(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImage(
                          assets: index == 2
                              ? Assets.homeSelected
                              : Assets.home,
                          width: 24,
                          color: index == 2
                              ? AppColor.primary
                              : AppColor.secondary,
                        ),
                        2.h,
                        CustomText(
                          'ویترین',
                          color: index == 2
                              ? AppColor.primary
                              : AppColor.secondary,
                        ),
                      ],
                    ),
                  ),
                  OnClick(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImage(
                          assets: index == 1
                              ? Assets.homeSelected
                              : Assets.home,
                          width: 24,
                          color: index == 1
                              ? AppColor.primary
                              : AppColor.secondary,
                        ),
                        2.h,
                        CustomText(
                          'دوره هاى من',
                          color: index == 1
                              ? AppColor.primary
                              : AppColor.secondary,
                        ),
                      ],
                    ),
                  ),
                  OnClick(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImage(
                          assets: index == 0
                              ? Assets.profileSelected
                              : Assets.profile,
                          width: 24,
                          color: index == 0
                              ? AppColor.primary
                              : AppColor.secondary,
                        ),
                        2.h,
                        CustomText(
                          'پروفایل',
                          color: index == 0
                              ? AppColor.primary
                              : AppColor.secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            16.h,
          ],
        ),
      ),
    );
  }
}
