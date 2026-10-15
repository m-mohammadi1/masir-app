/// Paths of the redesigned app. Institute paths take the institute id,
/// detail paths the course/unit id.
class Routes {
  Routes._();

  static const splash = '/splash';
  static const intro = '/intro';
  static const register = '/register';
  static const welcome = '/welcome';
  static const login = '/login';

  // Masir space (3 tabs) and its pages.
  static const vitrine = '/vitrine';
  static const myInstitutes = '/my';
  static const profile = '/profile';
  static const explore = '/explore';
  static const inbox = '/inbox';
  static const subscriptions = '/subscriptions';

  // Institute space (4 tabs).
  static String threshold(String id) => '/enter/$id';
  static String instHome(String id) => '/i/$id/home';
  static String instCourses(String id) => '/i/$id/courses';
  static String instTeachers(String id) => '/i/$id/teachers';
  static String instMe(String id) => '/i/$id/me';
  static String announcements(String id) => '/i/$id/announcements';
  static String announcement(String id, String announcementId) => '/i/$id/announcements/$announcementId';
  static String teacher(String userId) => '/teachers/$userId';

  // Detail layer.
  static String course(String id) => '/course/$id';
  static String roadmap(String id) => '/course/$id/roadmap';
  static String unit(String id) => '/unit/$id';
  static String quizReview(String unitId) => '/unit/$unitId/review';
  static const payment = '/payment';
}
