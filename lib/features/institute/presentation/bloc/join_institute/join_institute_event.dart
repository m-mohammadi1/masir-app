part of 'join_institute_bloc.dart';

@freezed
sealed class JoinInstituteEvent with _$JoinInstituteEvent {
  const factory JoinInstituteEvent.join({RequestInstituteIdModel? params}) =
      _OnJoin;
}
