part of 'quiz_submit_bloc.dart';

@freezed
sealed class QuizSubmitState with _$QuizSubmitState {
  const factory QuizSubmitState.loading(bool isLoading) = _QuizSubmitLoading;
  const factory QuizSubmitState.error(bool isLoading, String message) = _QuizSubmitError;
  const factory QuizSubmitState.success(
    bool isLoading,
    QuizSubmitResponseModel data,
  ) = _QuizSubmitSuccess;
}
