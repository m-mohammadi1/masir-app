import 'package:easy_helper/easy_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/app/app.dart';
import '/app/state/error_recovery.dart';
import 'core/services/hive_service.dart';
import 'core/services/service_locator.dart';
import 'fcm.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> background(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FCMManager.init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A page that throws shows a way out instead of a blank screen.
  AppErrors.install();
  GEasyHelper.errorNetwork = 'به سرور وصل نشدیم! اینترنتت رو یه نگاه بنداز.';
  GEasyHelper.vpnError = 'فیلترشکن روشنه؛ یه بار خاموشش کن و دوباره امتحان کن.';

  await HiveService.init();
  await setup();
  // Debug web builds accept ?dev_token=… so screenshot tooling can sign in.
  final devToken = Uri.base.queryParameters['dev_token'];
  if (kDebugMode && kIsWeb && devToken != null && devToken.isNotEmpty) {
    HiveService.token = devToken;
    updateHeader();
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FCMManager.initial();
  } catch (_) {}

  FirebaseMessaging.onBackgroundMessage(background);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MasirApp());
}
