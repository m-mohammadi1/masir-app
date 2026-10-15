import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '/core/services/service_locator.dart';

class HiveService {
  HiveService._();

  static late Box _safeBox;
  static late Box _myDB;

  static const String _lnKey = 'ln_Key';
  static const String _themeKey = 'theme_key';
  static const String _hapticsKey = 'haptics_key';
  static const String _fcmKey = 'fcm_token_key';
  static const String _tokenKey = 'token_key';
  static const String _refreshTokenKey = 'refresh_token_key';

  static Future<void> init() async {
    await Hive.initFlutter();
    await _open();
  }

  /// Opens the boxes in a plain directory, without Flutter plugins.
  @visibleForTesting
  static Future<void> initForTest(String path) async {
    Hive.init(path);
    await _open();
  }

  static Future<void> _open() async {
    _safeBox = await Hive.openBox("safeDB");
    _myDB = await Hive.openBox('myDB');
  }

  /// TOKEN AND REFRESH TOKEN
  static bool get isLogged => token != null;

  static String? get token => _myDB.get(_tokenKey);

  static set token(String? value) => _myDB.put(_tokenKey, value);

  static String? get refreshToken => _myDB.get(_refreshTokenKey);

  static set refreshToken(String? value) => _myDB.put(_refreshTokenKey, value);

  /// FCM TOKEN
  static String get fcmToken => _myDB.get(_fcmKey, defaultValue: "");

  static set fcmToken(String? value) {
    debugPrint("fcm token saver is: $value");
    if (value == null) return;
    _myDB.put(_fcmKey, value);
  }

  /// Language part
  static String? get ln => _safeBox.get(_lnKey, defaultValue: 'fa');

  static set ln(String? value) => _safeBox.put(_lnKey, value);

  static Stream<BoxEvent>? get languageStream => _safeBox.watch(key: _lnKey);

  /// Theme part
  static bool get isDarkMode =>
      _safeBox.get(_themeKey, defaultValue: false) ?? false;

  static set isDarkMode(bool value) => _safeBox.put(_themeKey, value);

  static Stream<bool> get theme {
    return _safeBox.watch(key: _themeKey).map((event) => event.value ?? false);
  }

  /// Haptic feedback on taps and wins (on by default).
  static bool get hapticsEnabled =>
      _safeBox.get(_hapticsKey, defaultValue: true) ?? true;

  static set hapticsEnabled(bool value) => _safeBox.put(_hapticsKey, value);

  /// Units finished while offline, sent when the app is back online.
  static const String _pendingKey = 'pending_completions_key';

  static List<String> get pendingCompletions =>
      (_myDB.get(_pendingKey, defaultValue: const <dynamic>[]) as List)
          .map((e) => '$e')
          .toList();

  static set pendingCompletions(List<String> ids) =>
      _myDB.put(_pendingKey, ids);

  static Future<void> logout() async {
    await _myDB.clear();
    updateHeader();
  }
}
