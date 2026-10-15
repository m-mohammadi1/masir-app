import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/app/state/session.dart';

/// Leaves a page: pops when possible, otherwise goes to the space's home
/// (pages opened by deep link or after a refresh have no history).
void back(BuildContext context, {String? fallback}) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
    return;
  }
  final inst = Session.instituteId.value;
  router.go(fallback ?? (inst != null ? Routes.instHome(inst) : Routes.vitrine));
}

/// Reads `extra` safely: on web it is restored from history as JSON or null.
Map<String, dynamic> extraOf(GoRouterState state) {
  final e = state.extra;
  return e is Map ? e.cast<String, dynamic>() : const {};
}
