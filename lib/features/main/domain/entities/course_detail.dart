import 'package:easy_helper/easy_helper.dart';

import '../../data/models/courses_model.dart';
import '/features/teacher/domain/entities/teacher.dart';

abstract class CourseDetailEntity extends BaseResult {
  final CoursesModel? coursesModel;
  final int? moduleCount;
  final int? pathCount;
  final int? unitCount;
  final List<CourseTeacherSummary> teachers;

  const CourseDetailEntity({
    this.coursesModel,
    this.moduleCount,
    this.pathCount,
    this.unitCount,
    this.teachers = const [],
  });

  @override
  List<Object?> get props => [
    coursesModel,
    moduleCount,
    pathCount,
    unitCount,
    teachers,
  ];
}
