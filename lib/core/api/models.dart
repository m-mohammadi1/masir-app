import '/design/brand.dart';
import '/design/tokens.dart' show fa;
import '/design/palettes.dart';
import 'masir_api.dart';

// ---------------------------------------------------------------- identity

class Student {
  final String id;
  final String phone;
  final String? username;
  final String name;
  const Student({
    required this.id,
    required this.phone,
    this.username,
    required this.name,
  });

  factory Student.fromJson(J j) => Student(
    id: str(j['id']),
    phone: str(j['phone']),
    username: strOrNull(j['username']),
    name: str(j['name']),
  );

  String get firstName => name.trim().split(' ').first;
  String get initial => name.trim().isEmpty
      ? (username ?? '؟').substring(0, 1)
      : String.fromCharCode(name.trim().runes.first);
}

class InvitePreview {
  final String instituteId;
  final Brand brand;
  const InvitePreview(this.instituteId, this.brand);

  factory InvitePreview.fromJson(J j) {
    final inst = asMap(j['institute']);
    return InvitePreview(str(inst['id']), Brand.fromJson(inst));
  }
}

class UsernameCheck {
  final bool available;
  final List<String> suggestions;
  const UsernameCheck(this.available, this.suggestions);

  factory UsernameCheck.fromJson(J j) => UsernameCheck(
    toBool(j['available']),
    (j['suggestions'] as List? ?? []).map((e) => '$e').toList(),
  );
}

class StudentStats {
  final int streakDays;
  final bool activeToday;
  final List<WeekDay> week;
  final int completedUnits;
  final int trophies;
  const StudentStats({
    required this.streakDays,
    required this.activeToday,
    required this.week,
    required this.completedUnits,
    required this.trophies,
  });

  static const empty = StudentStats(
    streakDays: 0,
    activeToday: false,
    week: [],
    completedUnits: 0,
    trophies: 0,
  );

  factory StudentStats.fromJson(J j) => StudentStats(
    streakDays: toInt(j['streak_days']),
    activeToday: toBool(j['active_today']),
    week: asList(j['week']).map(WeekDay.fromJson).toList(),
    completedUnits: toInt(j['completed_units']),
    trophies: toInt(j['trophies']),
  );
}

class WeekDay {
  final DateTime date;
  final bool done;
  final bool today;
  const WeekDay(this.date, this.done, this.today);
  factory WeekDay.fromJson(J j) => WeekDay(
    DateTime.parse(str(j['date'])),
    toBool(j['done']),
    toBool(j['today']),
  );
}

// ---------------------------------------------------------------- courses

/// Subscription state of a course for the student.
enum AccessState { guest, freeCourse, trial, active, expiring, expired }

AccessState _accessState(String s) => switch (s) {
  'free_course' => AccessState.freeCourse,
  'trial' => AccessState.trial,
  'active' => AccessState.active,
  'expiring' => AccessState.expiring,
  'expired' => AccessState.expired,
  _ => AccessState.guest,
};

class CourseAccess {
  final AccessState state;
  final bool enrolled;
  final bool freeCourse;
  final bool paidActive;
  final String? plan;
  final DateTime? accessEndsAt;
  final int? daysLeft;

  const CourseAccess({
    this.state = AccessState.guest,
    this.enrolled = false,
    this.freeCourse = false,
    this.paidActive = false,
    this.plan,
    this.accessEndsAt,
    this.daysLeft,
  });

  factory CourseAccess.fromJson(J j) => CourseAccess(
    state: _accessState(str(j['state'])),
    enrolled: toBool(j['enrolled']),
    freeCourse: toBool(j['free_course']),
    paidActive: toBool(j['paid_active']),
    plan: strOrNull(j['plan']),
    accessEndsAt: date(j['access_ends_at']),
    daysLeft: j['days_left'] == null ? null : toInt(j['days_left']),
  );

  /// Every unit is open (free course joined, or paid window active).
  bool get fullAccess =>
      state == AccessState.freeCourse ||
      state == AccessState.active ||
      state == AccessState.expiring;
}

class CoursePlan {
  final String period;
  final int months;
  final int price;
  final int perMonth;
  final int savePercent;
  const CoursePlan({
    required this.period,
    required this.months,
    required this.price,
    required this.perMonth,
    required this.savePercent,
  });

  factory CoursePlan.fromJson(J j) => CoursePlan(
    period: str(j['period']),
    months: toInt(j['months']),
    price: toInt(j['price']),
    perMonth: toInt(j['per_month']),
    savePercent: toInt(j['save_percent']),
  );
}

class UnitRef {
  final String id;
  final String title;
  final String type;
  final int durationMinutes;
  final bool locked;
  final bool needsSubscription;
  const UnitRef({
    required this.id,
    required this.title,
    required this.type,
    this.durationMinutes = 0,
    this.locked = false,
    this.needsSubscription = false,
  });

