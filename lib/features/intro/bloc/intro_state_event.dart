part of 'intro_state_bloc.dart';

@freezed
sealed class IntroStateEvent with _$IntroStateEvent {
  const factory IntroStateEvent.changeIndex({required int value}) = _ChangeIndex;
}
