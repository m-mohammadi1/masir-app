part of 'edit_password_bloc.dart';

@freezed
sealed class EditPasswordState with _$EditPasswordState {
  const factory EditPasswordState.loading(bool isLoading) = _EditPasswordLoading;
  const factory EditPasswordState.error(bool isLoading, String message) = _EditPasswordError;
  const factory EditPasswordState.success(bool isLoading, EditPasswordModel data) = _EditPasswordSuccess;
}
