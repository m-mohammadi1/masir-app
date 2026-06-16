import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/usecases/auth_usecase.dart';
import '/features/auth/data/models/auth_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/request_auth_model.dart';


part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc({required this.authUseCase})
      : super(const AuthState.loading(false)) {
    on<AuthEvent>(_onAuthEvent);
  }

  void _onAuthEvent(AuthEvent event, emit) async {
    await event.when(
      auth: (params) async{
       emit(const AuthState.loading(true));
       var data = await authUseCase(params: params);
       data.fold(
         (failure) {
           emit(AuthState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(AuthState.success(false, cast<AuthModel>(data)));
         },
        );
      },
      refresh: () {
        emit(const AuthState.loading(false));
        emit(const AuthState.refresh(false));
      },
    );
  }
}