  static UnitRef? fromJson(dynamic v) {
    if (v is! Map) return null;
    final j = asMap(v);
    return UnitRef(
      id: str(j['id']),
      title: str(j['title']),
      type: str(j['type']),
      durationMinutes: toInt(j['duration_minutes']),
      locked: toBool(j['locked']),
      needsSubscription: toBool(j['needs_subscription']),
    );
  }
}

class TeacherSummary {
  final String userId;
  final String name;
  final String photoUrl;
  final String headline;
  const TeacherSummary({
    required this.userId,
    required this.name,
    required this.photoUrl,
    required this.headline,
  });
  factory TeacherSummary.fromJson(J j) => TeacherSummary(
    userId: str(j['user_id']),
    name: str(j['name']),
    photoUrl: str(j['photo_url']),
    headline: str(j['headline']),
  );
}

/// A course as lists and cards show it.
class CourseCard {
  final String id;
  final String instituteId;
  final String title;
  final String description;
  final String coverUrl;
  final List<TeacherSummary> teachers;
  final List<CoursePlan> plans;
  final bool freeCourse;
  final int fromPerMonth;
  final int previewUnits;
  final int unitCount;
  final int moduleCount;
  final int durationMinutes;
  final String? level;
  final String introVideoUrl;
  final int introVideoSeconds;
  final CourseAccess access;
  final int progressPercent;
  final int completedUnits;
  final UnitRef? currentUnit;

  const CourseCard({
    required this.id,
    required this.instituteId,
    required this.title,
    this.description = '',
    this.coverUrl = '',
    this.teachers = const [],
    this.plans = const [],
    this.freeCourse = true,
    this.fromPerMonth = 0,
    this.previewUnits = 0,
    this.unitCount = 0,
    this.moduleCount = 0,
    this.durationMinutes = 0,
    this.level,
    this.introVideoUrl = '',
    this.introVideoSeconds = 0,
    this.access = const CourseAccess(),
    this.progressPercent = 0,
    this.completedUnits = 0,
    this.currentUnit,
  });

  factory CourseCard.fromJson(J j) => CourseCard(
    id: str(j['id']),
    instituteId: str(j['institute_id']),
    title: str(j['title']),
    description: str(j['description']),
    coverUrl: str(j['cover_url']),
    teachers: asList(j['teachers']).map(TeacherSummary.fromJson).toList(),
    plans: asList(j['plans']).map(CoursePlan.fromJson).toList(),
    freeCourse: j['free_course'] == null ? true : toBool(j['free_course']),
    fromPerMonth: toInt(j['from_per_month']),
    previewUnits: toInt(j['preview_units'] ?? j['preview_unit_count']),
    unitCount: toInt(j['unit_count']),
    moduleCount: toInt(j['module_count']),
    durationMinutes: toInt(j['duration_minutes']),
    level: strOrNull(j['course_level'] ?? j['level']),
    introVideoUrl: str(j['intro_video_url']),
    introVideoSeconds: toInt(j['intro_video_duration_seconds']),
    access: j['access'] is Map
        ? CourseAccess.fromJson(asMap(j['access']))
        : const CourseAccess(),
    progressPercent: toInt(j['progress_percent']),
    completedUnits: toInt(j['completed_units']),
    currentUnit: UnitRef.fromJson(j['current_unit']),
  );

  String get teacherLine {
    if (teachers.isEmpty) return '';
    if (teachers.length == 1) return teachers.first.name;
    return '${teachers.first.name} و ${fa(teachers.length - 1)} نفر دیگه';
  }
}

class CourseModuleSummary {
  final String id;
  final String title;
  final int pathCount;
  final int unitCount;
  final int freeUnits;
  final bool complete;
  const CourseModuleSummary({
    required this.id,
    required this.title,
    required this.pathCount,
    required this.unitCount,
    required this.freeUnits,
    required this.complete,
  });
  factory CourseModuleSummary.fromJson(J j) => CourseModuleSummary(
    id: str(j['id']),
    title: str(j['title']),
    pathCount: toInt(j['path_count']),
    unitCount: toInt(j['unit_count']),
    freeUnits: toInt(j['free_units']),
    complete: toBool(j['complete']),
  );
}

class CourseDetail {
  final CourseCard card;
  final String intro;
  final List<String> outcomes;
  final List<String> requirements;
  final int enrolledCount;
  final Brand instituteBrand;
  final List<CourseModuleSummary> modules;

  const CourseDetail({
    required this.card,
    required this.intro,
    required this.outcomes,
    required this.requirements,
    required this.enrolledCount,
    required this.instituteBrand,
    required this.modules,
  });

