import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/teacher_model.dart';
import '../../../domain/usecases/get_institute_teachers.dart';
import '../../../../institute/data/models/request_institute_id_model.dart';

part 'institute_teachers_event.dart';
part 'institute_teachers_state.dart';
part 'institute_teachers_bloc.freezed.dart';

@injectable
class InstituteTeachersBloc
    extends Bloc<InstituteTeachersEvent, InstituteTeachersState> {
  final GetInstituteTeachersUseCase getInstituteTeachersUseCase;

  InstituteTeachersBloc({required this.getInstituteTeachersUseCase})
    : super(const InstituteTeachersState.loading(false)) {
    on<InstituteTeachersEvent>(_onEvent);
  }

  void _onEvent(InstituteTeachersEvent event, emit) async {
    await event.when(
      load: (params) async {
        emit(const InstituteTeachersState.loading(true));
        var data = await getInstituteTeachersUseCase(params: params);
        data.fold(
          (failure) {
            emit(InstituteTeachersState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(
              InstituteTeachersState.success(false, data.cast<TeacherModel>()),
            );
          },
        );
      },
    );
  }
}
