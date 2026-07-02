part of 'submit_username_bloc.dart';

@freezed
sealed class SubmitUsernameEvent with _$SubmitUsernameEvent {
  const factory SubmitUsernameEvent.submitUsername({RequestSubmitUsernameModel? params}) = _OnSubmitUsername;
}