  factory CourseDetail.fromJson(J j) => CourseDetail(
    card: CourseCard.fromJson(j),
    intro: str(j['intro']),
    outcomes: (j['outcomes'] as List? ?? []).map((e) => '$e').toList(),
    requirements: (j['requirements'] as List? ?? []).map((e) => '$e').toList(),
    enrolledCount: toInt(j['enrolled_count']),
    instituteBrand: Brand.fromJson(asMap(j['institute'])),
    modules: asList(j['modules']).map(CourseModuleSummary.fromJson).toList(),
  );
}

// ---------------------------------------------------------------- outline

class OutlineUnit {
  final String id;
  final String title;
  final String type;
  final bool completed;
  final int? quizScore;
  final bool locked;
  final bool isPreview;
  final int durationMinutes;
  final int questionCount;
  const OutlineUnit({
    required this.id,
    required this.title,
    required this.type,
    required this.completed,
    this.quizScore,
    required this.locked,
    required this.isPreview,
    required this.durationMinutes,
    required this.questionCount,
  });
  factory OutlineUnit.fromJson(J j) => OutlineUnit(
    id: str(j['id']),
    title: str(j['title']),
    type: str(j['type']),
    completed: str(j['status']) == 'completed',
    quizScore: j['quiz_score'] == null ? null : toInt(j['quiz_score']),
    locked: toBool(j['locked']),
    isPreview: toBool(j['is_preview']),
    durationMinutes: toInt(j['duration_minutes']),
    questionCount: toInt(j['question_count']),
  );
}

class OutlinePath {
  final String id;
  final String title;
  final bool locked;
  final bool complete;
  final int progressPercent;
  final List<OutlineUnit> units;
  const OutlinePath({
    required this.id,
    required this.title,
    required this.locked,
    required this.complete,
    required this.progressPercent,
    required this.units,
  });
  factory OutlinePath.fromJson(J j) => OutlinePath(
    id: str(j['id']),
    title: str(j['title']),
    locked: toBool(j['locked']),
    complete: toBool(j['complete']),
    progressPercent: toInt(j['path_progress_percent']),
    units: asList(j['units']).map(OutlineUnit.fromJson).toList(),
  );
}

class OutlineModule {
  final String id;
  final String title;
  final bool locked;
  final bool complete;
  final List<OutlinePath> paths;
  const OutlineModule({
    required this.id,
    required this.title,
    required this.locked,
    required this.complete,
    required this.paths,
  });
  factory OutlineModule.fromJson(J j) => OutlineModule(
    id: str(j['id']),
    title: str(j['title']),
    locked: toBool(j['locked']),
    complete: toBool(j['complete']),
    paths: asList(j['paths']).map(OutlinePath.fromJson).toList(),
  );

  int get unitCount => paths.fold(0, (s, p) => s + p.units.length);
  int get completedCount =>
      paths.fold(0, (s, p) => s + p.units.where((u) => u.completed).length);
}

class Outline {
  final String id;
  final String title;
  final int progressPercent;
  final int previewUnitCount;
  final int completedUnits;
  final int totalUnits;
  final String? currentUnitId;
  final CourseAccess access;
  final List<CoursePlan> plans;
  final List<OutlineModule> modules;
  final List<TeacherSummary> teachers;

  const Outline({
    required this.id,
    required this.title,
    required this.progressPercent,
    required this.previewUnitCount,
    required this.completedUnits,
    required this.totalUnits,
    this.currentUnitId,
    required this.access,
    required this.plans,
    required this.modules,
    required this.teachers,
  });

  factory Outline.fromJson(J j) => Outline(
    id: str(j['id']),
    title: str(j['title']),
    progressPercent: toInt(j['course_progress_percent']),
    previewUnitCount: toInt(j['preview_unit_count']),
    completedUnits: toInt(j['completed_units']),
    totalUnits: toInt(j['total_units']),
    currentUnitId: strOrNull(j['current_unit_id']),
    access: CourseAccess.fromJson(asMap(j['access'])),
    plans: asList(j['plans']).map(CoursePlan.fromJson).toList(),
    modules: asList(j['modules']).map(OutlineModule.fromJson).toList(),
    teachers: asList(j['teachers']).map(TeacherSummary.fromJson).toList(),
  );

  Iterable<OutlineUnit> get units sync* {
    for (final m in modules) {
      for (final p in m.paths) {
        yield* p.units;
      }
    }
  }

  OutlineUnit? get currentUnit => currentUnitId == null
      ? null
      : units.where((u) => u.id == currentUnitId).firstOrNull;
}

// ---------------------------------------------------------------- units

