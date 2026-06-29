import '/features/auth/domain/entities/login.dart';

class LoginModel extends LoginEntity {
  const LoginModel({super.id});

  @override
  LoginModel fromJson(Map<String, dynamic> json) {
    return LoginModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  LoginModel copyWith(String? id) {
    return LoginModel(id: id ?? this.id);
  }
}
