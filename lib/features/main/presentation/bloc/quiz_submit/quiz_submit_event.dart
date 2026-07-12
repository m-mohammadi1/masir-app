part of 'quiz_submit_bloc.dart';

@freezed
sealed class QuizSubmitEvent with _$QuizSubmitEvent {
  const factory QuizSubmitEvent.quizSubmit({RequestQuizSubmitModel? params}) = _OnQuizSubmit;
}
