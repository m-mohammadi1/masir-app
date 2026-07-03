import 'package:easy_helper/easy_helper.dart';

class RequestSubscribeCourseModel implements BaseRequest {
  final String id;

  RequestSubscribeCourseModel({required this.id});

  @override
  Map<String, dynamic> toJson() => {};
}
