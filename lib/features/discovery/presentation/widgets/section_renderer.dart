import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/services/service_locator.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/theme_context.dart';
import '/features/discovery/domain/entities/main_feed.dart';
import '/features/home/page/detail_course_page.dart';
import '/features/main/data/models/request_course_detail_model.dart';
import '/features/main/domain/usecases/course_detail_usecase.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/pill_chip.dart';
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
  final bool hero;

  const SectionSkeleton({super.key, this.hero = false});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (hero) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SkeletonText(width: 120, height: 18),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SkeletonBox(
              width: screenWidth - 32,
              height: 200,
              radius: 24,
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SkeletonText(width: 140, height: 18),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, _) =>
                const SkeletonBox(width: 168, height: 200, radius: 20),
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: CustomText(title, fontWeight: FontWeight.w800, fontSize: 18),
    );
  }
}

/// Staggered pop-in used by every carousel item.
class _PopIn extends StatelessWidget {
  final int index;
  final Widget child;
  const _PopIn({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + (index.clamp(0, 6)) * 70),
      curve: Curves.easeOutBack,
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 16),
          child: child,
        ),
      ),
      child: child,
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
    final height = featured ? 224.0 : 168.0;
    final width = featured ? screenWidth - 48 : 168.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(section.title),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _PopIn(
                index: index,
                child: featured
                    ? _FeaturedInstituteCard(item: item, width: width)
                    : _QuietInstituteCard(item: item, width: width),
              );
            },
          ),
        ),
      ],
    );
  }
}

void _openInstitute(FeedInstituteItem item) {
  if (item.id != null) {
    CustomNavigator.pushNamed('/i/${item.id}/home');
  }
}

class _FeaturedInstituteCard extends StatelessWidget {
  final FeedInstituteItem item;
  final double width;

  const _FeaturedInstituteCard({required this.item, required this.width});

  @override
  Widget build(BuildContext context) {
    final preset = presetFor(item.themePreset);
    return ChunkyBox(
      width: width,
      fill: preset.primary,
      edge: preset.edge,
      radius: 24,
      onTap: () => _openInstitute(item),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CoverImage(url: item.coverUrl, fallback: preset.primary),
          // Readable bottom scrim tinted with the brand colour.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  preset.edge.withValues(alpha: 0.35),
                  preset.edge.withValues(alpha: 0.9),
                ],
                stops: const [0.3, 0.6, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InstituteLogo(
                  logoUrl: item.logoUrl,
                  name: item.name ?? '',
                  preset: preset,
                  size: 52,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.topic?.name != null) ...[
                        PillChip(item.topic!.name!, tone: PillTone.onDark),
                        const SizedBox(height: 6),
                      ],
                      CustomText(
                        item.name ?? '',
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuietInstituteCard extends StatelessWidget {
  final FeedInstituteItem item;
  final double width;

  const _QuietInstituteCard({required this.item, required this.width});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final preset = presetFor(item.themePreset);
    return ChunkyBox(
      width: width,
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      clip: false,
      onTap: () => _openInstitute(item),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: CoverImage(
                  url: item.coverUrl,
                  fallback: preset.primarySoft,
                  height: 80,
                ),
              ),
              PositionedDirectional(
                start: 12,
                bottom: -20,
                child: InstituteLogo(
                  logoUrl: item.logoUrl,
                  name: item.name ?? '',
                  preset: preset,
                  size: 40,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 26, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.name ?? '',
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  maxLines: 1,
                ),
                if (item.topic?.name != null) ...[
                  const SizedBox(height: 4),
                  CustomText(
                    item.topic!.name!,
                    fontSize: 12,
                    color: c.inkMuted,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(section.title),
        SizedBox(
          height: 236,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _PopIn(
                index: index,
                child: ChunkyBox(
                  width: 172,
                  fill: c.surface,
                  edge: c.lip,
                  borderColor: c.border,
                  onTap: () {
                    if (item.id != null) {
                      CustomNavigator.pushNamed(
                        DetailCoursePage.routeName,
                        arguments: item.id,
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          CoverImage(
                            url: item.coverUrl,
                            fallback: c.primaryTint,
                            height: 112,
                          ),
                          if (item.topic?.name != null)
                            PositionedDirectional(
                              top: 8,
                              start: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: c.surface,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: CustomText(
                                  item.topic!.name!,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: c.primary,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              item.title ?? '',
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              maxLines: 2,
                            ),
                            if (item.instituteName != null &&
                                item.instituteName!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              CustomText(
                                item.instituteName!,
                                fontSize: 12,
                                color: c.inkMuted,
                                maxLines: 1,
                              ),
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
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(section.title),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _PopIn(
              index: i,
              child: ChunkyBox(
                fill: c.surface,
                edge: c.lip,
                borderColor: c.border,
                padding: const EdgeInsets.all(12),
                onTap: () => _openActivity(items[i]),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 44,
                        height: 44,
                        color: c.primaryTint,
                        child: items[i].instituteLogoUrl != null &&
                                items[i].instituteLogoUrl!.isNotEmpty
                            ? Image.network(
                                items[i].instituteLogoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Icon(
                                  Icons.school_rounded,
                                  size: 22,
                                  color: c.primary,
                                ),
                              )
                            : Icon(
                                Icons.school_rounded,
                                size: 22,
                                color: c.primary,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            items[i].title ?? '',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            maxLines: 2,
                          ),
                          if (items[i].instituteName != null &&
                              items[i].instituteName!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            CustomText(
                              items[i].instituteName!,
                              fontSize: 12,
                              color: c.inkMuted,
                              maxLines: 1,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_left_rounded, color: c.locked),
                  ],
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
        CustomNavigator.pushNamed(
          DetailCoursePage.routeName,
          arguments: courseId,
        );
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
