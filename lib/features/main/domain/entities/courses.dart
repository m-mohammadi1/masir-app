import 'package:easy_helper/easy_helper.dart';

import '/features/teacher/domain/entities/teacher.dart';

class CourseTopic {
  final String? id;
  final String? slug;
  final String? name;

  const CourseTopic({this.id, this.slug, this.name});
}

class CourseInstituteSummary {
  final String? id;
  final String? name;
  final String? coverUrl;

  const CourseInstituteSummary({this.id, this.name, this.coverUrl});
}

abstract class CoursesEntity extends BaseResult {
  final String? id;
  final String? instituteId;
  final String? title;
  final String? description;
  final String? coverUrl;
  final int? price;
  final String? publishedAt;
  final List<CourseTeacherSummary> teachers;
  final String? intro;
  final String? level;
  final List<String> outcomes;
  final List<String> requirements;
  final int? previewUnitCount;
  final CourseTopic? topic;
  final int? totalDurationSeconds;
  final int? enrolledCount;
  final bool? isSubscribed;
  final CourseInstituteSummary? institute;

  const CoursesEntity({
    this.id,
    this.instituteId,
    this.title,
    this.description,
    this.coverUrl,
    this.price,
    this.publishedAt,
    this.teachers = const [],
    this.intro,
    this.level,
    this.outcomes = const [],
    this.requirements = const [],
    this.previewUnitCount,
    this.topic,
    this.totalDurationSeconds,
    this.enrolledCount,
    this.isSubscribed,
    this.institute,
  });

  @override
  List<Object?> get props => [
        id,
        instituteId,
        title,
        description,
        coverUrl,
        price,
        publishedAt,
        teachers,
        intro,
        level,
        outcomes,
        requirements,
        previewUnitCount,
        topic,
        totalDurationSeconds,
        enrolledCount,
        isSubscribed,
        institute,
      ];
}
