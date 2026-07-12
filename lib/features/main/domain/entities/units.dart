import 'package:easy_helper/easy_helper.dart';

abstract class UnitsEntity extends BaseResult {
  final String? id;
  final String? courseId;
  final String? title;
  final String? type;
  final int? order;
  final UnitsPayloadEntity? payload;

  const UnitsEntity({
    this.id,
    this.courseId,
    this.title,
    this.type,
    this.order,
    this.payload,
  });

  @override
  List<Object?> get props => [id, courseId, title, type, order, payload];
}

abstract class UnitsPayloadEntity extends BaseResult {
  final int? passThreshold;
  final List<UnitsQuestionEntity>? questions;
  final String? body;
  final String? instructions;
  final String? attachmentUrl;

  const UnitsPayloadEntity({
    this.passThreshold,
    this.questions,
    this.body,
    this.instructions,
    this.attachmentUrl,
  });

  @override
  List<Object?> get props =>
      [passThreshold, questions, body, instructions, attachmentUrl];
}

abstract class UnitsQuestionEntity extends BaseResult {
  final String? id;
  final String? type;
  final String? text;
  final List<String>? options;

  const UnitsQuestionEntity({
    this.id,
    this.type,
    this.text,
    this.options,
  });

  @override
  List<Object?> get props => [id, type, text, options];
}
