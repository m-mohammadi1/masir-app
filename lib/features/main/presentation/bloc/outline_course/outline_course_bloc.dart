import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/outline_course_usecase.dart';
import '/features/main/data/models/outline_course_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_outline_course_model.dart';

part 'outline_course_event.dart';
part 'outline_course_state.dart';
part 'outline_course_bloc.freezed.dart';

@injectable
class OutlineCourseBloc extends Bloc<OutlineCourseEvent, OutlineCourseState> {
  final OutlineCourseUseCase outlineCourseUseCase;

  OutlineCourseBloc({required this.outlineCourseUseCase})
      : super(const OutlineCourseState.loading(false)) {
    on<OutlineCourseEvent>(_onOutlineCourseEvent);
  }

  void _onOutlineCourseEvent(OutlineCourseEvent event, emit) async {
    await event.when(
      outlineCourse: (params) async{
       emit(const OutlineCourseState.loading(true));
       var data = await outlineCourseUseCase(params: params);
       data.fold(
         (failure) {
           emit(OutlineCourseState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(OutlineCourseState.success(false, cast<OutlineCourseModel>(data)));
         },
        );
      },
    );
  }
}
