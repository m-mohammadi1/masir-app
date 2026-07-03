import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/subscribe_course_usecase.dart';
import '/features/main/data/models/subscribe_course_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_subscribe_course_model.dart';

part 'subscribe_course_event.dart';
part 'subscribe_course_state.dart';
part 'subscribe_course_bloc.freezed.dart';

@injectable
class SubscribeCourseBloc extends Bloc<SubscribeCourseEvent, SubscribeCourseState> {
  final SubscribeCourseUseCase subscribeCourseUseCase;

  SubscribeCourseBloc({required this.subscribeCourseUseCase})
      : super(const SubscribeCourseState.loading(false)) {
    on<SubscribeCourseEvent>(_onSubscribeCourseEvent);
  }

  void _onSubscribeCourseEvent(SubscribeCourseEvent event, emit) async {
    await event.when(
      subscribeCourse: (params) async{
       emit(const SubscribeCourseState.loading(true));
       var data = await subscribeCourseUseCase(params: params);
       data.fold(
         (failure) {
           emit(SubscribeCourseState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(SubscribeCourseState.success(false, cast<SubscribeCourseModel>(data)));
         },
        );
      },
    );
  }
}
