import 'package:easy_helper/easy_helper.dart';
import 'package:mohammad/features/main/data/models/courses_model.dart';

abstract class MySubscriptionsEntity extends BaseResult {
  final String? id;
  final String? courseId;
  final int? courseProgressPercent;
  final CoursesModel? coursesModel;

  const MySubscriptionsEntity({
    this.id,
    this.courseId,
    this.courseProgressPercent,
    this.coursesModel,
  });

  @override
  List<Object?> get props => [
    id,
    courseId,
    courseProgressPercent,
    coursesModel,
  ];
}
