import 'package:easy_helper/easy_helper.dart';

abstract class AnnouncementEntity extends BaseResult {
  final String? id;
  final String? title;
  final String? body;
  final String? publishedAt;
  final String? courseId;
  final String? courseTitle;
  final String? moduleId;
  final bool isUnread;
  final String? notificationId;

  const AnnouncementEntity({
    this.id,
    this.title,
    this.body,
    this.publishedAt,
    this.courseId,
    this.courseTitle,
    this.moduleId,
    this.isUnread = false,
    this.notificationId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        publishedAt,
        courseId,
        courseTitle,
        moduleId,
        isUnread,
        notificationId,
      ];
}
