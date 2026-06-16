import 'package:easy_helper/easy_helper.dart';

abstract class QuizEntity extends BaseResult {
  final String? id;
  final String? type;
  final String? title;
  final String? description;
  final List<String>? options;
  final String? answer;

  const QuizEntity({
    this.id,
    this.type,
    this.title,
    this.description,
    this.options,
    this.answer,
  });

  @override
  List<Object?> get props => [id, type, title, description, options, answer];
}
