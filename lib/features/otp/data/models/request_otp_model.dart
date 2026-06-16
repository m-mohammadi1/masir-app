import 'package:easy_helper/easy_helper.dart';

class RequestOtpModel implements BaseRequest {
  final String identifier, code;

  RequestOtpModel({required this.identifier, required this.code});

  @override
  Map<String, dynamic> toJson() => {"phone": identifier, "code": code};
}
