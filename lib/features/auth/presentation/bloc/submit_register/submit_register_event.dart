part of 'submit_register_bloc.dart';

@freezed
sealed class SubmitRegisterEvent with _$SubmitRegisterEvent {
  const factory SubmitRegisterEvent.submitRegister({RequestSubmitRegisterModel? params}) = _OnSubmitRegister;
}
