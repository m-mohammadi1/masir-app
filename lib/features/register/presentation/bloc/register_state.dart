part of 'register_bloc.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState.loading(bool isLoading) = _RegisterLoading;
  const factory RegisterState.error(bool isLoading, String message) = _RegisterError;
  const factory RegisterState.success(bool isLoading, RegisterModel data) = _RegisterSuccess;
}