class UnitContent {
  final String id;
  final String courseId;
  final String courseTitle;
  final String pathTitle;
  final String moduleTitle;
  final String title;
  final String type;
  final J payload;
  final bool completed;
  final int? quizScore;
  final List<TeacherSummary> teachers;
  final bool isPreview;
  final bool isLastPreview;
  final bool isSubscribed;
  final int previewIndex;
  final int previewCount;
  final int durationMinutes;
  final UnitRef? nextUnit;
  final int attemptCount;

  const UnitContent({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.pathTitle,
    required this.moduleTitle,
    required this.title,
    required this.type,
    required this.payload,
    required this.completed,
    this.quizScore,
    required this.teachers,
    required this.isPreview,
    required this.isLastPreview,
    required this.isSubscribed,
    required this.previewIndex,
    required this.previewCount,
    required this.durationMinutes,
    this.nextUnit,
    required this.attemptCount,
  });

  factory UnitContent.fromJson(J j) => UnitContent(
    id: str(j['id']),
    courseId: str(j['course_id']),
    courseTitle: str(j['course_title']),
    pathTitle: str(j['path_title']),
    moduleTitle: str(j['module_title']),
    title: str(j['title']),
    type: str(j['type']),
    payload: asMap(j['payload']),
    completed: str(j['status']) == 'completed',
    quizScore: j['quiz_score'] == null ? null : toInt(j['quiz_score']),
    teachers: asList(j['teachers']).map(TeacherSummary.fromJson).toList(),
    isPreview: toBool(j['is_preview']),
    isLastPreview: toBool(j['is_last_preview']),
    isSubscribed: toBool(j['is_subscribed']),
    previewIndex: toInt(j['preview_index']),
    previewCount: toInt(j['preview_count']),
    durationMinutes: toInt(j['duration_minutes']),
    nextUnit: UnitRef.fromJson(j['next_unit']),
    attemptCount: toInt(j['attempt_count']),
  );
}

class ProgressUpdate {
  final int courseProgressPercent;
  final int completedUnits;
  final int totalUnits;
  final bool pathCompleted;
  final String pathTitle;
  final String? nextPathTitle;
  final bool moduleCompleted;
  final String moduleTitle;
  final int moduleOrder;
  final int moduleCompletedUnits;
  final int moduleTotalUnits;
  final bool courseCompleted;
  final UnitRef? nextUnit;
  final bool firstCompletion;
  final int streakDays;

  const ProgressUpdate({
    required this.courseProgressPercent,
    required this.completedUnits,
    required this.totalUnits,
    required this.pathCompleted,
    required this.pathTitle,
    this.nextPathTitle,
    required this.moduleCompleted,
    required this.moduleTitle,
    required this.moduleOrder,
    required this.moduleCompletedUnits,
    required this.moduleTotalUnits,
    required this.courseCompleted,
    this.nextUnit,
    required this.firstCompletion,
    required this.streakDays,
  });

  static ProgressUpdate? fromJson(dynamic v) {
    if (v is! Map) return null;
    final j = asMap(v);
    return ProgressUpdate(
      courseProgressPercent: toInt(j['course_progress_percent']),
      completedUnits: toInt(j['completed_units']),
      totalUnits: toInt(j['total_units']),
      pathCompleted: toBool(j['path_completed']),
      pathTitle: str(j['path_title']),
      nextPathTitle: strOrNull(asMap(j['next_path'])['title']),
      moduleCompleted: toBool(j['module_completed']),
      moduleTitle: str(j['module_title']),
      moduleOrder: toInt(j['module_order']),
      moduleCompletedUnits: toInt(j['module_completed_units']),
      moduleTotalUnits: toInt(j['module_total_units']),
      courseCompleted: toBool(j['course_completed']),
      nextUnit: UnitRef.fromJson(j['next_unit']),
      firstCompletion: toBool(j['first_completion']),
      streakDays: toInt(j['streak_days']),
    );
  }
}

class QuizAttempt {
  final int number;
  final int percent;
  final int correct;
  final int total;
  final bool current;
  const QuizAttempt({
    required this.number,
    required this.percent,
    required this.correct,
    required this.total,
    required this.current,
  });
  factory QuizAttempt.fromJson(J j) => QuizAttempt(
    number: toInt(j['number']),
    percent: toInt(j['percent']),
    correct: toInt(j['correct']),
    total: toInt(j['total']),
    current: toBool(j['current']),
  );
}

class QuizResult {
  final int score;
  final int correct;
  final int total;
  final List<QuizAttempt> attempts;
  final ProgressUpdate? progress;
  const QuizResult({
    required this.score,
    required this.correct,
    required this.total,
    required this.attempts,
    this.progress,
  });
  factory QuizResult.fromJson(J j) => QuizResult(
    score: toInt(j['score']),
    correct: toInt(j['correct']),
    total: toInt(j['total']),
    attempts: asList(j['attempts']).map(QuizAttempt.fromJson).toList(),
    progress: ProgressUpdate.fromJson(j['progress']),
  );
}

