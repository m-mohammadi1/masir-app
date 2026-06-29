part of 'submit_register_bloc.dart';

@freezed
sealed class SubmitRegisterState with _$SubmitRegisterState {
  const factory SubmitRegisterState.loading(bool isLoading) = _SubmitRegisterLoading;
  const factory SubmitRegisterState.error(bool isLoading, String message) = _SubmitRegisterError;
  const factory SubmitRegisterState.success(bool isLoading, SubmitRegisterModel data) = _SubmitRegisterSuccess;
}
