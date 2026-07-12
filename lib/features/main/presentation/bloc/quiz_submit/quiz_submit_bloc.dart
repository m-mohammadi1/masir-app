import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/quiz_submit_usecase.dart';
import '/features/main/data/models/quiz_submit_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_quiz_submit_model.dart';

part 'quiz_submit_event.dart';
part 'quiz_submit_state.dart';
part 'quiz_submit_bloc.freezed.dart';

@injectable
class QuizSubmitBloc extends Bloc<QuizSubmitEvent, QuizSubmitState> {
  final QuizSubmitUseCase quizSubmitUseCase;

  QuizSubmitBloc({required this.quizSubmitUseCase})
      : super(const QuizSubmitState.loading(false)) {
    on<QuizSubmitEvent>(_onQuizSubmitEvent);
  }

  void _onQuizSubmitEvent(QuizSubmitEvent event, emit) async {
    await event.when(
      quizSubmit: (params) async {
        emit(const QuizSubmitState.loading(true));
        var data = await quizSubmitUseCase(params: params);
        data.fold(
          (failure) {
            emit(QuizSubmitState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(
              QuizSubmitState.success(
                false,
                cast<QuizSubmitResponseModel>(data),
              ),
            );
          },
        );
      },
    );
  }
}
