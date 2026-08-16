part of 'topics_bloc.dart';

@freezed
sealed class TopicsEvent with _$TopicsEvent {
  const factory TopicsEvent.load() = _OnLoad;
}
