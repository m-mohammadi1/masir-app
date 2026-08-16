import 'package:easy_helper/easy_helper.dart';

class RequestAnnouncementsModel implements BaseRequest {
  final String instituteId;
  final int page;
  final int perPage;

  const RequestAnnouncementsModel({
    required this.instituteId,
    this.page = 1,
    this.perPage = 20,
  });

  @override
  Map<String, dynamic> toJson() => {'page': page, 'per_page': perPage};
}

class RequestAnnouncementIdModel implements BaseRequest {
  final String instituteId;
  final String announcementId;

  const RequestAnnouncementIdModel({
    required this.instituteId,
    required this.announcementId,
  });

  @override
  Map<String, dynamic> toJson() => {};
}

class RequestNotificationsModel implements BaseRequest {
  final int page;
  final int perPage;

  const RequestNotificationsModel({this.page = 1, this.perPage = 20});

  @override
  Map<String, dynamic> toJson() => {'page': page, 'per_page': perPage};
}

class RequestNotificationIdModel implements BaseRequest {
  final String id;

  const RequestNotificationIdModel({required this.id});

  @override
  Map<String, dynamic> toJson() => {};
}
