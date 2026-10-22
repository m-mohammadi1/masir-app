import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '/design/design.dart';

/// Watches the root navigator: [busy] is true while a page slides in or out.
/// Pages deeper in the stack can't see the top page's transition through
/// their own route, so they ask here.
class RouteMotion extends NavigatorObserver {
  RouteMotion._();
  static final instance = RouteMotion._();

  static final busy = ValueNotifier<bool>(false);
  static final Set<Animation<double>> _moving = {};

  static bool _isMoving(Animation<double> a) =>
      a.status == AnimationStatus.forward ||
      a.status == AnimationStatus.reverse;

  void _watch(Route<dynamic>? route) {
    if (route is! TransitionRoute) return;
    final a = route.animation;
    if (a == null || _moving.contains(a)) return;
    // The pop starts its reverse run right after this callback.
    scheduleMicrotask(() {
      if (!_isMoving(a) || !_moving.add(a)) return;
      void done(AnimationStatus s) {
        if (_isMoving(a)) return;
        a.removeStatusListener(done);
        _moving.remove(a);
        busy.value = _moving.isNotEmpty;
      }

      a.addStatusListener(done);
      busy.value = true;
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _watch(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _watch(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _watch(newRoute);
}

/// Whether a page transition is moving or covering this page right now.
bool routeMoving(BuildContext context) {
  if (MasirMotion.reduced(context)) return false;
  final route = ModalRoute.of(context);
  bool moving(Animation<double>? a) =>
      a != null &&
      (a.status == AnimationStatus.forward ||
          a.status == AnimationStatus.reverse);
  return RouteMotion.busy.value ||
      moving(route?.animation) ||
      moving(route?.secondaryAnimation);
}

/// [routeSettled], for work triggered right before a navigation (a unit
/// counts, then the next unit is pushed): waits for that push to start
/// first, so the work doesn't run inside it.
Future<void> afterTransitions(BuildContext context) async {
  await WidgetsBinding.instance.endOfFrame;
  await Future<void>.delayed(Duration.zero);
  if (!context.mounted) return;
  await routeSettled(context);
}

/// Completes once no page transition is moving this page or the one above
/// it, so work that rebuilds a lot (data arriving, reloads) lands between
/// transitions instead of inside one. Never waits longer than [max].
Future<void> routeSettled(
  BuildContext context, {
  Duration max = const Duration(seconds: 1),
}) async {
  // A page's first build runs before its push animation starts (the route
  // still reads as settled then), so during a frame look once it's over.
  if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
    await SchedulerBinding.instance.endOfFrame;
    if (!context.mounted) return;
  }
  if (!routeMoving(context)) return;
  final route = ModalRoute.of(context);
  final listenables = <Listenable>[
    RouteMotion.busy,
    ?route?.animation,
    ?route?.secondaryAnimation,
  ];
  final done = Completer<void>();
  late final Listenable all = Listenable.merge(listenables);
  Timer? timeout;
  void check() {
    if (done.isCompleted) return;
    if (!context.mounted || !routeMoving(context)) {
      all.removeListener(check);
      timeout?.cancel();
      done.complete();
    }
  }

  all.addListener(check);
  timeout = Timer(max, () {
    if (done.isCompleted) return;
    all.removeListener(check);
    done.complete();
  });
  return done.future;
}
