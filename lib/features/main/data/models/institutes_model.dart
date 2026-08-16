import '/features/main/domain/entities/courses.dart';
import '/features/main/domain/entities/institutes.dart';

class InstitutesModel extends InstitutesEntity {
  const InstitutesModel({
    super.id,
    super.name,
    super.slug,
    super.type,
    super.description,
    super.logoUrl,
    super.coverUrl,
    super.themePreset,
    super.topic,
  });

  static CourseTopic? _topic(dynamic raw) {
    if (raw is! Map) return null;
    return CourseTopic(
      id: raw['id']?.toString(),
      slug: raw['slug']?.toString(),
      name: raw['name']?.toString(),
    );
  }

  @override
  InstitutesModel fromJson(Map<String, dynamic> json) {
    return InstitutesModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      type: json['type'],
      description: json['description'],
      logoUrl: json['logo_url'],
      coverUrl: json['cover_url'],
      themePreset: json['theme_preset'],
      topic: _topic(json['topic']),
    );
  }
}
