part of 'about_us_bloc.dart';

@freezed
sealed class AboutUsState with _$AboutUsState {
  const factory AboutUsState.loading(bool isLoading) = _AboutUsLoading;
  const factory AboutUsState.error(bool isLoading, String message) = _AboutUsError;
  const factory AboutUsState.success(bool isLoading, AboutUsModel data) = _AboutUsSuccess;
}
