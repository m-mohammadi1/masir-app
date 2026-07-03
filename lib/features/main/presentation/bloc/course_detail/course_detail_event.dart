part of 'course_detail_bloc.dart';

@freezed
sealed class CourseDetailEvent with _$CourseDetailEvent {
  const factory CourseDetailEvent.courseDetail({RequestCourseDetailModel? params}) = _OnCourseDetail;
}
