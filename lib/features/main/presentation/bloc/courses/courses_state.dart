part of 'courses_bloc.dart';

@freezed
sealed class CoursesState with _$CoursesState {
  const factory CoursesState.loading(bool isLoading) = _CoursesLoading;
  const factory CoursesState.error(bool isLoading, String message) = _CoursesError;
  const factory CoursesState.success(bool isLoading, List<CoursesModel> data) = _CoursesSuccess;
}
