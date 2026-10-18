import 'masir_api.dart';
import 'models.dart';

/// Every app endpoint the redesigned screens use (backend `v1.app.go`).
extension AuthEndpoints on MasirApi {
  Future<Res<InvitePreview>> previewInvite(String code) => get(
    'auth/invite-codes/${Uri.encodeComponent(code.trim().toUpperCase())}',
    (d) => InvitePreview.fromJson(asMap(d)),
  );

  /// Sends the SMS code; returns the dev code when the server exposes it.
  Future<Res<String?>> sendRegisterCode(String inviteCode, String phone) =>
      post(
        'auth/register/send-code',
        (d) => strOrNull(asMap(d)['dev_code']),
        body: {'invite_code': inviteCode.trim().toUpperCase(), 'phone': phone},
      );

  Future<Res<({String token, Student student})>> register({
    required String inviteCode,
    required String phone,
    required String smsCode,
    required String password,
  }) => post(
    'auth/register',
    _auth,
    body: {
      'invite_code': inviteCode.trim().toUpperCase(),
      'phone': phone,
      'sms_code': smsCode,
      'password': password,
    },
  );

  Future<Res<({String token, Student student})>> login(
    String username,
    String password,
  ) => post(
    'auth/login',
    _auth,
    body: {'username': username.trim(), 'password': password},
  );

  Future<Res<UsernameCheck>> usernameAvailable(String username) => get(
    'auth/username-available',
    (d) => UsernameCheck.fromJson(asMap(d)),
    query: {'username': username},
  );

  Future<Res<Student>> setUsername(String username, String name) => post(
    'auth/username',
    (d) => Student.fromJson(asMap(d)),
    body: {'username': username, 'name': name},
  );

  Future<Res<String?>> sendResetCode(String phone) => post(
    'auth/forgot-password/send-code',
    (d) => strOrNull(asMap(d)['dev_code']),
    body: {'phone': phone},
  );

  Future<Res<void>> resetPassword(String phone, String code, String password) =>
      post(
        'auth/forgot-password/reset',
        (_) {},
        body: {'phone': phone, 'sms_code': code, 'password': password},
      );
}

({String token, Student student}) _auth(dynamic d) {
  final m = asMap(d);
  return (
    token: str(m['access_token']),
    student: Student.fromJson(asMap(m['student'])),
  );
}

extension MeEndpoints on MasirApi {
  Future<Res<Student>> me() =>
      get('me', (d) => Student.fromJson(asMap(asMap(d)['student'])));
  Future<Res<Student>> updateMe({String? name}) => patch(
    'me',
    (d) => Student.fromJson(asMap(asMap(d)['student'] ?? d)),
    body: {'name': ?name},
  );
  Future<Res<StudentStats>> stats() =>
      get('me/stats', (d) => StudentStats.fromJson(asMap(d)));
  Future<Res<List<WalletCard>>> wallet() =>
      get('me/institutes', (d) => asList(d).map(WalletCard.fromJson).toList());
  Future<Res<List<Subscription>>> subscriptions() => get(
    'me/subscriptions',
    (d) => items(d).map(Subscription.fromJson).toList(),
    query: {'per_page': 50},
  );
  Future<Res<List<Payment>>> payments() =>
      get('me/payments', (d) => asList(d).map(Payment.fromJson).toList());
  Future<Res<ReminderPrefs>> reminderPrefs() =>
      get('me/preferences', (d) => ReminderPrefs.fromJson(asMap(d)));
  Future<Res<ReminderPrefs>> setReminderPrefs(ReminderPrefs p) => put(
    'me/preferences',
    (d) => ReminderPrefs.fromJson(asMap(d)),
    body: p.toJson(),
  );
  Future<Res<void>> changePassword(String current, String next) => post(
    'auth/change-password',
    (_) {},
    body: {'current_password': current, 'new_password': next},
  );
}

