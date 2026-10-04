import '/core/feedback/masir_feedback.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/masir_html.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/helper/jalali_format.dart';
import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/announcement_model.dart';
import '/features/institute/data/models/institute_detail_model.dart';
import '/features/institute/data/models/request_institute_id_model.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/announcements/announcements_bloc.dart';
import '/features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart';
import '/features/institute/presentation/bloc/join_institute/join_institute_bloc.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/announcement_preview_card.dart';
import '/features/institute/presentation/widgets/course_card.dart';
import '/features/main/data/models/request_courses_model.dart';
import '/features/main/presentation/bloc/courses/courses_bloc.dart';
import '/features/home/page/detail_course_page.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/pill_chip.dart';
import '/widgets/progress_pill.dart';
import '/widgets/masir_page.dart';
import '/widgets/section_header.dart';
import '/widgets/state_view.dart';
import '/core/helper/route_args.dart';
import '/core/theme/institute_themed.dart';
import '/core/theme/masir_style.dart';

class InstituteHomePage extends StatefulWidget {
  const InstituteHomePage({super.key});

  @override
  State<InstituteHomePage> createState() => _InstituteHomePageState();
}

class _InstituteHomePageState extends State<InstituteHomePage> {
  final coursesBloc = inject<CoursesBloc>();
  bool _coursesLoaded = false;

