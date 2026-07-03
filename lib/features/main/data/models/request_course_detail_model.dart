import 'package:easy_helper/easy_helper.dart';

class RequestCourseDetailModel implements BaseRequest {
  final String id;

  RequestCourseDetailModel({required this.id});

  @override
  Map<String, dynamic> toJson() => {};
}
