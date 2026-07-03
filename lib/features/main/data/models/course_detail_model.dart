import '/features/main/domain/entities/course_detail.dart';
import 'courses_model.dart';

class CourseDetailModel extends CourseDetailEntity {
  const CourseDetailModel({
    super.coursesModel,
    super.moduleCount,
    super.pathCount,
    super.unitCount,
  });

  @override
  CourseDetailModel fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      coursesModel: CoursesModel.fromJson(json),
      moduleCount: json['outline']['module_count'],
      pathCount: json['outline']['path_count'],
      unitCount: json['outline']['unit_count'],
    );
  }
}
