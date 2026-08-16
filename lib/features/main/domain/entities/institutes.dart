import 'package:easy_helper/easy_helper.dart';

import '/features/main/domain/entities/courses.dart';

abstract class InstitutesEntity extends BaseResult {
  final String? id;
  final String? name;
  final String? slug;
  final String? type;
  final String? description;
  final String? logoUrl;
  final String? coverUrl;
  final String? themePreset;
  final CourseTopic? topic;

  const InstitutesEntity({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.description,
    this.logoUrl,
    this.coverUrl,
    this.themePreset,
    this.topic,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        type,
        description,
        logoUrl,
        coverUrl,
        themePreset,
        topic,
      ];
}
