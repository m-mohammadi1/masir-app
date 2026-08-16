part of 'institute_detail_bloc.dart';

@freezed
sealed class InstituteDetailState with _$InstituteDetailState {
  const factory InstituteDetailState.loading(bool isLoading) =
      _InstituteDetailLoading;
  const factory InstituteDetailState.error(bool isLoading, String message) =
      _InstituteDetailError;
  const factory InstituteDetailState.success(
    bool isLoading,
    InstituteDetailModel data,
  ) = _InstituteDetailSuccess;
}
