import '/features/main/domain/entities/courses.dart';
import '/features/teacher/data/models/teacher_model.dart';

class CoursesModel extends CoursesEntity {
  const CoursesModel({
    super.id,
    super.instituteId,
    super.title,
    super.description,
    super.coverUrl,
    super.price,
    super.publishedAt,
    super.teachers,
  });

  @override
  CoursesModel fromJson(Map<String, dynamic> json) {
    return CoursesModel(
      id : json['id'],
      instituteId : json['institute_id'],
      title : json['title'],
      description : json['description'],
      coverUrl : json['cover_url'],
      price : json['price'],
      publishedAt : json['published_at'],
      teachers: parseCourseTeachers(json['teachers']),
    );
  }


  factory CoursesModel.fromJson(Map<String, dynamic> json) {
    return CoursesModel(
      id : json['id'],
      instituteId : json['institute_id'],
      title : json['title'],
      description : json['description'],
      coverUrl : json['cover_url'],
      price : json['price'],
      publishedAt : json['published_at'],
      teachers: parseCourseTeachers(json['teachers']),
    );
  }
}
