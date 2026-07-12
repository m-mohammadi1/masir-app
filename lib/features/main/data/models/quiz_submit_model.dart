import '/features/main/domain/entities/quiz_submit.dart';

class QuizSubmitResultModel extends QuizSubmitResultEntity {
  const QuizSubmitResultModel({
    super.questionId,
    super.correct,
  });

  factory QuizSubmitResultModel.fromJson(Map<String, dynamic> json) {
    return QuizSubmitResultModel(
      questionId: json['question_id'],
      correct: json['correct'],
    );
  }
}

class QuizSubmitResponseModel extends QuizSubmitResponseEntity {
  const QuizSubmitResponseModel({
    super.score,
    super.passed,
    super.status,
    super.results,
  });

  @override
  QuizSubmitResponseModel fromJson(Map<String, dynamic> json) {
    return QuizSubmitResponseModel(
      score: json['score'],
      passed: json['passed'],
      status: json['status'],
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => QuizSubmitResultModel.fromJson(e))
          .toList(),
    );
  }

  factory QuizSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return QuizSubmitResponseModel(
      score: json['score'],
      passed: json['passed'],
      status: json['status'],
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => QuizSubmitResultModel.fromJson(e))
          .toList(),
    );
  }
}