  void _loadCourses(String instituteId) {
    if (_coursesLoaded) return;
    _coursesLoaded = true;
    coursesBloc.add(
      CoursesEvent.courses(
        params: RequestCoursesModel(instituteId: instituteId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinInstituteBloc, JoinInstituteState>(
      listener: (context, state) {
        state.whenOrNull(
          success: () {
            MasirFeedback.success();
            // Joining makes this the student's current institute.
            context.read<InstituteDetailBloc>().state.whenOrNull(
              success: (_, data) {
                if (data.id != null) {
                  HiveService.setCurrentInstitute(
                    id: data.id!,
                    name: data.name,
                    slug: data.slug,
                    logoUrl: data.logoUrl,
                    themePreset: data.themePreset,
                  );
                }
              },
            );
            context.read<InstituteDetailBloc>().add(
              const InstituteDetailEvent.markJoined(),
            );
            context.read<WalletBloc>().add(const WalletEvent.wallet());
            CustomToast.toast(context, 'حالا عضو این مؤسسه‌ای');
          },
        );
      },
      child: BlocBuilder<InstituteDetailBloc, InstituteDetailState>(
        builder: (context, state) {
          return state.when(
            loading: (_) => const MasirPage.tab(
              title: 'خانه',
              children: [StateView.loading(variant: SkeletonVariant.detail)],
            ),
            error: (_, _) => const MasirPage.tab(
              title: 'خانه',
              children: [SizedBox.shrink()],
            ),
            success: (_, data) {
              _loadCourses(data.id ?? '');
              return MasirPage.tab(
                title: 'خانه',
                children: _homeChildren(context, data),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _homeChildren(
    BuildContext context,
    InstituteDetailModel detail,
  ) {
    final c = context.colors;
    final isMember = detail.membership.isMember;
    final preset = InstituteThemed.presetOf(context);
    return [
      ClipRRect(
        borderRadius: BorderRadius.circular(MasirRadius.hero),
        child: AspectRatio(
          aspectRatio: 2.4,
          child: CoverImage(url: detail.coverUrl, fallback: c.primary),
        ),
      ),
      const SizedBox(height: MasirSpace.lg),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CustomText.title(detail.name ?? '')),
          if (detail.topic?.name != null) PillChip(detail.topic!.name!),
        ],
      ),
      if (isMember && detail.membership.memberSince != null) ...[
        const SizedBox(height: MasirSpace.xs),
        CustomText.caption(
          formatMemberSince(detail.membership.memberSince),
          color: c.inkMuted,
        ),
      ],
      const SizedBox(height: MasirSpace.md),
      Wrap(
        spacing: MasirSpace.sm,
        runSpacing: MasirSpace.sm,
        children: [
          PillChip(
            '${faDigits(detail.courseCount)} دوره',
            icon: Icons.menu_book_rounded,
          ),
          PillChip(
            '${faDigits(detail.teacherCount)} استاد',
            icon: Icons.groups_rounded,
          ),
          PillChip(
            '${faDigits(detail.studentCount)} دانش‌آموز',
            icon: Icons.emoji_people_rounded,
          ),
        ],
      ),
      if (!isMember) ...[
        const SizedBox(height: MasirSpace.xl),
        CustomButton(
          title: 'عضو شو',
          loading: context.watch<JoinInstituteBloc>().state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          ),
          onTap: () {
            context.read<JoinInstituteBloc>().add(
              JoinInstituteEvent.join(
                params: RequestInstituteIdModel(id: detail.id ?? ''),
              ),
            );
          },
        ),
        const SizedBox(height: MasirSpace.sm),
        Center(
          child: CustomText.caption(
            'رایگان و فوری. هر وقت خواستی می‌تونی شروع کنی.',
            color: c.inkMuted,
          ),
        ),
      ],
      if (detail.intro != null && detail.intro!.isNotEmpty) ...[
        const SizedBox(height: MasirSpace.section),
        MasirHtml(detail.intro!),
      ],
      const SizedBox(height: MasirSpace.section),
      ..._homeMiddle(context, detail),
      const SectionHeader('دوره‌ها'),
      BlocBuilder<CoursesBloc, CoursesState>(
        bloc: coursesBloc,
        builder: (context, state) {
          return state.maybeWhen(
            loading: (_) => const StateView.loading(
              variant: SkeletonVariant.cards,
              count: 2,
            ),
            success: (_, data) {
              if (data.isEmpty) {
                return CustomText.body(
                  'هنوز دوره‌ای نیومده. به‌زودی!',
                  color: c.inkMuted,
                );
              }
              return Column(
                children: [
                  for (final course in data) ...[
                    CourseCard(
                      course: course,
                      // Course details first: it holds the sign-up button
                      // and the way into the roadmap.
                      onTap: () => CustomNavigator.pushNamed(
                        DetailCoursePage.routeName,
                        arguments: courseDetailArgs(
                          course.id ?? '',
                          themePreset: preset,
                        ),
                      ),
                    ),
                    const SizedBox(height: MasirSpace.md),
                  ],
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
      if (detail.links.isNotEmpty) ...[
        const SizedBox(height: MasirSpace.md),
        Row(
          children: [
            for (final link in detail.links)
              if (link.url != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: MasirSpace.md),
                  child: ChunkyBox(
                    width: 48,
                    height: 48,
                    radius: MasirRadius.row,
                    fill: c.surface,
                    edge: c.lip,
                    borderColor: c.border,
                    alignment: Alignment.center,
                    onTap: () => launchUrl(Uri.parse(link.url!)),
                    child: Icon(_iconFor(link.kind), color: c.primary),
                  ),
                ),
          ],
        ),
      ],
    ];
  }

  List<Widget> _homeMiddle(BuildContext context, InstituteDetailModel detail) {
    final announcementsState = context.watch<AnnouncementsBloc>().state;
    final announcements = announcementsState.maybeWhen(
      success: (_, items, _, _) => items,
      orElse: () => const <AnnouncementModel>[],
    );
    final unreadOnTop = announcements.any((item) => item.isUnread);
    final announcementsSlot = _AnnouncementsHomeSlot(
      instituteId: detail.id ?? '',
      items: announcements,
    );
    final continueCard = BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        final card = walletState.whenOrNull(
          success: (_, data) {
            for (final item in data) {
              if (item.instituteId == detail.id) return item;
            }
            return null;
          },
        );
        if (card?.nextAction == null) return const SizedBox.shrink();
        return _ContinueCard(card: card!);
      },
    );
    const gap = SizedBox(height: MasirSpace.section);
    if (announcements.isEmpty) return [continueCard, gap];
    if (unreadOnTop) return [announcementsSlot, gap, continueCard, gap];
    return [continueCard, gap, announcementsSlot, gap];
  }

  IconData _iconFor(String? kind) {
    switch (kind) {
      case 'instagram':
        return Icons.camera_alt_rounded;
      case 'telegram':
        return Icons.send_rounded;
      default:
        return Icons.language_rounded;
    }
  }
}

class _AnnouncementsHomeSlot extends StatelessWidget {
  final String instituteId;
  final List<AnnouncementModel> items;

  const _AnnouncementsHomeSlot({
    required this.instituteId,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final preview = items.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          'اطلاعیه‌ها',
          actionLabel: 'همه',
          onAction: () => context.push('/i/$instituteId/announcements'),
        ),
        for (final item in preview) ...[
          AnnouncementPreviewCard(
            item: item,
            onTap: () =>
                context.push('/i/$instituteId/announcements/${item.id}'),
          ),
          const SizedBox(height: MasirSpace.md),
        ],
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final WalletCardModel card;

  const _ContinueCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final action = card.nextAction!;
    return ChunkyBox(
      fill: c.primary,
      edge: c.primaryEdge,
      radius: MasirRadius.hero,
      padding: const EdgeInsets.all(MasirSpace.card),
      onTap: () {
        if (action.courseId != null) {
          CustomNavigator.pushNamed(
            OutlinePage.routeName,
            arguments: withThemePreset({
              'id': action.courseId!,
              'title': action.courseTitle ?? '',
            }, InstituteThemed.presetOf(context)),
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.caption(
                  'ادامه یادگیری',
                  color: c.onPrimary.withValues(alpha: 0.85),
                ),
                const SizedBox(height: MasirSpace.xs),
                CustomText.headline(
                  action.unitTitle ?? action.courseTitle ?? '',
                  color: c.onPrimary,
                  maxLines: 2,
                ),
                const SizedBox(height: MasirSpace.md),
                ProgressPill(
                  value: action.progressPercent,
                  color: c.onPrimary,
                  trackColor: c.onPrimary.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: MasirSpace.lg),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: c.onPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow_rounded, color: c.primary, size: 32),
          ),
        ],
      ),
    );
  }
}
