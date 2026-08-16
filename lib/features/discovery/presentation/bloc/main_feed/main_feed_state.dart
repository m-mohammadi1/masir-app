part of 'main_feed_bloc.dart';

@freezed
sealed class MainFeedState with _$MainFeedState {
  const factory MainFeedState.loading(bool isLoading) = _MainFeedLoading;
  const factory MainFeedState.error(bool isLoading, String message) =
      _MainFeedError;
  const factory MainFeedState.success(
    bool isLoading,
    List<MainFeedSectionEntity> sections,
  ) = _MainFeedSuccess;
}
