import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/my_institutes_usecase.dart';
import '/features/main/data/models/my_institutes_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_my_institutes_model.dart';


part 'my_institutes_event.dart';
part 'my_institutes_state.dart';
part 'my_institutes_bloc.freezed.dart';

@injectable
class MyInstitutesBloc extends Bloc<MyInstitutesEvent, MyInstitutesState> {
  final MyInstitutesUseCase myInstitutesUseCase;

  MyInstitutesBloc({required this.myInstitutesUseCase})
      : super(const MyInstitutesState.loading(false)) {
    on<MyInstitutesEvent>(_onMyInstitutesEvent);
  }

  void _onMyInstitutesEvent(MyInstitutesEvent event, emit) async {
    await event.when(
      myInstitutes: (params) async{
       emit(const MyInstitutesState.loading(true));
       var data = await myInstitutesUseCase(params: params);
       data.fold(
         (failure) {
           emit(MyInstitutesState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(MyInstitutesState.success(false, data.cast<MyInstitutesModel>()));
         },
        );
      },
    );
  }
}
