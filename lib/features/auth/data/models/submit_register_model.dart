import 'package:mohammad/features/auth/data/models/submit_username_model.dart';

import '../../../../core/services/hive_service.dart';
import '../../../../core/services/service_locator.dart';
import '/features/auth/domain/entities/submit_register.dart';

class SubmitRegisterModel extends SubmitRegisterEntity {
  const SubmitRegisterModel({super.token, super.user});

  @override
  SubmitRegisterModel fromJson(Map<String, dynamic> json) {
    HiveService.token = json['access_token'];
    updateHeader();
    return SubmitRegisterModel(
      token: json['access_token'],
      user: UserModel.fromJson(json['student']),
    );
  }
}