class ReviewQuestion {
  final String id;
  final String type;
  final String text;
  final List<String> options;
  final bool? correctBool;
  final int? correctIndex;
  final bool? answerBool;
  final int? answerIndex;
  final bool correct;
  const ReviewQuestion({
    required this.id,
    required this.type,
    required this.text,
    required this.options,
    this.correctBool,
    this.correctIndex,
    this.answerBool,
    this.answerIndex,
    required this.correct,
  });
  factory ReviewQuestion.fromJson(J j) => ReviewQuestion(
    id: str(j['id']),
    type: str(j['type']),
    text: str(j['text']),
    options: (j['options'] as List? ?? []).map((e) => '$e').toList(),
    correctBool: j['correct_bool'] as bool?,
    correctIndex: j['correct_index'] == null ? null : toInt(j['correct_index']),
    answerBool: j['answer_bool'] as bool?,
    answerIndex: j['answer_index'] == null ? null : toInt(j['answer_index']),
    correct: toBool(j['correct']),
  );

  String answerText(bool? b, int? i) {
    if (type == 'true_false') return b == null ? '—' : (b ? 'درست' : 'نادرست');
    if (i == null || i < 0 || i >= options.length) return '—';
    return options[i];
  }
}

class QuizReview {
  final String unitId;
  final String unitTitle;
  final int score;
  final int correct;
  final int total;
  final List<QuizAttempt> attempts;
  final List<ReviewQuestion> questions;
  final UnitRef? reviewUnit;
  const QuizReview({
    required this.unitId,
    required this.unitTitle,
    required this.score,
    required this.correct,
    required this.total,
    required this.attempts,
    required this.questions,
    this.reviewUnit,
  });
  factory QuizReview.fromJson(J j) => QuizReview(
    unitId: str(j['unit_id']),
    unitTitle: str(j['unit_title']),
    score: toInt(j['score']),
    correct: toInt(j['correct']),
    total: toInt(j['total']),
    attempts: asList(j['attempts']).map(QuizAttempt.fromJson).toList(),
    questions: asList(j['questions']).map(ReviewQuestion.fromJson).toList(),
    reviewUnit: UnitRef.fromJson(j['review_unit']),
  );
}

// ---------------------------------------------------------------- institutes

class InstituteSummary {
  final String id;
  final String name;
  final String description;
  final Brand brand;
  final String topic;
  final int courseCount;
  final int teacherCount;
  final int studentCount;
  final bool isMember;

  const InstituteSummary({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    this.topic = '',
    this.courseCount = 0,
    this.teacherCount = 0,
    this.studentCount = 0,
    this.isMember = false,
  });

  factory InstituteSummary.fromJson(J j) => InstituteSummary(
    id: str(j['id']),
    name: str(j['name']),
    description: str(j['description']),
    brand: Brand.fromJson(j),
    topic: str(asMap(j['topic'])['name']),
    courseCount: toInt(j['course_count']),
    teacherCount: toInt(j['teacher_count']),
    studentCount: toInt(j['student_count']),
    isMember: toBool(j['is_member']),
  );
}

class InstituteDetail {
  final String id;
  final String name;
  final String description;
  final String intro;
  final Brand brand;
  final List<String> photos;
  final int? foundedYear;
  final List<({String kind, String url})> links;
  final String topic;
  final int courseCount;
  final int studentCount;
  final int teacherCount;
  final bool isMember;
  final DateTime? memberSince;

  const InstituteDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.intro,
    required this.brand,
    required this.photos,
    this.foundedYear,
    required this.links,
    required this.topic,
    required this.courseCount,
    required this.studentCount,
    required this.teacherCount,
    required this.isMember,
    this.memberSince,
  });

  factory InstituteDetail.fromJson(J j) => InstituteDetail(
    id: str(j['id']),
    name: str(j['name']),
    description: str(j['description']),
    intro: str(j['intro']),
    brand: Brand.fromJson(j),
    photos: asList(j['photos']).map((p) => str(p['url'])).toList(),
    foundedYear: j['founded_year'] == null ? null : toInt(j['founded_year']),
    links: asList(
      j['links'],
    ).map((l) => (kind: str(l['kind']), url: str(l['url']))).toList(),
    topic: str(asMap(j['topic'])['name']),
    courseCount: toInt(j['course_count']),
    studentCount: toInt(j['student_count']),
    teacherCount: toInt(j['teacher_count']),
    isMember: toBool(asMap(j['membership'])['is_member']),
    memberSince: date(asMap(j['membership'])['member_since']),
  );
}

