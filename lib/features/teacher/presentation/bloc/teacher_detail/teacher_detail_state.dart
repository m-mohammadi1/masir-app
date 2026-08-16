part of 'teacher_detail_bloc.dart';

@freezed
sealed class TeacherDetailState with _$TeacherDetailState {
  const factory TeacherDetailState.loading(bool isLoading) =
      _TeacherDetailLoading;
  const factory TeacherDetailState.error(bool isLoading, String message) =
      _TeacherDetailError;
  const factory TeacherDetailState.success(
    bool isLoading,
    TeacherPageModel data,
  ) = _TeacherDetailSuccess;
}
