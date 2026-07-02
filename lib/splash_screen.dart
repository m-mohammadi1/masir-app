
import 'package:mohammad/core/services/hive_service.dart';

import '/core/helper/custom_colors.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'core/helper/assets.dart';
import 'features/auth/presentation/page/auth_screen.dart';
import 'features/main/presentation/page/main_page.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if(HiveService.isLogged){
        CustomNavigator.pushNamed(MainPage.routeName);

      }else{
        CustomNavigator.pushNamed(AuthScreen.routeName);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: CustomImage(assets: Assets.logo , color: AppColor.secondary),
        ),
      ),
    );
  }
}
