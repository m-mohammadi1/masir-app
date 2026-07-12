import 'package:easy_helper/easy_helper.dart';

class QuizSubmitAnswerModel {
  final String questionId;
  final dynamic answer;

  const QuizSubmitAnswerModel({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'answer': answer,
      };
}

class RequestQuizSubmitModel implements BaseRequest {
  final String id;
  final List<QuizSubmitAnswerModel> answers;

  RequestQuizSubmitModel({
    required this.id,
    required this.answers,
  });

  @override
  Map<String, dynamic> toJson() => {
        'answers': answers.map((e) => e.toJson()).toList(),
      };
}
