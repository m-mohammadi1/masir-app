import '/features/main/domain/entities/subscribe_course.dart';

class SubscribeCourseModel extends SubscribeCourseEntity {
  const SubscribeCourseModel({
    super.id,
    super.courseId,
    super.courseProgressPercent,
  });

  @override
  SubscribeCourseModel fromJson(Map<String, dynamic> json) {
    return SubscribeCourseModel(
      id: json['id'],
      courseId: json['course_id'],
      courseProgressPercent: json['course_progress_percent'],
    );
  }
}
