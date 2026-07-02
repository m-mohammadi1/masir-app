import '../../../../core/services/hive_service.dart';
import '/features/auth/domain/entities/submit_username.dart';

class UserModel extends User {
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
    final user= UserModel(
      id: json['id'],
      phone: json['phone'],
      name: json['name'],
      username: json['username'],
    );
    HiveService.setUser(user);
    return user;
  }
}
