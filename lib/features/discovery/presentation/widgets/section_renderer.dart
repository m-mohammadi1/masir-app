import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';

import '/core/services/service_locator.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/theme_context.dart';
import '/features/discovery/domain/entities/main_feed.dart';
import '/features/home/page/detail_course_page.dart';
import '/features/main/data/models/request_course_detail_model.dart';
import '/features/main/domain/usecases/course_detail_usecase.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/custom_text.dart';
import '/widgets/skeleton.dart';

class SectionRenderer extends StatelessWidget {
  final MainFeedSectionEntity section;

  const SectionRenderer({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    switch (section.kind) {
      case 'featured_institutes':
        return _InstituteCarousel(section: section, featured: true);
      case 'recommended_institutes':
      case 'all_institutes':
        return _InstituteCarousel(section: section, featured: false);
      case 'new_courses':
      case 'featured_courses':
        return _CourseCarousel(section: section);
      case 'institute_activity':
        return _ActivityList(section: section);
      default:
        return const SizedBox.shrink();
    }
  }
}

class SectionSkeleton extends StatelessWidget {
  const SectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SkeletonText(width: 140, height: 18),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, _) => const SkeletonBox(width: 220, height: 160, radius: 16),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: CustomText(title, fontWeight: FontWeight.w600, fontSize: 16),
    );
  }
}

class _TopicTag extends StatelessWidget {
  final String? name;
  const _TopicTag(this.name);

  @override
  Widget build(BuildContext context) {
    if (name == null || name!.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: CustomText(name!, fontSize: 11),
    );
  }
}

class _InstituteCarousel extends StatelessWidget {
  final MainFeedSectionEntity section;
  final bool featured;

  const _InstituteCarousel({required this.section, required this.featured});

  @override
  Widget build(BuildContext context) {
    final items = section.items.whereType<FeedInstituteItem>().toList();
    if (items.isEmpty) return const SizedBox.shrink();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final height = featured ? 200.0 : 140.0;
    final width = featured ? screenWidth - 32 : 200.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(section.title),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: featured ? 12 : 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final preset =
                  kInstitutePresets[item.themePreset] ??
                  kInstitutePresets[kDefaultPreset]!;
              return OnClick(
                onTap: () {
                  if (item.id != null) {
                    CustomNavigator.pushNamed('/i/${item.id}/home');
                  }
                },
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: featured ? preset.primarySoft : context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (item.coverUrl != null && item.coverUrl!.isNotEmpty)
                              Image.network(item.coverUrl!, fit: BoxFit.cover)
                            else
                              ColoredBox(color: preset.primary),
                            if (item.logoUrl != null && item.logoUrl!.isNotEmpty)
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: ClipOval(
                                  child: Image.network(
                                    item.logoUrl!,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              item.name ?? '',
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                            ),
                            if (item.topic?.name != null) ...[
                              const SizedBox(height: 4),
                              _TopicTag(item.topic?.name),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CourseCarousel extends StatelessWidget {
  final MainFeedSectionEntity section;
  const _CourseCarousel({required this.section});

  @override
  Widget build(BuildContext context) {
    final items = section.items.whereType<FeedCourseItem>().toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(section.title),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return OnClick(
                onTap: () {
                  if (item.id != null) {
                    CustomNavigator.pushNamed(
                      DetailCoursePage.routeName,
                      arguments: item.id,
                    );
                  }
                },
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 100,
                        child: item.coverUrl != null && item.coverUrl!.isNotEmpty
                            ? Image.network(item.coverUrl!, fit: BoxFit.cover)
                            : ColoredBox(color: context.colors.primary.withValues(alpha: 0.4)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              item.title ?? '',
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                            ),
                            if (item.instituteName != null &&
                                item.instituteName!.isNotEmpty)
                              CustomText(
                                item.instituteName!,
                                fontSize: 12,
                                color: context.colors.inkMuted,
                                maxLines: 1,
                              ),
                            if (item.topic?.name != null) ...[
                              const SizedBox(height: 4),
                              _TopicTag(item.topic?.name),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityList extends StatelessWidget {
  final MainFeedSectionEntity section;
  const _ActivityList({required this.section});

  @override
  Widget build(BuildContext context) {
    final items = section.items.whereType<FeedActivityItem>().toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(section.title),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: OnClick(
              onTap: () => _openActivity(item),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.border),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 40,
                        height: 40,
                        color: context.colors.borderF9,
                        child: item.instituteLogoUrl != null &&
                                item.instituteLogoUrl!.isNotEmpty
                            ? Image.network(item.instituteLogoUrl!, fit: BoxFit.cover)
                            : Icon(Icons.school, color: context.colors.inkMuted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomText(item.title ?? '', fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openActivity(FeedActivityItem item) async {
    final courseId = item.courseId;
    if (courseId == null || courseId.isEmpty) return;
    final result = await inject<CourseDetailUseCase>()(
      params: RequestCourseDetailModel(id: courseId),
    );
    result.fold((_) {
      CustomNavigator.pushNamed(DetailCoursePage.routeName, arguments: courseId);
    }, (detail) {
      final subscribed = detail.coursesModel?.isSubscribed == true;
      if (!subscribed) {
        CustomNavigator.pushNamed(DetailCoursePage.routeName, arguments: courseId);
        return;
      }
      CustomNavigator.pushNamed(
        OutlinePage.routeName,
        arguments: {
          'id': courseId,
          'title': detail.coursesModel?.title ?? item.courseTitle ?? '',
          if (item.moduleId != null && item.moduleId!.isNotEmpty)
            'moduleId': item.moduleId,
        },
      );
    });
  }
}