extension DiscoveryEndpoints on MasirApi {
  Future<Res<MainFeed>> mainFeed() =>
      get('main', (d) => MainFeed.fromJson(asMap(d)));
  Future<Res<List<Topic>>> topics() => get(
    'topics',
    (d) => asList(
      d is Map ? d['items'] ?? d['topics'] : d,
    ).map(Topic.fromJson).toList(),
  );
  Future<Res<List<InstituteSummary>>> institutes({
    String? topic,
    bool excludeJoined = false,
  }) => get(
    'institutes',
    (d) => items(d).map(InstituteSummary.fromJson).toList(),
    query: {
      'per_page': 50,
      'topic': ?topic,
      if (excludeJoined) 'exclude_joined': '1',
    },
  );
  Future<Res<InstituteDetail>> institute(String id) =>
      get('institutes/$id', (d) => InstituteDetail.fromJson(asMap(d)));
  Future<Res<void>> joinInstitute(String id) =>
      post('institutes/$id/join', (_) {});
  Future<Res<void>> enterInstitute(String id) =>
      post('institutes/$id/enter', (_) {});
  Future<Res<InstituteMe>> instituteMe(String id) =>
      get('institutes/$id/me', (d) => InstituteMe.fromJson(asMap(d)));
  Future<Res<InstituteMe>> setInstitutePrefs(
    String id, {
    required bool announcements,
    required bool teacherMessages,
  }) => put(
    'institutes/$id/me/preferences',
    (d) => InstituteMe.fromJson(asMap(d)),
    body: {
      'notify_announcements': announcements,
      'notify_teacher_messages': teacherMessages,
    },
  );
  Future<Res<void>> leaveInstitute(String id) =>
      delete('institutes/$id/membership', (_) {});
  Future<Res<List<CourseCard>>> instituteCourses(String id) => get(
    'institutes/$id/courses',
    (d) => items(d).map(CourseCard.fromJson).toList(),
    query: {'per_page': 50},
  );
  Future<Res<InstituteHome>> instituteHome(String id) =>
      get('institutes/$id/home', (d) => InstituteHome.fromJson(asMap(d)));
  Future<Res<List<Teacher>>> instituteTeachers(String id) => get(
    'institutes/$id/teachers',
    (d) => (d is Map ? asList(d['items']) : asList(d))
        .map(Teacher.fromJson)
        .toList(),
  );
  Future<Res<TeacherPage>> teacher(String userId) =>
      get('teachers/$userId', (d) => TeacherPage.fromJson(asMap(d)));
  Future<Res<List<Announcement>>> announcements(String instituteId) => get(
    'institutes/$instituteId/announcements',
    (d) => items(d).map(Announcement.fromJson).toList(),
    query: {'per_page': 50},
  );
  Future<Res<Announcement>> announcement(String instituteId, String id) => get(
    'institutes/$instituteId/announcements/$id',
    (d) => Announcement.fromJson(asMap(d)),
  );
  Future<Res<CourseDetail>> course(String id) =>
      get('courses/$id', (d) => CourseDetail.fromJson(asMap(d)));
  Future<Res<void>> enroll(String courseId) =>
      post('courses/$courseId/subscribe', (_) {});
}

extension LearningEndpoints on MasirApi {
  Future<Res<Outline>> outline(String courseId) =>
      get('courses/$courseId/outline', (d) => Outline.fromJson(asMap(d)));
  Future<Res<UnitContent>> unit(String id) =>
      get('units/$id', (d) => UnitContent.fromJson(asMap(d)));
  Future<Res<ProgressUpdate?>> completeUnit(String id) => post(
    'units/$id/complete',
    (d) => ProgressUpdate.fromJson(asMap(d)['progress']),
  );

  /// [attemptId] stays the same when a failed submit is retried, so the
  /// server doesn't store the attempt twice.
  Future<Res<QuizResult>> submitQuiz(
    String id,
    List<({String questionId, Object answer})> answers, {
    String? attemptId,
  }) => post(
    'units/$id/quiz-submit',
    (d) => QuizResult.fromJson(asMap(d)),
    body: {
      'attempt_id': ?attemptId,
      'answers': [
        for (final a in answers)
          {'question_id': a.questionId, 'answer': a.answer},
      ],
    },
  );
  Future<Res<QuizReview>> quizReview(String id) =>
      get('units/$id/quiz-review', (d) => QuizReview.fromJson(asMap(d)));
}

extension InboxEndpoints on MasirApi {
  Future<Res<List<InboxItem>>> inbox() => get(
    'notifications',
    (d) => items(d).map(InboxItem.fromJson).toList(),
    query: {'per_page': 50},
  );
  Future<Res<int>> unreadCount() => get(
    'notifications/unread-count',
    (d) => toInt(asMap(d)['count'] ?? asMap(d)['unread_count']),
  );
  Future<Res<void>> markAllRead() => post('notifications/read-all', (_) {});
  Future<Res<void>> markRead(String id) =>
      post('notifications/$id/read', (_) {});
}

extension BillingEndpoints on MasirApi {
  Future<Res<Quote>> quote(String courseId, String plan, {String code = ''}) =>
      post(
        'courses/$courseId/checkout/quote',
        (d) => Quote.fromJson(asMap(d)),
        body: {'plan': plan, 'discount_code': code},
      );
  Future<Res<Payment>> checkout(
    String courseId,
    String plan, {
    String code = '',
    String? returnUnitId,
    String returnUrl = '',
  }) => post(
    'courses/$courseId/checkout',
    (d) => Payment.fromJson(asMap(d)),
    body: {
      'plan': plan,
      'discount_code': code,
      'return_unit_id': ?returnUnitId,
      'return_url': returnUrl,
    },
  );
  Future<Res<Payment>> payment(String id) =>
      get('payments/$id', (d) => Payment.fromJson(asMap(d)));
}
