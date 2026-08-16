import '/features/main/domain/entities/units.dart';
import '/features/teacher/data/models/teacher_model.dart';

class UnitsModel extends UnitsEntity {
  const UnitsModel({
    super.id,
    super.courseId,
    super.title,
    super.type,
    super.order,
    super.payload,
    super.teachers,
    super.isPreview,
    super.isLastPreview,
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
      teachers: parseCourseTeachers(json['teachers']),
      isPreview: json['is_preview'] == true,
      isLastPreview: json['is_last_preview'] == true,
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
      teachers: parseCourseTeachers(json['teachers']),
      isPreview: json['is_preview'] == true,
      isLastPreview: json['is_last_preview'] == true,
    );
  }
}

class UnitsPayloadModel extends UnitsPayloadEntity {
  const UnitsPayloadModel({
    super.passThreshold,
    super.questions,
    super.body,
    super.instructions,
    super.attachmentUrl,
    super.durationSeconds,
    super.mediaAccessUrl,
    super.mediaExpiresAt,
  });

  factory UnitsPayloadModel.fromJson(Map<String, dynamic> json) {
    return UnitsPayloadModel(
      passThreshold: json['pass_threshold'],
      body: json['body'],
      instructions: json['instructions'],
      attachmentUrl: json['attachment_url'],
      durationSeconds: json['duration_seconds'],
      mediaAccessUrl: json['media_access_url'],
      mediaExpiresAt: json['media_expires_at'],
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
