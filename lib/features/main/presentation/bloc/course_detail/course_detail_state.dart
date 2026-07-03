part of 'course_detail_bloc.dart';

@freezed
sealed class CourseDetailState with _$CourseDetailState {
  const factory CourseDetailState.loading(bool isLoading) = _CourseDetailLoading;
  const factory CourseDetailState.error(bool isLoading, String message) = _CourseDetailError;
  const factory CourseDetailState.success(bool isLoading, CourseDetailModel data) = _CourseDetailSuccess;
}