/// "مؤسسات من" card.
class WalletCard {
  final InstituteSummary institute;
  final String coverUrl;
  final String photoUrl;
  final DateTime? memberSince;
  final bool learning;
  final String? nextUnitTitle;
  final String? nextUnitId;
  final String? courseTitle;
  final CourseCard? course;
  final int freshAnnouncements;
  final String? latestAnnouncementTitle;

  const WalletCard({
    required this.institute,
    required this.coverUrl,
    required this.photoUrl,
    this.memberSince,
    required this.learning,
    this.nextUnitTitle,
    this.nextUnitId,
    this.courseTitle,
    this.course,
    required this.freshAnnouncements,
    this.latestAnnouncementTitle,
  });

  factory WalletCard.fromJson(J j) {
    final inst = asMap(j['institute']);
    final next = asMap(j['next_action']);
    return WalletCard(
      institute: InstituteSummary.fromJson(inst),
      coverUrl: str(inst['cover_url']),
      photoUrl: str(inst['photo_url']),
      memberSince: date(j['member_since']),
      learning: str(j['segment']) == 'learning',
      nextUnitTitle: strOrNull(next['unit_title']),
      nextUnitId: strOrNull(next['unit_id']),
      courseTitle: strOrNull(next['course_title']),
      course: j['course'] is Map
          ? CourseCard.fromJson(asMap(j['course']))
          : null,
      freshAnnouncements: toInt(j['fresh_announcements']),
      latestAnnouncementTitle: strOrNull(j['latest_announcement_title']),
    );
  }
}

class InstituteMe {
  final bool member;
  final DateTime? memberSince;
  final bool notifyAnnouncements;
  final bool notifyTeacherMessages;
  final int progressPercent;
  final int completedUnits;
  final List<
    ({String courseTitle, String moduleTitle, int moduleOrder, bool earned})
  >
  trophies;
  final List<CourseCard> courses;

  const InstituteMe({
    required this.member,
    this.memberSince,
    required this.notifyAnnouncements,
    required this.notifyTeacherMessages,
    required this.progressPercent,
    required this.completedUnits,
    required this.trophies,
    required this.courses,
  });

  factory InstituteMe.fromJson(J j) => InstituteMe(
    member: toBool(j['member']),
    memberSince: date(j['member_since']),
    notifyAnnouncements: toBool(j['notify_announcements']),
    notifyTeacherMessages: toBool(j['notify_teacher_messages']),
    progressPercent: toInt(j['progress_percent']),
    completedUnits: toInt(j['completed_units']),
    trophies: asList(j['trophies'])
        .map(
          (t) => (
            courseTitle: str(t['course_title']),
            moduleTitle: str(t['module_title']),
            moduleOrder: toInt(t['module_order']),
            earned: toBool(t['earned'] ?? true),
          ),
        )
        .toList(),
    courses: asList(j['courses']).map(CourseCard.fromJson).toList(),
  );
}

class Teacher {
  final String userId;
  final String name;
  final String photoUrl;
  final String headline;
  final String bio;
  final List<({String id, String title})> courses;
  final List<({String kind, String url})> links;
  const Teacher({
    required this.userId,
    required this.name,
    required this.photoUrl,
    required this.headline,
    required this.bio,
    required this.courses,
    this.links = const [],
  });
  factory Teacher.fromJson(J j) => Teacher(
    userId: str(j['user_id']),
    name: str(j['name']),
    photoUrl: str(j['photo_url']),
    headline: str(j['headline']),
    bio: str(j['bio']),
    courses: asList(
      j['courses'],
    ).map((c) => (id: str(c['id']), title: str(c['title']))).toList(),
    links: asList(
      j['links'],
    ).map((l) => (kind: str(l['kind']), url: str(l['url']))).toList(),
  );
}

class TeacherPage {
  final Teacher teacher;
  final int? yearsExperience;
  final int studentCount;
  final List<CourseCard> courses;
  final List<InstituteSummary> institutes;
  const TeacherPage({
    required this.teacher,
    this.yearsExperience,
    required this.studentCount,
    required this.courses,
    required this.institutes,
  });
  factory TeacherPage.fromJson(J j) => TeacherPage(
    teacher: Teacher.fromJson(j),
    yearsExperience: j['years_experience'] == null
        ? null
        : toInt(j['years_experience']),
    studentCount: toInt(j['student_count']),
    courses: asList(j['courses']).map(CourseCard.fromJson).toList(),
    institutes: asList(j['institutes']).map(InstituteSummary.fromJson).toList(),
  );
}

