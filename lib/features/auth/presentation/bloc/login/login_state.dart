part of 'login_bloc.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.loading(bool isLoading) = _LoginLoading;
  const factory LoginState.error(bool isLoading, String message) = _LoginError;
  const factory LoginState.success(bool isLoading, LoginModel data) = _LoginSuccess;
}
