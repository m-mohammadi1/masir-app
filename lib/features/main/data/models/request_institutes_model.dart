import 'package:easy_helper/easy_helper.dart';

class RequestInstitutesModel implements BaseRequest {
  final String? topic;

  const RequestInstitutesModel({this.topic});

  @override
  Map<String, dynamic> toJson() => {
        if (topic != null && topic!.isNotEmpty) 'topic': topic,
      };
}
