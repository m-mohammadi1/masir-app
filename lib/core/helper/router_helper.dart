// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// bool? getBool(String? str) {
//   if (str == null) return null;
//   return str == "true";
// }
//
// int? getInt(String? srt) => int.tryParse(srt ?? "");
//
// double? getDouble(String? srt) => double.tryParse(srt ?? "");
//
// num? getNum(String? srt) => num.tryParse(srt ?? "");
//
// DateTime? getTime(String? srt) => DateTime.tryParse(srt ?? "");
//
// String? timeToString(DateTime? time) => time.toString();
//
// extension CustomRouter on String {
//   String get removed => substring(1);
//
//   String get added => "/$this";
// }
//
// extension DataRouter on GoRouterState {
//   Map<String, String> get data => uri.queryParameters;
// }
//
//
// class DialogPage<T> extends Page<T> {
//   final Offset? anchorPoint;
//   final Color? barrierColor;
//   final bool barrierDismissible;
//   final String? barrierLabel;
//   final bool useSafeArea;
//   final CapturedThemes? themes;
//   final Widget child;
//
//   const DialogPage({
//     required this.child,
//     this.anchorPoint,
//     this.barrierColor = Colors.transparent,
//     this.barrierDismissible = true,
//     this.barrierLabel,
//     this.useSafeArea = true,
//     this.themes,
//     super.key,
//     super.name,
//     super.arguments,
//     super.restorationId,
//   });
//
//   @override
//   Route<T> createRoute(BuildContext context) => DialogRoute<T>(
//         context: context,
//         settings: this,
//         builder: (context) => child,
//         anchorPoint: anchorPoint,
//         barrierColor: barrierColor,
//         barrierDismissible: barrierDismissible,
//         barrierLabel: barrierLabel,
//         useSafeArea: useSafeArea,
//         themes: themes,
//       );
// }
//
// class BottomSheet<T> extends Page<T> {
//   final Offset? anchorPoint;
//   final Color? barrierColor;
//   final Color? backgroundColor;
//   final bool barrierDismissible;
//   final String? barrierLabel;
//   final bool useSafeArea;
//   final CapturedThemes? themes;
//   final bool isScrollControlled;
//   final Widget child;
//
//   const BottomSheet({
//     required this.child,
//     this.anchorPoint,
//     this.backgroundColor = Colors.transparent,
//     this.barrierColor = Colors.transparent,
//     this.barrierDismissible = true,
//     this.barrierLabel,
//     this.useSafeArea = true,
//     this.isScrollControlled = false,
//     this.themes,
//     super.key,
//     super.name,
//     super.arguments,
//     super.restorationId,
//   });
//
//   @override
//   Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
//         settings: this,
//         isScrollControlled: isScrollControlled,
//         builder: (context) => child,
//         anchorPoint: anchorPoint,
//         barrierLabel: barrierLabel,
//         useSafeArea: useSafeArea,
//         backgroundColor: backgroundColor,
//       );
// }
