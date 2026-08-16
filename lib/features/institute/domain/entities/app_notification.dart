import 'package:easy_helper/easy_helper.dart';

abstract class AppNotificationEntity extends BaseResult {
  final String? id;
  final String? type;
  final Map<String, dynamic> payload;
  final String? readAt;
  final String? createdAt;

  const AppNotificationEntity({
    this.id,
    this.type,
    this.payload = const {},
    this.readAt,
    this.createdAt,
  });

  bool get isUnread => readAt == null || readAt!.isEmpty;

  String? get instituteId => payload['institute_id']?.toString();

  String? get announcementId => payload['announcement_id']?.toString();

  String? get courseId => payload['course_id']?.toString();

  @override
  List<Object?> get props => [id, type, payload, readAt, createdAt];
}
