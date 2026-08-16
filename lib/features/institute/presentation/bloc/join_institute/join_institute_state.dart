part of 'join_institute_bloc.dart';

@freezed
sealed class JoinInstituteState with _$JoinInstituteState {
  const factory JoinInstituteState.idle() = _JoinIdle;
  const factory JoinInstituteState.loading() = _JoinLoading;
  const factory JoinInstituteState.error(String message) = _JoinError;
  const factory JoinInstituteState.success() = _JoinSuccess;
}