class Announcement {
  final String id;
  final String instituteId;
  final String title;
  final String body;
  final String? courseTitle;
  final String? moduleTitle;
  final int moduleNumber;
  final String? courseId;
  final String authorName;
  final DateTime? publishedAt;
  final bool unread;
  const Announcement({
    required this.id,
    required this.instituteId,
    required this.title,
    required this.body,
    this.courseTitle,
    this.moduleTitle,
    required this.moduleNumber,
    this.courseId,
    required this.authorName,
    this.publishedAt,
    required this.unread,
  });
  factory Announcement.fromJson(J j) => Announcement(
    id: str(j['id']),
    instituteId: str(j['institute_id']),
    title: str(j['title']),
    body: str(j['body']),
    courseTitle: strOrNull(j['course_title']),
    moduleTitle: strOrNull(j['module_title']),
    moduleNumber: toInt(j['module_number']),
    courseId: strOrNull(j['course_id']),
    authorName: str(j['author_name']),
    publishedAt: date(j['published_at']),
    unread: toBool(j['is_unread']),
  );
}

class InboxItem {
  final String id;
  final String type;
  final J payload;
  final bool read;
  final DateTime? createdAt;
  const InboxItem({
    required this.id,
    required this.type,
    required this.payload,
    required this.read,
    this.createdAt,
  });
  factory InboxItem.fromJson(J j) => InboxItem(
    id: str(j['id']),
    type: str(j['type']),
    payload: asMap(j['payload']),
    read: j['read_at'] != null,
    createdAt: date(j['created_at']),
  );
}

class Topic {
  final String id;
  final String slug;
  final String name;
  const Topic(this.id, this.slug, this.name);
  factory Topic.fromJson(J j) =>
      Topic(str(j['id']), str(j['slug']), str(j['name']));
}

/// Course item of the main feed ("دوره‌های تازه").
class FeedCourse {
  final String id;
  final String title;
  final String coverUrl;
  final String instituteId;
  final String instituteName;
  final Brand brand;
  final int previewUnits;
  final bool freeCourse;
  final int fromPerMonth;
  final int introSeconds;
  const FeedCourse({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.instituteId,
    required this.instituteName,
    required this.brand,
    required this.previewUnits,
    required this.freeCourse,
    required this.fromPerMonth,
    required this.introSeconds,
  });
  factory FeedCourse.fromJson(J j) => FeedCourse(
    id: str(j['id']),
    title: str(j['title']),
    coverUrl: str(j['cover_url']),
    instituteId: str(j['institute_id']),
    instituteName: str(j['institute_name']),
    brand: Brand(
      palette: paletteFor(strOrNull(j['institute_palette'])),
      pattern: str(j['institute_pattern']).isEmpty
          ? 'dots'
          : str(j['institute_pattern']),
      frame: str(j['institute_logo_frame']).isEmpty
          ? 'squircle'
          : str(j['institute_logo_frame']),
      name: str(j['institute_name']),
      logoUrl: str(j['institute_logo_url']),
    ),
    previewUnits: toInt(j['preview_units']),
    freeCourse: j['free_course'] == null ? true : toBool(j['free_course']),
    fromPerMonth: toInt(j['from_per_month']),
    introSeconds: toInt(j['intro_video_duration_seconds']),
  );
}

class FeedActivity {
  final String title;
  final String courseId;
  final String instituteId;
  final String instituteName;
  final DateTime? createdAt;
  const FeedActivity({
    required this.title,
    required this.courseId,
    required this.instituteId,
    required this.instituteName,
    this.createdAt,
  });
  factory FeedActivity.fromJson(J j) => FeedActivity(
    title: str(j['title']),
    courseId: str(j['course_id']),
    instituteId: str(j['institute_id']),
    instituteName: str(j['institute_name']),
    createdAt: date(j['created_at']),
  );
}

class MainFeed {
  final List<InstituteSummary> recommended;
  final List<InstituteSummary> featuredInstitutes;
  final List<FeedCourse> newCourses;
  final List<FeedCourse> featuredCourses;
  final List<FeedActivity> activity;
  const MainFeed({
    this.recommended = const [],
    this.featuredInstitutes = const [],
    this.newCourses = const [],
    this.featuredCourses = const [],
    this.activity = const [],
  });

  factory MainFeed.fromJson(J j) {
    var feed = const MainFeed();
    for (final s in asList(j['sections'])) {
      final its = asList(s['items']);
      switch (str(s['kind'])) {
        case 'recommended_institutes':
          feed = feed._with(
            recommended: its.map(InstituteSummary.fromJson).toList(),
          );
        case 'featured_institutes':
          feed = feed._with(
            featuredInstitutes: its.map(InstituteSummary.fromJson).toList(),
          );
        case 'new_courses':
          feed = feed._with(newCourses: its.map(FeedCourse.fromJson).toList());
        case 'featured_courses':
          feed = feed._with(
            featuredCourses: its.map(FeedCourse.fromJson).toList(),
          );
        case 'institute_activity':
          feed = feed._with(activity: its.map(FeedActivity.fromJson).toList());
      }
    }
    return feed;
  }

