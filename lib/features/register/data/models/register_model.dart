import '/features/register/domain/entities/register.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel({super.id});

  @override
  RegisterModel fromJson(Map<String, dynamic> json) {
    return RegisterModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  RegisterModel copyWith(String? id) {
    return RegisterModel(id: id ?? this.id);
  }
}
