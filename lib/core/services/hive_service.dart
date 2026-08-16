import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../features/auth/domain/entities/submit_username.dart';
import '/core/services/service_locator.dart';

class HiveService {
  HiveService._();

  static late Box _safeBox;
  static late Box _myDB;
  static late Box _userBox;

  /// User detail
  static const String _userKey = 'user_key';
  static const String _lnKey = 'ln_Key';
  static const String _themeKey = 'theme_key';
  static const String _fcmKey = 'fcm_token_key';
  static const String _tokenKey = 'token_key';
  static const String _refreshTokenKey = 'refresh_token_key';

  /// Current institute (the institute the student "feels" they're inside)
  static const String _instituteIdKey = 'current_institute_id_key';
  static const String _instituteNameKey = 'current_institute_name_key';
  static const String _instituteSlugKey = 'current_institute_slug_key';
  static const String _instituteLogoKey = 'current_institute_logo_key';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter<User?>(UserAdapter());

    _safeBox = await Hive.openBox("safeDB");
    _myDB = await Hive.openBox('myDB');
    _userBox = await Hive.openBox<User>(_userKey);
  }

  /// User detail
  static Stream<BoxEvent>? get userStream => _userBox.watch(key: _userKey);

  static User? get user => _userBox.get(_userKey);

  static Future<void> setUser(User? user) async {
    await _userBox.put(_userKey, user);
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

  /// CURRENT INSTITUTE
  ///
  /// The institute the student is currently "inside" — defaults to the
  /// institute they registered/joined with, changeable from Profile.
  static String? get currentInstituteId => _myDB.get(_instituteIdKey);

  static String? get currentInstituteName => _myDB.get(_instituteNameKey);

  static String? get currentInstituteSlug => _myDB.get(_instituteSlugKey);

  static String? get currentInstituteLogoUrl => _myDB.get(_instituteLogoKey);

  static bool get hasCurrentInstitute =>
      currentInstituteId != null && currentInstituteId!.isNotEmpty;

  static Future<void> setCurrentInstitute({
    required String id,
    String? name,
    String? slug,
    String? logoUrl,
  }) async {
    await _myDB.put(_instituteIdKey, id);
    await _myDB.put(_instituteNameKey, name ?? '');
    await _myDB.put(_instituteSlugKey, slug ?? '');
    await _myDB.put(_instituteLogoKey, logoUrl ?? '');
  }

  static Future<void> logout() async {
    await _myDB.clear();
    await _userBox.clear();
    updateHeader();
  }
}
