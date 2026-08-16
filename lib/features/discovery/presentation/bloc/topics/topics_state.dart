part of 'topics_bloc.dart';

@freezed
sealed class TopicsState with _$TopicsState {
  const factory TopicsState.loading(bool isLoading) = _TopicsLoading;
  const factory TopicsState.error(bool isLoading, String message) = _TopicsError;
  const factory TopicsState.success(
    bool isLoading,
    List<DiscoveryTopicModel> items,
  ) = _TopicsSuccess;
}
