part of 'outline_course_bloc.dart';

@freezed
sealed class OutlineCourseState with _$OutlineCourseState {
  const factory OutlineCourseState.loading(bool isLoading) = _OutlineCourseLoading;
  const factory OutlineCourseState.error(bool isLoading, String message) = _OutlineCourseError;
  const factory OutlineCourseState.success(bool isLoading, OutlineCourseModel data) = _OutlineCourseSuccess;
}
