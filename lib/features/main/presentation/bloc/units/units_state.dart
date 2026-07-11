part of 'units_bloc.dart';

@freezed
sealed class UnitsState with _$UnitsState {
  const factory UnitsState.loading(bool isLoading) = _UnitsLoading;
  const factory UnitsState.error(bool isLoading, String message) = _UnitsError;
  const factory UnitsState.success(bool isLoading, UnitsModel data) = _UnitsSuccess;
}
