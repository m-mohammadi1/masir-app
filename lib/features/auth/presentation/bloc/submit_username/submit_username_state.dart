part of 'submit_username_bloc.dart';

@freezed
sealed class SubmitUsernameState with _$SubmitUsernameState {
  const factory SubmitUsernameState.loading(bool isLoading) = _SubmitUsernameLoading;
  const factory SubmitUsernameState.error(bool isLoading, String message) = _SubmitUsernameError;
  const factory SubmitUsernameState.success(bool isLoading, UserModel data) = _SubmitUsernameSuccess;
}
