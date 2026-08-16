import '/features/main/domain/entities/courses.dart';
import '/features/teacher/data/models/teacher_model.dart';

class CoursesModel extends CoursesEntity {
  const CoursesModel({
    super.id,
    super.instituteId,
    super.title,
    super.description,
    super.coverUrl,
    super.price,
    super.publishedAt,
    super.teachers,
    super.intro,
    super.level,
    super.outcomes,
    super.requirements,
    super.previewUnitCount,
    super.topic,
    super.totalDurationSeconds,
    super.enrolledCount,
    super.isSubscribed,
    super.institute,
  });

  static List<String> _stringList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
  }

  static CourseTopic? _topic(dynamic raw) {
    if (raw is! Map) return null;
    return CourseTopic(
      id: raw['id']?.toString(),
      slug: raw['slug']?.toString(),
      name: raw['name']?.toString(),
    );
  }

  static CourseInstituteSummary? _institute(dynamic raw) {
    if (raw is! Map) return null;
    return CourseInstituteSummary(
      id: raw['id']?.toString(),
      name: raw['name']?.toString(),
      coverUrl: raw['cover_url']?.toString(),
    );
  }

  @override
  CoursesModel fromJson(Map<String, dynamic> json) => CoursesModel.fromJson(json);

  factory CoursesModel.fromJson(Map<String, dynamic> json) {
    return CoursesModel(
      id: json['id'],
      instituteId: json['institute_id'],
      title: json['title'],
      description: json['description'],
      coverUrl: json['cover_url'],
      price: json['price'],
      publishedAt: json['published_at'],
      teachers: parseCourseTeachers(json['teachers']),
      intro: json['intro']?.toString(),
      level: json['level']?.toString(),
      outcomes: _stringList(json['outcomes']),
      requirements: _stringList(json['requirements']),
      previewUnitCount: json['preview_unit_count'] as int?,
      topic: _topic(json['topic']),
      totalDurationSeconds: json['total_duration_seconds'] as int?,
      enrolledCount: json['enrolled_count'] as int?,
      isSubscribed: json['is_subscribed'] as bool?,
      institute: _institute(json['institute']),
    );
  }
}
