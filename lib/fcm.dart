import 'package:easy_helper/easy_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/services/hive_service.dart';
import 'main.dart';

class FCMManager {
  static bool _isNotificationsInitialized = false;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel _channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static late FlutterLocalNotificationsPlugin _flutterLocalNotifications;

  /// Initials
  static Future<void> initial() async {
    FirebaseMessaging.onBackgroundMessage(background);
    if (!kIsWeb) {
      await init();
      FirebaseMessaging.instance.requestPermission();
      try {
        await FirebaseMessaging.instance.subscribeToTopic('All');
      } catch (e) {}
    }

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final fromPayload = message.data['institute_id']?.toString();
      final id = (fromPayload != null && fromPayload.isNotEmpty)
          ? fromPayload
          : HiveService.currentInstituteId;
      if (id != null && id.isNotEmpty) {
        CustomNavigator.go('/i/$id/home');
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      HiveService.fcmToken = event;
    });
  }

  static const _initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  static const _initializationSettingsIOS = DarwinInitializationSettings();

  static const _initializationSettings = InitializationSettings(
    android: _initializationSettingsAndroid,
    iOS: _initializationSettingsIOS,
  );

  static Future<void> init() async {
    if (_isNotificationsInitialized) return;

    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      showBadge: true,
    );

    _flutterLocalNotifications = FlutterLocalNotificationsPlugin();

    await _flutterLocalNotifications.initialize(settings: _initializationSettings);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _isNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      _flutterLocalNotifications.show(
        id:notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails:
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: 'app_icon',
            color: const Color(0xff323233),
            channelShowBadge: false,
          ),
        ),
      );
    }
  }

  /// Tokens
  static Future<String?> get token async {
    try {
      await FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          HiveService.fcmToken = token;
        }
        debugPrint("fcm token is : $token");
      });
      return HiveService.fcmToken;
    } catch (e) {}
  }

  FCMManager._();
}
