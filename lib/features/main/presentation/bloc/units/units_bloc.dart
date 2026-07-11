import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/units_usecase.dart';
import '/features/main/data/models/units_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_units_model.dart';

part 'units_event.dart';
part 'units_state.dart';
part 'units_bloc.freezed.dart';

@injectable
class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  final UnitsUseCase unitsUseCase;

  UnitsBloc({required this.unitsUseCase})
      : super(const UnitsState.loading(false)) {
    on<UnitsEvent>(_onUnitsEvent);
  }

  void _onUnitsEvent(UnitsEvent event, emit) async {
    await event.when(
      units: (params) async{
       emit(const UnitsState.loading(true));
       var data = await unitsUseCase(params: params);
       data.fold(
         (failure) {
           emit(UnitsState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(UnitsState.success(false, cast<UnitsModel>(data)));
         },
        );
      },
    );
  }
}
