part of 'my_institutes_bloc.dart';

@freezed
sealed class MyInstitutesState with _$MyInstitutesState {
  const factory MyInstitutesState.loading(bool isLoading) = _MyInstitutesLoading;
  const factory MyInstitutesState.error(bool isLoading, String message) = _MyInstitutesError;
  const factory MyInstitutesState.success(bool isLoading, List<MyInstitutesModel> data) = _MyInstitutesSuccess;
}
