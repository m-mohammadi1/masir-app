import 'package:easy_helper/easy_helper.dart';

class RequestCoursesModel implements BaseRequest {
  /// When provided, scopes the course list to a single institute
  /// (`institutes/{instituteId}/courses`) instead of the global catalog.
  final String? instituteId;

  const RequestCoursesModel({this.instituteId});

  @override
  Map<String, dynamic> toJson() => {};
}
