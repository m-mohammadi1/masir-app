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
    return CourseDetailModel(
      coursesModel: CoursesModel.fromJson(json),
      moduleCount: json['outline']['module_count'],
      pathCount: json['outline']['path_count'],
      unitCount: json['outline']['unit_count'],
      teachers: parseCourseTeachers(json['teachers']),
    );
  }
}
