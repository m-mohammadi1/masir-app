import 'package:easy_helper/easy_helper.dart';

class RequestSubmitRegisterModel implements BaseRequest {
  final String phone;
  final String inviteCode;
  final String smsCode;
  final String password;

  RequestSubmitRegisterModel({
    required this.phone,
    required this.inviteCode,
    required this.smsCode,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() => {
    "phone": phone,
    "invite_code": inviteCode,
    "sms_code": smsCode,
    "password": password,
  };
}
