import 'package:easy_helper/easy_helper.dart';

class CourseTeacherSummary {
  final String? userId;
  final String? name;
  final String? photoUrl;
  final String? headline;

  const CourseTeacherSummary({
    this.userId,
    this.name,
    this.photoUrl,
    this.headline,
  });
}

class TeacherCourseSummary {
  final String? id;
  final String? title;

  const TeacherCourseSummary({this.id, this.title});
}

class TeacherLink {
  final String? kind;
  final String? url;

  const TeacherLink({this.kind, this.url});
}

abstract class TeacherEntity extends BaseResult {
  final String? userId;
  final String? name;
  final String? photoUrl;
  final String? headline;
  final String? bio;
  final List<TeacherLink> links;
  final List<TeacherCourseSummary> courses;

  const TeacherEntity({
    this.userId,
    this.name,
    this.photoUrl,
    this.headline,
    this.bio,
    this.links = const [],
    this.courses = const [],
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    photoUrl,
    headline,
    bio,
    links,
    courses,
  ];
}

class TeacherInstitute {
  final String? id;
  final String? name;
  final String? slug;
  final String? logoUrl;

  const TeacherInstitute({this.id, this.name, this.slug, this.logoUrl});
}

abstract class TeacherPageEntity extends BaseResult {
  final String? userId;
  final String? name;
  final String? photoUrl;
  final String? headline;
  final String? bio;
  final List<TeacherLink> links;
  final List<TeacherInstitute> institutes;

  const TeacherPageEntity({
    this.userId,
    this.name,
    this.photoUrl,
    this.headline,
    this.bio,
    this.links = const [],
    this.institutes = const [],
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    photoUrl,
    headline,
    bio,
    links,
    institutes,
  ];
}
