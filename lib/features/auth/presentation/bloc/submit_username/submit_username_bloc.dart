import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/submit_username_usecase.dart';
import '/features/auth/data/models/submit_username_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_submit_username_model.dart';

part 'submit_username_event.dart';
part 'submit_username_state.dart';
part 'submit_username_bloc.freezed.dart';

@injectable
class SubmitUsernameBloc extends Bloc<SubmitUsernameEvent, SubmitUsernameState> {
  final SubmitUsernameUseCase submitUsernameUseCase;

  SubmitUsernameBloc({required this.submitUsernameUseCase})
      : super(const SubmitUsernameState.loading(false)) {
    on<SubmitUsernameEvent>(_onSubmitUsernameEvent);
  }

  void _onSubmitUsernameEvent(SubmitUsernameEvent event, emit) async {
    await event.when(
      submitUsername: (params) async{
       emit(const SubmitUsernameState.loading(true));
       var data = await submitUsernameUseCase(params: params);
       data.fold(
         (failure) {
           emit(SubmitUsernameState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(SubmitUsernameState.success(false, cast<UserModel>(data)));
         },
        );
      },
    );
  }
}
