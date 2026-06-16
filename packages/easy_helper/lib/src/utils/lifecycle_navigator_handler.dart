import 'package:flutter/material.dart';

class LifecycleNavigatorHandler extends NavigatorObserver {
  static String currentRouteName = '';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentRouteName = route.settings.name ?? "";
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentRouteName = previousRoute?.settings.name ?? "";
    });
  }
}
