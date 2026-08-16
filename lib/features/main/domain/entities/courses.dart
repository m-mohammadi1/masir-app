import 'package:easy_helper/easy_helper.dart';

import '/features/teacher/domain/entities/teacher.dart';

abstract class CoursesEntity extends BaseResult {
  final String? id;
  final String? instituteId;
  final String? title;
  final String? description;
  final String? coverUrl;
  final int? price;
  final String? publishedAt;
  final List<CourseTeacherSummary> teachers;

  const CoursesEntity({
    this.id,
    this.instituteId,
    this.title,
    this.description,
    this.coverUrl,
    this.price,
    this.publishedAt,
    this.teachers = const [],
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
  ];
}