  MainFeed _with({
    List<InstituteSummary>? recommended,
    List<InstituteSummary>? featuredInstitutes,
    List<FeedCourse>? newCourses,
    List<FeedCourse>? featuredCourses,
    List<FeedActivity>? activity,
  }) => MainFeed(
    recommended: recommended ?? this.recommended,
    featuredInstitutes: featuredInstitutes ?? this.featuredInstitutes,
    newCourses: newCourses ?? this.newCourses,
    featuredCourses: featuredCourses ?? this.featuredCourses,
    activity: activity ?? this.activity,
  );
}

// ---------------------------------------------------------------- billing

class Subscription {
  final String id;
  final CourseCard course;
  final InstituteSummary? institute;
  final int progressPercent;
  final int trophies;
  final List<DateTime> reminders;
  const Subscription({
    required this.id,
    required this.course,
    this.institute,
    required this.progressPercent,
    required this.trophies,
    required this.reminders,
  });
  factory Subscription.fromJson(J j) => Subscription(
    id: str(j['id']),
    course: CourseCard.fromJson(asMap(j['course'])),
    institute: j['institute'] is Map
        ? InstituteSummary.fromJson(asMap(j['institute']))
        : null,
    progressPercent: toInt(j['course_progress_percent']),
    trophies: toInt(j['trophies']),
    reminders: (j['reminders'] as List? ?? [])
        .map((e) => DateTime.parse('$e'))
        .toList(),
  );
}

class Quote {
  final String plan;
  final int months;
  final int listPrice;
  final int discountAmount;
  final int discountPercent;
  final String? discountCode;
  final int amount;
  final DateTime periodStartsAt;
  final DateTime periodEndsAt;
  final bool renewal;
  final List<DateTime> reminders;
  const Quote({
    required this.plan,
    required this.months,
    required this.listPrice,
    required this.discountAmount,
    required this.discountPercent,
    this.discountCode,
    required this.amount,
    required this.periodStartsAt,
    required this.periodEndsAt,
    required this.renewal,
    required this.reminders,
  });
  factory Quote.fromJson(J j) => Quote(
    plan: str(j['plan']),
    months: toInt(j['months']),
    listPrice: toInt(j['list_price']),
    discountAmount: toInt(j['discount_amount']),
    discountPercent: toInt(j['discount_percent']),
    discountCode: strOrNull(j['discount_code']),
    amount: toInt(j['amount']),
    periodStartsAt: date(j['period_starts_at']) ?? DateTime.now(),
    periodEndsAt: date(j['period_ends_at']) ?? DateTime.now(),
    renewal: toBool(j['renewal']),
    reminders: (j['reminders'] as List? ?? [])
        .map((e) => DateTime.parse('$e'))
        .toList(),
  );
}

class Payment {
  final String id;
  final String courseId;
  final String courseTitle;
  final String instituteId;
  final String plan;
  final int months;
  final int amount;
  final String status;
  final String trackingCode;
  final String bankMessage;
  final String? returnUnitId;
  final DateTime? accessEndsAt;
  final DateTime? createdAt;
  final int totalUnits;
  final int previewUnits;
  final List<DateTime> reminders;
  final String gatewayUrl;
  const Payment({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.instituteId,
    required this.plan,
    required this.months,
    required this.amount,
    required this.status,
    required this.trackingCode,
    required this.bankMessage,
    this.returnUnitId,
    this.accessEndsAt,
    this.createdAt,
    required this.totalUnits,
    required this.previewUnits,
    required this.reminders,
    required this.gatewayUrl,
  });
  factory Payment.fromJson(J j) => Payment(
    id: str(j['id']),
    courseId: str(j['course_id']),
    courseTitle: str(j['course_title']),
    instituteId: str(j['institute_id']),
    plan: str(j['plan']),
    months: toInt(j['months']),
    amount: toInt(j['amount']),
    status: str(j['status']),
    trackingCode: str(j['tracking_code']),
    bankMessage: str(j['bank_message']),
    returnUnitId: strOrNull(j['return_unit_id']),
    accessEndsAt: date(j['access_ends_at']),
    createdAt: date(j['created_at']),
    totalUnits: toInt(j['total_units']),
    previewUnits: toInt(j['preview_units']),
    reminders: (j['reminders'] as List? ?? [])
        .map((e) => DateTime.parse('$e'))
        .toList(),
    gatewayUrl: str(j['gateway_url']),
  );

  bool get paid => status == 'paid';
}

class ReminderPrefs {
  final bool push;
  final bool sms;
  const ReminderPrefs({required this.push, required this.sms});
  factory ReminderPrefs.fromJson(J j) => ReminderPrefs(
    push: j['reminder_push'] != false,
    sms: j['reminder_sms'] != false,
  );
  J toJson() => {'reminder_push': push, 'reminder_sms': sms};
}
