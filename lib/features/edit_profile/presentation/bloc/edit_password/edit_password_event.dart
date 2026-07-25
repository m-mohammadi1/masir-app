part of 'edit_password_bloc.dart';

@freezed
sealed class EditPasswordEvent with _$EditPasswordEvent {
  const factory EditPasswordEvent.editPassword({RequestEditPasswordModel? params}) = _OnEditPassword;
}
