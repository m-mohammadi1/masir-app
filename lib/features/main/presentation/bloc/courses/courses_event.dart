part of 'courses_bloc.dart';

@freezed
sealed class CoursesEvent with _$CoursesEvent {
  const factory CoursesEvent.courses({RequestCoursesModel? params}) = _OnCourses;
}
