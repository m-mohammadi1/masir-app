import 'dart:async';

import 'package:flutter/services.dart';

import '/core/services/hive_service.dart';

/// The small physical nudges that make taps and wins feel real. Every call is
/// a no-op when the student turned haptics off in the profile.
class MasirFeedback {
  const MasirFeedback._();

  /// Whether haptics are on. Tests can replace it.
  static bool Function() isEnabled = _fromSettings;

  static bool _fromSettings() {
    try {
      return HiveService.hapticsEnabled;
    } catch (_) {
      // Settings are not opened yet (early start-up or a plain widget test).
      return true;
    }
  }

  static void _run(Future<void> Function() haptic) {
    if (!isEnabled()) return;
    unawaited(haptic().catchError((_) {}));
  }

  /// A light press, for buttons and rows.
  static void tap() => _run(HapticFeedback.lightImpact);

  /// A click when an option is picked.
  static void select() => _run(HapticFeedback.selectionClick);

  /// A medium thud for something done: a unit, joining a course.
  static void success() => _run(HapticFeedback.mediumImpact);

  /// A heavy hit and an echo, for a passed quiz or a finished path.
  static void celebrate() {
    _run(HapticFeedback.heavyImpact);
    if (!isEnabled()) return;
    Timer(
      const Duration(milliseconds: 120),
      () => _run(HapticFeedback.lightImpact),
    );
  }
}
