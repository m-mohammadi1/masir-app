import '/features/edit_profile/domain/entities/edit_profile.dart';

class EditProfileModel extends EditProfileEntity {
  const EditProfileModel({super.id});

  @override
  EditProfileModel fromJson(Map<String, dynamic> json) {
    return EditProfileModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  EditProfileModel copyWith(String? id) {
    return EditProfileModel(id: id ?? this.id);
  }
}
