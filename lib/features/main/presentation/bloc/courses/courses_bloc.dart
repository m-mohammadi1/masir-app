import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/courses_usecase.dart';
import '/features/main/data/models/courses_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_courses_model.dart';

part 'courses_event.dart';
part 'courses_state.dart';
part 'courses_bloc.freezed.dart';

@injectable
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CoursesUseCase coursesUseCase;

  CoursesBloc({required this.coursesUseCase})
    : super(const CoursesState.loading(false)) {
    on<CoursesEvent>(_onCoursesEvent);
  }

  void _onCoursesEvent(CoursesEvent event, emit) async {
    await event.when(
      courses: (params) async {
        emit(const CoursesState.loading(true));
        var data = await coursesUseCase(params: params);
        data.fold(
          (failure) {
            emit(CoursesState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(CoursesState.success(false, data.cast<CoursesModel>()));
          },
        );
      },
    );
  }
}
