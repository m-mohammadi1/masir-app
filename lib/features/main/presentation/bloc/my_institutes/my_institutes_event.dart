part of 'my_institutes_bloc.dart';

@freezed
sealed class MyInstitutesEvent with _$MyInstitutesEvent {
  const factory MyInstitutesEvent.myInstitutes({RequestMyInstitutesModel? params}) = _OnMyInstitutes;
}
