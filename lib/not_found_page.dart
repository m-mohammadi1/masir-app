import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/features/main/presentation/page/main_page.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';

/// Shown when a route does not exist.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MasirPage.detail(
      title: 'مسیر پیدا نشد',
      onBack: () => CustomNavigator.go(MainPage.routeName),
      body: StateView.empty(
        text: 'این صفحه پیدا نشد',
        description: 'شاید آدرس عوض شده یا دیگر وجود ندارد.',
        icon: Icons.explore_off_rounded,
        actionLabel: 'برگشت به خانه',
        onAction: () => CustomNavigator.go(MainPage.routeName),
      ),
    );
  }
}
