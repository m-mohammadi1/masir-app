import '/features/main/domain/entities/main.dart';

class MainModel extends MainEntity {
  const MainModel({super.id, super.name, super.slug});

  @override
  MainModel fromJson(Map<String, dynamic> json) {
    return MainModel(id: json['id'], name: json['name'], slug: json['slug']);
  }
}
