import '/features/main/domain/entities/units.dart';

class UnitsModel extends UnitsEntity {
  const UnitsModel({
    super.id,
    super.courseId,
    super.title,
    super.type,
    super.order,
    super.payload,
  });

  @override
  UnitsModel fromJson(Map<String, dynamic> json) {
    return UnitsModel(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      type: json['type'],
      order: json['order'],
      payload: json['payload'] != null
          ? UnitsPayloadModel.fromJson(json['payload'])
          : null,
    );
  }

  factory UnitsModel.fromJson(Map<String, dynamic> json) {
    return UnitsModel(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      type: json['type'],
      order: json['order'],
      payload: json['payload'] != null
          ? UnitsPayloadModel.fromJson(json['payload'])
          : null,
    );
  }
}

class UnitsPayloadModel extends UnitsPayloadEntity {
  const UnitsPayloadModel({
    super.passThreshold,
    super.questions,
  });

  factory UnitsPayloadModel.fromJson(Map<String, dynamic> json) {
    return UnitsPayloadModel(
      passThreshold: json['pass_threshold'],
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => UnitsQuestionModel.fromJson(e))
          .toList(),
    );
  }
}

class UnitsQuestionModel extends UnitsQuestionEntity {
  const UnitsQuestionModel({
    super.id,
    super.type,
    super.text,
    super.options,
  });

  factory UnitsQuestionModel.fromJson(Map<String, dynamic> json) {
    return UnitsQuestionModel(
      id: json['id'],
      type: json['type'],
      text: json['text'],
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}
