import 'package:easy_helper/easy_helper.dart';

class RequestAuthModel implements BaseRequest {
  final String phone;
  final String inviteCode;

  RequestAuthModel({required this.phone, required this.inviteCode});

  @override
  Map<String, dynamic> toJson() => {"phone": phone, "invite_code": inviteCode};
}
