part of 'intro_state_bloc.dart';

@freezed
sealed class IntroStateState with _$IntroStateState {
  const factory IntroStateState.changeState({required int state}) = _ChangeState;
}
