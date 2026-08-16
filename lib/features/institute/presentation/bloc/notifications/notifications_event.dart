part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.load() = _OnLoad;
  const factory NotificationsEvent.loadMore() = _OnLoadMore;
  const factory NotificationsEvent.markRead(String id) = _OnMarkRead;
}
