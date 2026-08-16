import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/request_teacher_id_model.dart';
import '../../../data/models/teacher_model.dart';
import '../../../domain/usecases/get_teacher.dart';

part 'teacher_detail_event.dart';
part 'teacher_detail_state.dart';
part 'teacher_detail_bloc.freezed.dart';

@injectable
class TeacherDetailBloc extends Bloc<TeacherDetailEvent, TeacherDetailState> {
  final GetTeacherUseCase getTeacherUseCase;

  TeacherDetailBloc({required this.getTeacherUseCase})
    : super(const TeacherDetailState.loading(false)) {
    on<TeacherDetailEvent>(_onEvent);
  }

  void _onEvent(TeacherDetailEvent event, emit) async {
    await event.when(
      load: (params) async {
        emit(const TeacherDetailState.loading(true));
        var data = await getTeacherUseCase(params: params);
        data.fold(
          (failure) {
            emit(TeacherDetailState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(
              TeacherDetailState.success(false, data as TeacherPageModel),
            );
          },
        );
      },
    );
  }
}
