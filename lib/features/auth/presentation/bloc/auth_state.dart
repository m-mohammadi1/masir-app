part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.loading(bool isLoading) = _AuthLoading;
  const factory AuthState.error(bool isLoading, String message) = _AuthError;
  const factory AuthState.success(bool isLoading, AuthModel data) = _AuthSuccess;
  const factory AuthState.refresh(bool isLoading) = _AuthRefresh;
}
