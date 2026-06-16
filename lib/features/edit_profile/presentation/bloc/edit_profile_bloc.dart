import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/usecases/edit_profile_usecase.dart';
import '/features/edit_profile/data/models/edit_profile_model.dart';
import '../../data/models/edit_profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/request_edit_profile_model.dart';


part 'edit_profile_event.dart';
part 'edit_profile_state.dart';
part 'edit_profile_bloc.freezed.dart';

@injectable
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileUseCase editProfileUseCase;

  EditProfileBloc({required this.editProfileUseCase})
      : super(const EditProfileState.loading(false)) {
    on<EditProfileEvent>(_onEditProfileEvent);
  }

  void _onEditProfileEvent(EditProfileEvent event, emit) async {
    await event.when(
      editProfile: (params) async{
       emit(const EditProfileState.loading(true));
       var data = await editProfileUseCase(params: params);
       data.fold(
         (failure) {
           emit(EditProfileState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(EditProfileState.success(false, cast<EditProfileModel>(data)));
         },
        );
      },
    );
  }
}
