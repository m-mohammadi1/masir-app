part of 'quiz_bloc.dart';

@freezed
sealed class QuizState with _$QuizState {
  const factory QuizState.loading({required bool isLoading, required int step}) = _QuizLoading;
  const factory QuizState.changeIndex({required bool isLoading, required int step}) = _ChangeIndex;
  const factory QuizState.error({required bool isLoading, required int step,required String message}) = _QuizError;
  const factory QuizState.success({required bool isLoading, required int step,required QuizModel data}) = _QuizSuccess;
}
