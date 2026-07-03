import 'package:easy_helper/easy_helper.dart';

import '../../data/models/courses_model.dart';

abstract class CourseDetailEntity extends BaseResult {
  final CoursesModel? coursesModel;
  final int? moduleCount;
  final int? pathCount;
  final int? unitCount;

  const CourseDetailEntity({
    this.coursesModel,
    this.moduleCount,
    this.pathCount,
    this.unitCount,
  });

  @override
  List<Object?> get props => [coursesModel, moduleCount, pathCount, unitCount];
}
