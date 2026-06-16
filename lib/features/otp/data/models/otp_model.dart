import 'dart:developer';

import '/core/services/hive_service.dart';

import '../../../../core/services/service_locator.dart';
import '/features/otp/domain/entities/otp.dart';

class OtpModel extends OtpEntity {
  const OtpModel({super.user, super.accessToken});

  @override
  factory OtpModel.fromJson(Map<String, dynamic> json) {
    log("json is : ${json}");
    HiveService.token = json['access_token'];
    updateHeader();
    return OtpModel(
      accessToken: json['access_token'],
      user: User().fromJson(json['user']),
    );
  }

  // Map<String, dynamic> toJson() => {"user": user?.toJson()};
}
