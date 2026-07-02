import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/usecases/main_usecase.dart';
import '/features/main/data/models/main_model.dart';
import '../../data/models/main_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/request_main_model.dart';


part 'main_event.dart';
part 'main_state.dart';
part 'main_bloc.freezed.dart';

@injectable
class MainBloc extends Bloc<MainEvent, MainState> {
  final MainUseCase mainUseCase;

  MainBloc({required this.mainUseCase})
      : super(const MainState.loading(false)) {
    on<MainEvent>(_onMainEvent);
  }

  void _onMainEvent(MainEvent event, emit) async {
    await event.when(
      main: (params) async{
       emit(const MainState.loading(true));
       var data = await mainUseCase(params: params);
       data.fold(
         (failure) {
           emit(MainState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(MainState.success(false, cast<MainModel>(data)));
         },
        );
      },
    );
  }
}
