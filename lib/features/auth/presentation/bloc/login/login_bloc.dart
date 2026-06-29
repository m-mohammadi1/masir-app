import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/login_usecase.dart';
import '/features/auth/data/models/login_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_login_model.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase})
      : super(const LoginState.loading(false)) {
    on<LoginEvent>(_onLoginEvent);
  }

  void _onLoginEvent(LoginEvent event, emit) async {
    await event.when(
      login: (params) async{
       emit(const LoginState.loading(true));
       var data = await loginUseCase(params: params);
       data.fold(
         (failure) {
           emit(LoginState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(LoginState.success(false, cast<LoginModel>(data)));
         },
        );
      },
    );
  }
}
