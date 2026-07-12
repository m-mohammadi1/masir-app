import 'package:easy_helper/easy_helper.dart';

abstract class QuizSubmitResultEntity extends BaseResult {
  final String? questionId;
  final bool? correct;

  const QuizSubmitResultEntity({
    this.questionId,
    this.correct,
  });

  @override
  List<Object?> get props => [questionId, correct];
}

abstract class QuizSubmitResponseEntity extends BaseResult {
  final int? score;
  final bool? passed;
  final String? status;
  final List<QuizSubmitResultEntity>? results;

  const QuizSubmitResponseEntity({
    this.score,
    this.passed,
    this.status,
    this.results,
  });

  @override
  List<Object?> get props => [score, passed, status, results];
}
