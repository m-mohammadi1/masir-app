import 'package:easy_helper/easy_helper.dart';

class RequestAuthModel implements BaseRequest {
  final String phone;

  RequestAuthModel({required this.phone});

  @override
  Map<String, dynamic> toJson() => {
    "phone" : phone,
  };
}
