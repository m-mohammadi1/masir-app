import '/features/main/domain/entities/outline_course.dart';
import '/features/teacher/data/models/teacher_model.dart';

class OutlineCourseModel extends OutlineCourseEntity {
  const OutlineCourseModel({
    super.id,
    super.title,
    super.courseProgressPercent,
    super.previewUnitCount,
    super.modules,
    super.teachers,
  });

  @override
  OutlineCourseModel fromJson(Map<String, dynamic> json) {
    return OutlineCourseModel(
      id: json['id'],
      title: json['title'],
      courseProgressPercent: json['course_progress_percent'],
      previewUnitCount: json['preview_unit_count'],
      modules: (json['modules'] as List<dynamic>?)
          ?.map((e) => OutlineModuleModel.fromJson(e))
          .toList(),
      teachers: parseCourseTeachers(json['teachers']),
    );
  }
}

class OutlineModuleModel extends OutlineModuleEntity {
  const OutlineModuleModel({
    super.id,
    super.title,
    super.order,
    super.locked,
    super.paths,
  });

  factory OutlineModuleModel.fromJson(Map<String, dynamic> json) {
    return OutlineModuleModel(
      id: json['id'],
      title: json['title'],
      order: json['order'],
      locked: json['locked'],
      paths: (json['paths'] as List<dynamic>?)
          ?.map((e) => OutlinePathModel.fromJson(e))
          .toList(),
    );
  }
}

class OutlinePathModel extends OutlinePathEntity {
  const OutlinePathModel({
    super.id,
    super.title,
    super.order,
    super.locked,
    super.pathProgressPercent,
    super.units,
  });

  factory OutlinePathModel.fromJson(Map<String, dynamic> json) {
    return OutlinePathModel(
      id: json['id'],
      title: json['title'],
      order: json['order'],
      locked: json['locked'],
      pathProgressPercent: json['path_progress_percent'],
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => OutlineUnitModel.fromJson(e))
          .toList(),
    );
  }
}

class OutlineUnitModel extends OutlineUnitEntity {
  const OutlineUnitModel({
    super.id,
    super.title,
    super.type,
    super.order,
    super.status,
    super.locked,
    super.isPreview,
  });

  factory OutlineUnitModel.fromJson(Map<String, dynamic> json) {
    return OutlineUnitModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      order: json['order'],
      status: json['status'],
      locked: json['locked'],
      isPreview: json['is_preview'] == true,
    );
  }
}
