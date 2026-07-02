part of 'main_bloc.dart';

@freezed
sealed class MainState with _$MainState {
  const factory MainState.loading(bool isLoading) = _MainLoading;
  const factory MainState.error(bool isLoading, String message) = _MainError;
  const factory MainState.success(bool isLoading, MainModel data) = _MainSuccess;
}
