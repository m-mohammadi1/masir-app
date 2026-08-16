part of 'institute_teachers_bloc.dart';

@freezed
sealed class InstituteTeachersEvent with _$InstituteTeachersEvent {
  const factory InstituteTeachersEvent.load({
    RequestInstituteIdModel? params,
  }) = _OnLoad;
}
