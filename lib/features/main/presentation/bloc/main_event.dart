part of 'main_bloc.dart';

@freezed
sealed class MainEvent with _$MainEvent {
  const factory MainEvent.main({RequestMainModel? params}) = _OnMain;
}
