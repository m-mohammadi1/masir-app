import '/features/main/domain/entities/institutes.dart';

class InstitutesModel extends InstitutesEntity {
  const InstitutesModel({
    super.id,
    super.name,
    super.slug,
    super.type,
    super.description,
    super.logoUrl,
  });

  @override
  InstitutesModel fromJson(Map<String, dynamic> json) {
    return InstitutesModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      type: json['type'],
      description: json['description'],
      logoUrl: json['logo_url'],
    );
  }
}
