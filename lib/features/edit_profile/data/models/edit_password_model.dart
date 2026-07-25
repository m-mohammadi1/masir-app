import '/features/edit_profile/domain/entities/edit_password.dart';

class EditPasswordModel extends EditPasswordEntity {
  const EditPasswordModel({super.id});

  @override
  EditPasswordModel fromJson(Map<String, dynamic> json) {
    return EditPasswordModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  EditPasswordModel copyWith(String? id) {
    return EditPasswordModel(id: id ?? this.id);
  }
}
