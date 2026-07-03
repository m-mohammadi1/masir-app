part of 'outline_course_bloc.dart';

@freezed
sealed class OutlineCourseEvent with _$OutlineCourseEvent {
  const factory OutlineCourseEvent.outlineCourse({RequestOutlineCourseModel? params}) = _OnOutlineCourse;
}
