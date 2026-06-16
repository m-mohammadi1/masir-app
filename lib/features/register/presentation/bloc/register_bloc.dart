import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/usecases/register_usecase.dart';
import '/features/register/data/models/register_model.dart';
import '../../data/models/register_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/request_register_model.dart';


part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase})
      : super(const RegisterState.loading(false)) {
    on<RegisterEvent>(_onRegisterEvent);
  }

  void _onRegisterEvent(RegisterEvent event, emit) async {
    await event.when(
      register: (params) async{
       emit(const RegisterState.loading(true));
       var data = await registerUseCase(params: params);
       data.fold(
         (failure) {
           emit(RegisterState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(RegisterState.success(false, cast<RegisterModel>(data)));
         },
        );
      },
    );
  }
}
