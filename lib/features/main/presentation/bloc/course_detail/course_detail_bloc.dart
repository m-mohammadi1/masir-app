import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/course_detail_usecase.dart';
import '/features/main/data/models/course_detail_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_course_detail_model.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';
part 'course_detail_bloc.freezed.dart';

@injectable
class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final CourseDetailUseCase courseDetailUseCase;

  CourseDetailBloc({required this.courseDetailUseCase})
      : super(const CourseDetailState.loading(false)) {
    on<CourseDetailEvent>(_onCourseDetailEvent);
  }

  void _onCourseDetailEvent(CourseDetailEvent event, emit) async {
    await event.when(
      courseDetail: (params) async{
       emit(const CourseDetailState.loading(true));
       var data = await courseDetailUseCase(params: params);
       data.fold(
         (failure) {
           emit(CourseDetailState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(CourseDetailState.success(false, cast<CourseDetailModel>(data)));
         },
        );
      },
    );
  }
}
