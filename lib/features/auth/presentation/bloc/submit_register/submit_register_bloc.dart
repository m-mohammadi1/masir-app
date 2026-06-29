import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/submit_register_usecase.dart';
import '/features/auth/data/models/submit_register_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_submit_register_model.dart';

part 'submit_register_event.dart';
part 'submit_register_state.dart';
part 'submit_register_bloc.freezed.dart';

@injectable
class SubmitRegisterBloc extends Bloc<SubmitRegisterEvent, SubmitRegisterState> {
  final SubmitRegisterUseCase submitRegisterUseCase;

  SubmitRegisterBloc({required this.submitRegisterUseCase})
      : super(const SubmitRegisterState.loading(false)) {
    on<SubmitRegisterEvent>(_onSubmitRegisterEvent);
  }

  void _onSubmitRegisterEvent(SubmitRegisterEvent event, emit) async {
    await event.when(
      submitRegister: (params) async{
       emit(const SubmitRegisterState.loading(true));
       var data = await submitRegisterUseCase(params: params);
       data.fold(
         (failure) {
           emit(SubmitRegisterState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(SubmitRegisterState.success(false, cast<SubmitRegisterModel>(data)));
         },
        );
      },
    );
  }
}
