import 'package:mohammad/core/services/hive_service.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/auth/data/models/submit_username_model.dart';

import '/features/auth/domain/entities/login.dart';

class LoginModel extends LoginEntity {
  const LoginModel({super.token, super.user});

  @override
  LoginModel fromJson(Map<String, dynamic> json) {
    HiveService.token = json['access_token'];
    updateHeader();
    return LoginModel(token: json['access_token'] , user: UserModel.fromJson(json['student']));
  }
}
