part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading(bool isLoading) = _NotificationsLoading;
  const factory NotificationsState.error(bool isLoading, String message) =
      _NotificationsError;
  const factory NotificationsState.success(
    bool isLoading,
    List<AppNotificationModel> items,
    bool hasMore,
    bool loadingMore,
  ) = _NotificationsSuccess;
}
