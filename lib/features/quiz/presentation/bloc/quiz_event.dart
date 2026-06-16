part of 'quiz_bloc.dart';

@freezed
sealed class QuizEvent with _$QuizEvent {
  const factory QuizEvent.quiz({RequestQuizModel? params}) = _OnQuiz;
  const factory QuizEvent.changeStep({required int value}) = _ChangeStepEvent;
}
