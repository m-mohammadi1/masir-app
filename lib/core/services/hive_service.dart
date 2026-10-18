import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    await _open(cipher: await _cipher());
  }

  static const String _boxKeyName = 'masir_box_key';

  /// The session box is encrypted with a key kept in the Android Keystore /
  /// iOS Keychain, so the token can't be read from the app's files or a
  /// backup. The web build (development and screenshots) stays plain.
  static Future<HiveCipher?> _cipher() async {
    if (kIsWeb) return null;
    const storage = FlutterSecureStorage();
    try {
      var key = await storage.read(key: _boxKeyName);
      if (key == null) {
        key = base64UrlEncode(Hive.generateSecureKey());
        await storage.write(key: _boxKeyName, value: key);
      }
      return HiveAesCipher(base64Url.decode(key));
    } catch (e) {
      debugPrint('secure storage unavailable: $e');
      return null;
    }
  }

  /// Opens the boxes in a plain directory, without Flutter plugins.
  @visibleForTesting
  static Future<void> initForTest(String path) async {
    Hive.init(path);
    await _open();
  }

  static Future<void> _open({HiveCipher? cipher}) async {
    _safeBox = await Hive.openBox("safeDB");
    if (cipher == null) {
      _myDB = await Hive.openBox('myDB');
      return;
    }
    try {
      _myDB = await Hive.openBox('myDB_secure', encryptionCipher: cipher);
    } catch (_) {
      // The key changed (e.g. restored from a backup): start signed out.
      await Hive.deleteBoxFromDisk('myDB_secure');
      _myDB = await Hive.openBox('myDB_secure', encryptionCipher: cipher);
    }
    // One-time move from the old plain box.
    if (await Hive.boxExists('myDB')) {
      final old = await Hive.openBox('myDB');
      if (_myDB.isEmpty) await _myDB.putAll(Map.of(old.toMap()));
      await old.deleteFromDisk();
    }
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
