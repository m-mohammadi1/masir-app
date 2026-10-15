import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/design/design.dart';

/// A link that leads nowhere (old deep link, mistyped web address).
class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.paper,
    body: SafeArea(
      child: Center(
        child: EmptyState(
          icon: MI.search,
          title: 'این صفحه پیدا نشد',
          body: 'شاید لینکش عوض شده. از ویترین دوباره راه بیفت.',
          action: 'برگشت به ویترین',
          onAction: () => context.go(Routes.vitrine),
        ),
      ),
    ),
  );
}
