import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/usecases/quiz_usecase.dart';
import '/features/quiz/data/models/quiz_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/request_quiz_model.dart';

part 'quiz_event.dart';

part 'quiz_state.dart';

part 'quiz_bloc.freezed.dart';

@injectable
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizUseCase quizUseCase;

  QuizBloc({required this.quizUseCase})
    : super(const QuizState.loading(step: 0, isLoading: false)) {
    on<QuizEvent>(_onQuizEvent);
  }

  bool get isLastItem => state.step == 4; // state.

  void _onQuizEvent(QuizEvent event, emit) async {
    await event.when(
      quiz: (params) async {
        emit(QuizState.loading(isLoading: true, step: state.step));
        var data = await quizUseCase(params: params);
        data.fold(
          (failure) {
            emit(
              QuizState.error(
                isLoading: false,
                step: state.step,
                message: failure.message,
              ),
            );
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(
              QuizState.success(
                isLoading: false,
                step: state.step,
                data: cast<QuizModel>(data),
              ),
            );
          },
        );
      },
      changeStep: (value) {
        emit(QuizState.loading(isLoading: state.isLoading, step: state.step));
        emit(QuizState.changeIndex(isLoading: state.isLoading, step: state.step));
      },
    );
  }
}
