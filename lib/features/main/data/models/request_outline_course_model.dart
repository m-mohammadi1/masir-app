import 'package:easy_helper/easy_helper.dart';

class RequestOutlineCourseModel implements BaseRequest {
  final String id;

  RequestOutlineCourseModel({required this.id});

  @override
  Map<String, dynamic> toJson() => {};
}
