part of 'announcements_bloc.dart';

@freezed
sealed class AnnouncementsEvent with _$AnnouncementsEvent {
  const factory AnnouncementsEvent.load({
    required String instituteId,
    int? perPage,
  }) = _OnLoad;
  const factory AnnouncementsEvent.loadMore() = _OnLoadMore;
  const factory AnnouncementsEvent.markLocalRead(String announcementId) =
      _OnMarkLocalRead;
}
