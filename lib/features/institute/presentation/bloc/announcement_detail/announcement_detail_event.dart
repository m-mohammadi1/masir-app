part of 'announcement_detail_bloc.dart';

@freezed
sealed class AnnouncementDetailEvent with _$AnnouncementDetailEvent {
  const factory AnnouncementDetailEvent.load({
    required String instituteId,
    required String announcementId,
  }) = _OnLoad;
}
