import '/features/main/domain/entities/course_detail.dart';
import '/features/teacher/data/models/teacher_model.dart';
import 'courses_model.dart';

class CourseDetailModel extends CourseDetailEntity {
  const CourseDetailModel({
    super.coursesModel,
    super.moduleCount,
    super.pathCount,
    super.unitCount,
    super.teachers,
  });

  @override
  CourseDetailModel fromJson(Map<String, dynamic> json) {
    final outline = json['outline'];
    return CourseDetailModel(
      coursesModel: CoursesModel.fromJson(json),
      moduleCount: outline is Map ? outline['module_count'] as int? : null,
      pathCount: outline is Map ? outline['path_count'] as int? : null,
      unitCount: outline is Map ? outline['unit_count'] as int? : null,
      teachers: parseCourseTeachers(json['teachers']),
    );
  }
}
