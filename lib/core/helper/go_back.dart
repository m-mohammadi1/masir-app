import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '/features/main/presentation/page/main_page.dart';

/// The one way every back / close button leaves a page.
///
/// Pops when there is somewhere to go back to. Pages reached with `go` (deep
/// links, notifications, after login) have no history, so instead of doing
/// nothing or popping to a blank screen they go to [fallback]; by default the
/// institute home when inside an institute, or the main page otherwise.
void goBack(BuildContext context, {String? fallback}) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
    return;
  }
  router.go(fallback ?? _defaultFallback(context));
}

String _defaultFallback(BuildContext context) {
  try {
    final path = GoRouterState.of(context).uri.path;
    final match = RegExp(r'^/i/([^/]+)').firstMatch(path);
    if (match != null) return '/i/${match.group(1)}/home';
  } catch (_) {
    // Not under a route builder; use the global fallback.
  }
  return MainPage.routeName;
}
