import 'package:mohammad/core/services/hive_service.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/institute/domain/usecases/get_wallet.dart';

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'core/helper/assets.dart';
import 'features/auth/presentation/page/auth_screen.dart';
import 'features/main/presentation/page/main_page.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';

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
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChunkyBox(
              width: 112,
              height: 112,
              radius: MasirRadius.hero,
              fill: c.surface,
              edge: c.primaryEdge,
              padding: const EdgeInsets.all(MasirSpace.xl),
              alignment: Alignment.center,
              child: CustomImage(assets: Assets.logo, color: c.primary),
            ),
            const SizedBox(height: MasirSpace.xl),
            CustomText.display('مسیر', color: c.onPrimary),
            const SizedBox(height: MasirSpace.xs),
            CustomText.body(
              'یادگیری، قدم به قدم',
              color: c.onPrimary.withValues(alpha: 0.85),
            ),
          ],
        ),
      ),
    );
  }
}
