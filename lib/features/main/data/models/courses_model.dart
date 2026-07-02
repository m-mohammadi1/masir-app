import '/features/main/domain/entities/courses.dart';

class CoursesModel extends CoursesEntity {
  const CoursesModel({super.id});

  @override
  CoursesModel fromJson(Map<String, dynamic> json) {
    return CoursesModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  CoursesModel copyWith(String? id) {
    return CoursesModel(id: id ?? this.id);
  }
}
