import 'package:easy_helper/easy_helper.dart';

class DiscoveryTopicEntity extends BaseResult {
  final String? id;
  final String? slug;
  final String? name;
  final int instituteCount;

  const DiscoveryTopicEntity({
    this.id,
    this.slug,
    this.name,
    this.instituteCount = 0,
  });

  @override
  List<Object?> get props => [id, slug, name, instituteCount];
}

class FeedInstituteItem {
  final String? id;
  final String? name;
  final String? slug;
  final String? logoUrl;
  final String? coverUrl;
  final String? themePreset;
  final DiscoveryTopicEntity? topic;

  const FeedInstituteItem({
    this.id,
    this.name,
    this.slug,
    this.logoUrl,
    this.coverUrl,
    this.themePreset,
    this.topic,
  });
}

class FeedCourseItem {
  final String? id;
  final String? instituteId;
  final String? instituteName;
  final String? title;
  final String? description;
  final String? coverUrl;
  final DiscoveryTopicEntity? topic;

  const FeedCourseItem({
    this.id,
    this.instituteId,
    this.instituteName,
    this.title,
    this.description,
    this.coverUrl,
    this.topic,
  });
}

class FeedActivityItem {
  final String? kind;
  final String? title;
  final String? moduleId;
  final String? courseId;
  final String? courseTitle;
  final String? instituteId;
  final String? instituteName;
  final String? instituteLogoUrl;
  final String? createdAt;

  const FeedActivityItem({
    this.kind,
    this.title,
    this.moduleId,
    this.courseId,
    this.courseTitle,
    this.instituteId,
    this.instituteName,
    this.instituteLogoUrl,
    this.createdAt,
  });
}

class MainFeedSectionEntity {
  final String kind;
  final String title;
  final List<Object> items;

  const MainFeedSectionEntity({
    required this.kind,
    required this.title,
    this.items = const [],
  });
}

class MainFeedEntity extends BaseResult {
  final List<MainFeedSectionEntity> sections;

  const MainFeedEntity({this.sections = const []});

  @override
  List<Object?> get props => [sections];
}
