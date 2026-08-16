import 'package:easy_helper/easy_helper.dart';

class InstituteLink {
  final String? kind;
  final String? url;

  const InstituteLink({this.kind, this.url});
}

class InstituteTopic {
  final String? id;
  final String? slug;
  final String? name;

  const InstituteTopic({this.id, this.slug, this.name});
}

class InstituteMembership {
  final bool isMember;
  final String? memberSince;

  const InstituteMembership({this.isMember = false, this.memberSince});
}

abstract class InstituteDetailEntity extends BaseResult {
  final String? id;
  final String? name;
  final String? slug;
  final String? type;
  final String? description;
  final String? intro;
  final String? logoUrl;
  final String? coverUrl;
  final String? themePreset;
  final int? foundedYear;
  final List<InstituteLink> links;
  final InstituteTopic? topic;
  final int courseCount;
  final int studentCount;
  final InstituteMembership membership;

  const InstituteDetailEntity({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.description,
    this.intro,
    this.logoUrl,
    this.coverUrl,
    this.themePreset,
    this.foundedYear,
    this.links = const [],
    this.topic,
    this.courseCount = 0,
    this.studentCount = 0,
    this.membership = const InstituteMembership(),
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    type,
    description,
    intro,
    logoUrl,
    coverUrl,
    themePreset,
    foundedYear,
    links,
    topic,
    courseCount,
    studentCount,
    membership,
  ];
}
