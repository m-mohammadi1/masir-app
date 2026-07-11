part of 'units_bloc.dart';

@freezed
sealed class UnitsEvent with _$UnitsEvent {
  const factory UnitsEvent.units({RequestUnitsModel? params}) = _OnUnits;
}
