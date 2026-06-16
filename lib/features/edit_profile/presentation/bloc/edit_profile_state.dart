part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState.loading(bool isLoading) = _EditProfileLoading;
  const factory EditProfileState.error(bool isLoading, String message) = _EditProfileError;
  const factory EditProfileState.success(bool isLoading, EditProfileModel data) = _EditProfileSuccess;
}
