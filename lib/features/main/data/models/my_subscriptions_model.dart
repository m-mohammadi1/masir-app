import 'package:mohammad/features/main/data/models/courses_model.dart';

import '/features/main/domain/entities/my_subscriptions.dart';

class MySubscriptionsModel extends MySubscriptionsEntity {
  const MySubscriptionsModel({
    super.id,
    super.courseId,
    super.courseProgressPercent,
    super.coursesModel,
  });

  @override
  MySubscriptionsModel fromJson(Map<String, dynamic> json) {
    return MySubscriptionsModel(
      id: json['id'],
      courseId: json['course_id'],
      courseProgressPercent: json['course_progress_percent'],
      coursesModel: CoursesModel.fromJson(json['course'])
    );
  }
}
