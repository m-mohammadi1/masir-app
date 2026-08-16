import '../../domain/entities/announcement.dart';

class AnnouncementModel extends AnnouncementEntity {
  const AnnouncementModel({
    super.id,
    super.title,
    super.body,
    super.publishedAt,
    super.courseId,
    super.courseTitle,
    super.moduleId,
    super.isUnread,
    super.notificationId,
  });

  @override
  AnnouncementModel fromJson(Map<String, dynamic> json) =>
      AnnouncementModel.fromJson(json);

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      publishedAt: json['published_at']?.toString(),
      courseId: json['course_id']?.toString(),
      courseTitle: json['course_title']?.toString(),
      moduleId: json['module_id']?.toString(),
      isUnread: json['is_unread'] == true,
      notificationId: json['notification_id']?.toString(),
    );
  }
}
