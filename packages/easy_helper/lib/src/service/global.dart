import 'package:flutter/material.dart';
import '../utils/custom_navigator.dart';
import 'retry.dart';

class GEasyHelper {
  static const String appVersion = "1.0.0";
  static late bool paid;

  /// Middleware Server
  static String errorNetwork =
      "اینترنتت قطعه یا ضعیفه، یه نگاه بنداز و دوباره امتحان کن";
  static String vpnError = "انگار فیلترشکنت روشنه، خاموشش کن و دوباره بیا";
  static String serverError = "Server is fail";
  static List<Function> retries = [];
  static bool timeOut = false;

  static bool check(int? statusCode) =>
      statusCode != null && statusCode >= 200 && statusCode < 300;


  static bool _pushed = true;

  static void initial() {
    _pushed = true;
    retries.clear();
  }

  static Widget background = Container();
  static Widget retryWidget = Container();
  static Widget backWidget = Container();
  static Widget body = Container();
  static Color? color;

  static void retry(
      String message,
      VoidCallback retry, {
        bool backAccess = false,
      }) {
    if (message.contains(GEasyHelper.errorNetwork)) {
      retries.add(retry);
      if (_pushed) {
        Navigator.push(
            CustomNavigator.context!,
            MaterialPageRoute(
              builder: (context) => RetryPage(
                backAccess: backAccess,
                retryWidget: retryWidget,
                backWidget: backWidget,
                background: background,
                body: body,
                backgroundColor: color,
              ),
            )).then((value) => _pushed = true);
        _pushed = false;
      }
    } else if (backAccess) {
      retries.add(retry);
      if (_pushed) {
        Navigator.push(
            CustomNavigator.context!,
            MaterialPageRoute(
              builder: (context) => RetryPage(
                backAccess: backAccess,
                retryWidget: retryWidget,
                backWidget: backWidget,
                background: background,
                body: body,
                backgroundColor: color,
              ),
            )).then((value) => _pushed = true);
        _pushed = false;
      }
    }
  }
}
