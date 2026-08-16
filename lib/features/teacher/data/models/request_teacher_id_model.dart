import 'package:easy_helper/easy_helper.dart';

class RequestTeacherIdModel implements BaseRequest {
  final String userId;

  const RequestTeacherIdModel({required this.userId});

  @override
  Map<String, dynamic> toJson() => {};
}
