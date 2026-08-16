import 'package:mohammad/core/services/hive_service.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/institute/domain/usecases/get_wallet.dart';

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'core/helper/assets.dart';
import 'features/auth/presentation/page/auth_screen.dart';
import 'features/main/presentation/page/main_page.dart';
import '/core/theme/theme_context.dart';

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
    Future.delayed(const Duration(seconds: 1), _goNext);
  }

  Future<void> _goNext() async {
    if (!HiveService.isLogged) {
      CustomNavigator.go(AuthScreen.routeName);
      return;
    }

    try {
      final result = await inject<GetWalletUseCase>()();
      result.fold((_) => CustomNavigator.go(MainPage.routeName), (cards) {
        if (cards.length == 1) {
          final id = cards.first.instituteId;
          if (id != null && id.isNotEmpty) {
            CustomNavigator.go('/i/$id/home');
            return;
          }
        }
        CustomNavigator.go(MainPage.routeName);
      });
    } catch (_) {
      CustomNavigator.go(MainPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: CustomImage(assets: Assets.logo, color: context.colors.secondary),
        ),
      ),
    );
  }
}
