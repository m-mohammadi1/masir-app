import '/features/auth/domain/entities/submit_username.dart';

class UserModel extends UserEntity {
  const UserModel({super.id, super.phone, super.username, super.name});

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      name: json['name'],
      username: json['username'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      name: json['name'],
      username: json['username'],
    );
  }
}
