part of 'announcement_detail_bloc.dart';

@freezed
sealed class AnnouncementDetailState with _$AnnouncementDetailState {
  const factory AnnouncementDetailState.loading(bool isLoading) =
      _AnnouncementDetailLoading;
  const factory AnnouncementDetailState.error(bool isLoading, String message) =
      _AnnouncementDetailError;
  const factory AnnouncementDetailState.success(
    bool isLoading,
    AnnouncementModel data,
  ) = _AnnouncementDetailSuccess;
}
