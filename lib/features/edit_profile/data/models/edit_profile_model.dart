import '../../../../core/services/hive_service.dart';
import '../../../auth/domain/entities/submit_username.dart';
import '/features/edit_profile/domain/entities/edit_profile.dart';

class EditProfileModel extends EditProfileEntity {
  const EditProfileModel({
    super.id,
    super.phone,
    super.username,
    super.name,
  });

  @override
  EditProfileModel fromJson(Map<String, dynamic> json) {
    final model = EditProfileModel(
      id: json['id'],
      phone: json['phone'],
      username: json['username'],
      name: json['name'],
    );

    final current = HiveService.user;
    HiveService.setUser(
      User(
        id: model.id ?? current?.id,
        phone: model.phone ?? current?.phone,
        username: model.username ?? current?.username,
        name: model.name ?? current?.name,
      ),
    );

    return model;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "username": username,
        "name": name,
      };

  EditProfileModel copyWith({
    String? id,
    String? phone,
    String? username,
    String? name,
  }) {
    return EditProfileModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      name: name ?? this.name,
    );
  }
}
