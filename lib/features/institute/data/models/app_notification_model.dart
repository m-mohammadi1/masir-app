import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotificationEntity {
  const AppNotificationModel({
    super.id,
    super.type,
    super.payload,
    super.readAt,
    super.createdAt,
  });

  @override
  AppNotificationModel fromJson(Map<String, dynamic> json) =>
      AppNotificationModel.fromJson(json);

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    final raw = json['payload'];
    Map<String, dynamic> payload = const {};
    if (raw is Map) {
      payload = Map<String, dynamic>.from(raw);
    }
    return AppNotificationModel(
      id: json['id']?.toString(),
      type: json['type']?.toString(),
      payload: payload,
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
