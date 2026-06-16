// import 'package:flutter/material.dart';
//
// class CustomNavigator {
//   static final _navigatorKey = GlobalKey<NavigatorState>();
//
//   static BuildContext? get context => _navigatorKey.currentContext;
//
//   static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
//
//   static void pop({dynamic value}) => _navigatorKey.currentState!.pop(value);
//
//   static void popUntil({dynamic value, required String route}) {
//     _navigatorKey.currentState!.popUntil((r) {
//       return r.settings.name == route;
//     });
//   }
//
//   static Future<dynamic> push(Widget page) => _navigatorKey.currentState!
//       .push(MaterialPageRoute(builder: (context) => page));
//
//   static Future<dynamic> pushReplacement(Widget page) =>
//       _navigatorKey.currentState!
//           .pushReplacement(MaterialPageRoute(builder: (context) => page));
//
//   static Future<dynamic> pushAndRemoveUntil(Widget page) =>
//       _navigatorKey.currentState!.pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => page),
//         (route) => false,
//       );
//
//   static Future<dynamic> pushNamed(String routeName, {Object? arguments}) async {
//     _navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
//   }
//
//
//   static Future<dynamic> pushReplacementNamed(String routeName,
//           {Object? arguments}) =>
//       _navigatorKey.currentState!.pushReplacementNamed(
//         routeName,
//         arguments: arguments,
//       );
//
//   static Future<dynamic> pushNamedAndRemoveUntil(String routeName) =>
//       _navigatorKey.currentState!
//           .pushNamedAndRemoveUntil(routeName, (route) => false);
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigator {
  static final _navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => _navigatorKey.currentContext;

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static void pop({dynamic value}) => _navigatorKey.currentState?.context.pop(value);

  static Future<dynamic> pushNamed(String routeName, {Object? arguments}) async {
    final res =await _navigatorKey.currentState?.context.push(routeName, extra: arguments);
    return res;
  }

  static void go(String routeName, {Object? arguments}) => _navigatorKey.currentState!.context.go(routeName, extra: arguments);
}
