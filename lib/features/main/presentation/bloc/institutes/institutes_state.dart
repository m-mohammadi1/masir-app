part of 'institutes_bloc.dart';

@freezed
sealed class InstitutesState with _$InstitutesState {
  const factory InstitutesState.loading(bool isLoading) = _InstitutesLoading;
  const factory InstitutesState.error(bool isLoading, String message) = _InstitutesError;
  const factory InstitutesState.success(bool isLoading, List<InstitutesModel> data) = _InstitutesSuccess;
}
