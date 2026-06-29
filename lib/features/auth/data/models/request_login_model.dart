import 'package:easy_helper/easy_helper.dart';

class RequestLoginModel implements BaseRequest {
  final String username, password;

  RequestLoginModel({required this.username, required this.password});

  @override
  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
