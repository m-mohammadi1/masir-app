import 'package:easy_helper/easy_helper.dart';

class RequestEditProfileModel implements BaseRequest {
  final String name;

  RequestEditProfileModel({required this.name});

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
