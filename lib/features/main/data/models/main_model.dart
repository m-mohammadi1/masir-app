import '/features/main/domain/entities/main.dart';

class MainModel extends MainEntity {
  const MainModel({super.id});

  @override
  MainModel fromJson(Map<String, dynamic> json) {
    return MainModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  MainModel copyWith(String? id) {
    return MainModel(id: id ?? this.id);
  }
}
