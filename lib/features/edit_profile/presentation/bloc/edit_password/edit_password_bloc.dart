import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/edit_password_usecase.dart';
import '/features/edit_profile/data/models/edit_password_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_edit_password_model.dart';

part 'edit_password_event.dart';
part 'edit_password_state.dart';
part 'edit_password_bloc.freezed.dart';

@injectable
class EditPasswordBloc extends Bloc<EditPasswordEvent, EditPasswordState> {
  final EditPasswordUseCase editPasswordUseCase;

  EditPasswordBloc({required this.editPasswordUseCase})
      : super(const EditPasswordState.loading(false)) {
    on<EditPasswordEvent>(_onEditPasswordEvent);
  }

  void _onEditPasswordEvent(EditPasswordEvent event, emit) async {
    await event.when(
      editPassword: (params) async{
       emit(const EditPasswordState.loading(true));
       var data = await editPasswordUseCase(params: params);
       data.fold(
         (failure) {
           emit(EditPasswordState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(EditPasswordState.success(false, cast<EditPasswordModel>(data)));
         },
        );
      },
    );
  }
}
