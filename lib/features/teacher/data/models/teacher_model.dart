import '../../domain/entities/teacher.dart';

class CourseTeacherModel extends CourseTeacherSummary {
  const CourseTeacherModel({
    super.userId,
    super.name,
    super.photoUrl,
    super.headline,
  });

  factory CourseTeacherModel.fromJson(Map<String, dynamic> json) {
    return CourseTeacherModel(
      userId: json['user_id']?.toString(),
      name: json['name']?.toString(),
      photoUrl: json['photo_url']?.toString(),
      headline: json['headline']?.toString(),
    );
  }
}

List<CourseTeacherModel> parseCourseTeachers(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(CourseTeacherModel.fromJson)
      .toList();
}

class TeacherModel extends TeacherEntity {
  const TeacherModel({
    super.userId,
    super.name,
    super.photoUrl,
    super.headline,
    super.bio,
    super.links,
    super.courses,
  });

  @override
  TeacherModel fromJson(Map<String, dynamic> json) {
    return TeacherModel.fromMap(json);
  }

  factory TeacherModel.fromMap(Map<String, dynamic> json) {
    final linksRaw = json['links'];
    final coursesRaw = json['courses'];
    return TeacherModel(
      userId: json['user_id']?.toString(),
      name: json['name']?.toString(),
      photoUrl: json['photo_url']?.toString(),
      headline: json['headline']?.toString(),
      bio: json['bio']?.toString(),
      links: linksRaw is List
          ? linksRaw
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => TeacherLink(
                    kind: e['kind']?.toString(),
                    url: e['url']?.toString(),
                  ),
                )
                .toList()
          : const [],
      courses: coursesRaw is List
          ? coursesRaw
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => TeacherCourseSummary(
                    id: e['id']?.toString(),
                    title: e['title']?.toString(),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class TeacherPageModel extends TeacherPageEntity {
  const TeacherPageModel({
    super.userId,
    super.name,
    super.photoUrl,
    super.headline,
    super.bio,
    super.links,
    super.institutes,
  });

  @override
  TeacherPageModel fromJson(Map<String, dynamic> json) {
    final linksRaw = json['links'];
    final institutesRaw = json['institutes'];
    return TeacherPageModel(
      userId: json['user_id']?.toString(),
      name: json['name']?.toString(),
      photoUrl: json['photo_url']?.toString(),
      headline: json['headline']?.toString(),
      bio: json['bio']?.toString(),
      links: linksRaw is List
          ? linksRaw
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => TeacherLink(
                    kind: e['kind']?.toString(),
                    url: e['url']?.toString(),
                  ),
                )
                .toList()
          : const [],
      institutes: institutesRaw is List
          ? institutesRaw
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => TeacherInstitute(
                    id: e['id']?.toString(),
                    name: e['name']?.toString(),
                    slug: e['slug']?.toString(),
                    logoUrl: e['logo_url']?.toString(),
                  ),
                )
                .toList()
          : const [],
    );
  }
}
