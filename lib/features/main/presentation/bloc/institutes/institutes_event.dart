part of 'institutes_bloc.dart';

@freezed
sealed class InstitutesEvent with _$InstitutesEvent {
  const factory InstitutesEvent.institutes({RequestInstitutesModel? params}) = _OnInstitutes;
}
