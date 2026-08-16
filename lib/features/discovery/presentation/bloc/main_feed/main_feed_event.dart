part of 'main_feed_bloc.dart';

@freezed
sealed class MainFeedEvent with _$MainFeedEvent {
  const factory MainFeedEvent.load() = _OnLoad;
}
