import 'package:flutter/foundation.dart';

import '/core/api/models.dart';
import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// The signed-in student and the space the app is in.
class Session {
  Session._();

  /// Cached profile, refreshed by the Vitrine and Profile.
  static final student = ValueNotifier<Student?>(null);

  /// Brand of the current space: Masir violet, or the institute entered last.
  /// Detail screens (course, roadmap, unit) keep this colour.
  static final space = ValueNotifier<Brand>(Brand.masir);

  /// Institute the student is in (null in the Masir space).
  static final instituteId = ValueNotifier<String?>(null);

  static Future<void> signIn(String token, Student s) async {
    HiveService.token = token;
    updateHeader();
    student.value = s;
  }

  static Future<void> signOut() async {
    await HiveService.logout();
    MasirStagger.reset();
    updateHeader();
    student.value = null;
    space.value = Brand.masir;
    instituteId.value = null;
  }

  static void enterInstitute(String id, Brand brand) {
    instituteId.value = id;
    space.value = brand;
  }

  static void exitToMasir() {
    instituteId.value = null;
    space.value = Brand.masir;
  }
}
