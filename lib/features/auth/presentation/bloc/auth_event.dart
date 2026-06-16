part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.auth({RequestAuthModel? params}) = _OnAuth;
  const factory AuthEvent.refresh() = _OnRefresh;
}
