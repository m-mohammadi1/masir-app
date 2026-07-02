import '/features/main/domain/entities/my_institutes.dart';

class MyInstitutesModel extends MyInstitutesEntity {
  const MyInstitutesModel({super.id, super.name, super.slug});

  @override
  MyInstitutesModel fromJson(Map<String, dynamic> json) {
    return MyInstitutesModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}
