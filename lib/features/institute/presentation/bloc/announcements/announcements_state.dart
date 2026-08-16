part of 'announcements_bloc.dart';

@freezed
sealed class AnnouncementsState with _$AnnouncementsState {
  const factory AnnouncementsState.loading(bool isLoading) = _AnnouncementsLoading;
  const factory AnnouncementsState.error(bool isLoading, String message) =
      _AnnouncementsError;
  const factory AnnouncementsState.success(
    bool isLoading,
    List<AnnouncementModel> items,
    bool hasMore,
    bool loadingMore,
  ) = _AnnouncementsSuccess;
}
