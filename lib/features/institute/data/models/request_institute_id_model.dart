import 'package:easy_helper/easy_helper.dart';

class RequestInstituteIdModel implements BaseRequest {
  final String id;

  const RequestInstituteIdModel({required this.id});

  @override
  Map<String, dynamic> toJson() => {};
}
