import 'package:easy_helper/easy_helper.dart';

class RequestEditPasswordModel implements BaseRequest {
  final String currentPassword;
  final String newPassword;

  RequestEditPasswordModel({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  Map<String, dynamic> toJson() => {
        "current_password": currentPassword,
        "new_password": newPassword,
      };
}
