import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';

/// «تکمیل واحد آفلاین ذخیره و بعداً ارسال می‌شه»: completions that failed
/// for lack of a connection wait here and are sent on the next chance.
class OfflineQueue {
  OfflineQueue._();

  static bool _flushing = false;

  static void add(String unitId) {
    final ids = HiveService.pendingCompletions;
    if (!ids.contains(unitId)) {
      HiveService.pendingCompletions = [...ids, unitId];
    }
  }

  static bool get isEmpty => HiveService.pendingCompletions.isEmpty;

  /// Sends what's waiting; keeps only those that still can't reach the server.
  static Future<void> flush() async {
    if (_flushing || isEmpty || !HiveService.isLogged) return;
    _flushing = true;
    try {
      final api = inject<MasirApi>();
      final left = <String>[];
      for (final id in HiveService.pendingCompletions) {
        final r = await api.completeUnit(id);
        r.fold((e) {
          if (e.offline) left.add(id);
        }, (_) {});
      }
      HiveService.pendingCompletions = left;
    } finally {
      _flushing = false;
    }
  }
}
