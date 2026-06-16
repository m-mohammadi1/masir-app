import '/features/quiz/domain/entities/quiz.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    super.id,
    super.type,
    super.title,
    super.description,
    super.options,
    super.answer,
  });

  @override
  QuizModel fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      options: json['options'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "description": description,
    "options": options,
    "answer": answer,
  };
}
