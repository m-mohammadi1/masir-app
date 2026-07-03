import '/features/main/domain/entities/outline_course.dart';

class OutlineCourseModel extends OutlineCourseEntity {
  const OutlineCourseModel({super.id});

  @override
  OutlineCourseModel fromJson(Map<String, dynamic> json) {
    return OutlineCourseModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  OutlineCourseModel copyWith(String? id) {
    return OutlineCourseModel(id: id ?? this.id);
  }
}
