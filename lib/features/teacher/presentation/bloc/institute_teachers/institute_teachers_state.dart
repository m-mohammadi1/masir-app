part of 'institute_teachers_bloc.dart';

@freezed
sealed class InstituteTeachersState with _$InstituteTeachersState {
  const factory InstituteTeachersState.loading(bool isLoading) =
      _InstituteTeachersLoading;
  const factory InstituteTeachersState.error(bool isLoading, String message) =
      _InstituteTeachersError;
  const factory InstituteTeachersState.success(
    bool isLoading,
    List<TeacherModel> data,
  ) = _InstituteTeachersSuccess;
}
