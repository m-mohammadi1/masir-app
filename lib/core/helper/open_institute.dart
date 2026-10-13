import 'package:easy_helper/easy_helper.dart';
import 'package:go_router/go_router.dart';

/// The one way to open an institute's home.
///
/// Pushes it, so back returns to where the student came from. But only one
/// institute can be on the navigation stack at a time: every institute page
/// sits inside the same shell route, whose nested navigator has a single
/// GlobalKey, and a second copy of the shell (the same institute or another)
/// trips the duplicate key assertions. So when an institute is already open
/// underneath, this goes to the new one instead, replacing the stack.
void openInstitute(String id, {GoRouter? router}) {
  final r = router ?? GoRouter.of(CustomNavigator.context!);
  final home = '/i/$id/home';
  if (isInstituteOnStack(r)) {
    r.go(home);
  } else {
    r.push(home);
  }
}

/// Whether an institute shell (or institute [id]'s, when given) is anywhere on
/// [router]'s stack, including pages pushed on top of the base location.
bool isInstituteOnStack(GoRouter router, [String? id]) =>
    _contains(router.routerDelegate.currentConfiguration.matches, id);

bool _contains(List<RouteMatchBase> matches, String? id) {
  final segment = id == null ? '[^/]+' : RegExp.escape(id);
  final prefix = RegExp('^/i/$segment(/|\$)');
  for (final match in matches) {
    final found = switch (match) {
      ImperativeRouteMatch(:final matches) => _contains(matches.matches, id),
      ShellRouteMatch(:final matches) => _contains(matches, id),
      _ => prefix.hasMatch(match.matchedLocation),
    };
    if (found) return true;
  }
  return false;
}
