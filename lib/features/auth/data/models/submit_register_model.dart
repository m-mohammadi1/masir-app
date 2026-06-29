import '/features/auth/domain/entities/submit_register.dart';

class SubmitRegisterModel extends SubmitRegisterEntity {
  const SubmitRegisterModel({super.id});

  @override
  SubmitRegisterModel fromJson(Map<String, dynamic> json) {
    return SubmitRegisterModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  SubmitRegisterModel copyWith(String? id) {
    return SubmitRegisterModel(id: id ?? this.id);
  }
}
