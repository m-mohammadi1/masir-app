part of 'institute_detail_bloc.dart';

@freezed
sealed class InstituteDetailEvent with _$InstituteDetailEvent {
  const factory InstituteDetailEvent.load({RequestInstituteIdModel? params}) =
      _OnLoad;
  const factory InstituteDetailEvent.markJoined() = _OnMarkJoined;
}
