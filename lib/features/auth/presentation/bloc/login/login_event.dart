part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.login({RequestLoginModel? params}) = _OnLogin;
}
