import '../../domain/entities/main_feed.dart';

class DiscoveryTopicModel extends DiscoveryTopicEntity {
  const DiscoveryTopicModel({
    super.id,
    super.slug,
    super.name,
    super.instituteCount,
  });

  @override
  DiscoveryTopicModel fromJson(Map<String, dynamic> json) =>
      DiscoveryTopicModel.fromJson(json);

  factory DiscoveryTopicModel.fromJson(Map<String, dynamic> json) {
    return DiscoveryTopicModel(
      id: json['id']?.toString(),
      slug: json['slug']?.toString(),
      name: json['name']?.toString(),
      instituteCount: json['institute_count'] as int? ?? 0,
    );
  }

  static DiscoveryTopicEntity? maybe(dynamic raw) {
    if (raw is! Map) return null;
    return DiscoveryTopicModel.fromJson(Map<String, dynamic>.from(raw));
  }
}

class MainFeedModel extends MainFeedEntity {
  const MainFeedModel({super.sections});

  @override
  MainFeedModel fromJson(Map<String, dynamic> json) =>
      MainFeedModel.fromJson(json);

  factory MainFeedModel.fromJson(Map<String, dynamic> json) {
    final raw = json['sections'];
    final sections = <MainFeedSectionEntity>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          sections.add(_section(Map<String, dynamic>.from(item)));
        }
      }
    }
    return MainFeedModel(sections: sections);
  }

  static MainFeedSectionEntity _section(Map<String, dynamic> json) {
    final kind = json['kind']?.toString() ?? '';
    final title = json['title']?.toString() ?? '';
    final rawItems = json['items'];
    final items = <Object>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        if (kind == 'featured_institutes' ||
            kind == 'recommended_institutes' ||
            kind == 'all_institutes') {
          items.add(_institute(map));
        } else if (kind == 'new_courses' || kind == 'featured_courses') {
          items.add(_course(map));
        } else if (kind == 'institute_activity') {
          items.add(_activity(map));
        } else {
          items.add(map);
        }
      }
    }
    return MainFeedSectionEntity(kind: kind, title: title, items: items);
  }

  static FeedInstituteItem _institute(Map<String, dynamic> json) {
    return FeedInstituteItem(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      logoUrl: json['logo_url']?.toString(),
      coverUrl: json['cover_url']?.toString(),
      themePreset: json['theme_preset']?.toString(),
      topic: DiscoveryTopicModel.maybe(json['topic']),
    );
  }

  static FeedCourseItem _course(Map<String, dynamic> json) {
    return FeedCourseItem(
      id: json['id']?.toString(),
      instituteId: json['institute_id']?.toString(),
      instituteName: json['institute_name']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      coverUrl: json['cover_url']?.toString(),
      topic: DiscoveryTopicModel.maybe(json['topic']),
    );
  }

  static FeedActivityItem _activity(Map<String, dynamic> json) {
    return FeedActivityItem(
      kind: json['kind']?.toString(),
      title: json['title']?.toString(),
      moduleId: json['module_id']?.toString(),
      courseId: json['course_id']?.toString(),
      courseTitle: json['course_title']?.toString(),
      instituteId: json['institute_id']?.toString(),
      instituteName: json['institute_name']?.toString(),
      instituteLogoUrl: json['institute_logo_url']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
