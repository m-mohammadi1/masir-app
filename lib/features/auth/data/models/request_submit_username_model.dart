import 'package:easy_helper/easy_helper.dart';

class RequestSubmitUsernameModel implements BaseRequest {
  final String data;

  RequestSubmitUsernameModel({required this.data});

  @override
  Map<String, dynamic> toJson() => {
    "username" : data,
  };
}
