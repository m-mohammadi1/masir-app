import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/helper/jalali_format.dart';
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
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/pill_chip.dart';
import '/widgets/progress_pill.dart';
import '/widgets/skeleton.dart';

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
            context.read<InstituteDetailBloc>().add(
              const InstituteDetailEvent.markJoined(),
            );
            context.read<WalletBloc>().add(const WalletEvent.wallet());
            CustomToast.toast(context, 'شما اکنون در این مؤسسه هستید');
          },
        );
      },
      child: BlocBuilder<InstituteDetailBloc, InstituteDetailState>(
        builder: (context, state) {
          return state.when(
            loading: (_) => const SkeletonList(count: 4, itemHeight: 120),
            error: (_, _) => const SizedBox.shrink(),
            success: (_, data) {
              _loadCourses(data.id ?? '');
              return _HomeBody(detail: data, coursesBloc: coursesBloc);
            },
          );
        },
      ),
    );
  }
}

String _digits(int n) => toPersianDigits(n.toString());

class _HomeBody extends StatelessWidget {
  final InstituteDetailModel detail;
  final CoursesBloc coursesBloc;

  const _HomeBody({required this.detail, required this.coursesBloc});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isMember = detail.membership.isMember;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 2.4,
            child: CoverImage(url: detail.coverUrl, fallback: c.primary),
          ),
        ),
        16.h,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomText(
                detail.name ?? '',
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            if (detail.topic?.name != null) PillChip(detail.topic!.name!),
          ],
        ),
        if (isMember && detail.membership.memberSince != null) ...[
          4.h,
          CustomText(
            formatMemberSince(detail.membership.memberSince),
            fontSize: 13,
            color: c.inkMuted,
          ),
        ],
        12.h,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            PillChip('${_digits(detail.courseCount)} دوره', icon: Icons.menu_book_rounded),
            PillChip('${_digits(detail.teacherCount)} استاد', icon: Icons.groups_rounded),
            PillChip('${_digits(detail.studentCount)} دانش‌آموز', icon: Icons.emoji_people_rounded),
          ],
        ),
        if (!isMember) ...[
          20.h,
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
          8.h,
          Center(
            child: CustomText(
              'رایگان و فوری. هر وقت خواستی می‌توانی شروع کنی.',
              fontSize: 12,
              color: c.inkMuted,
            ),
          ),
        ],
        if (detail.intro != null && detail.intro!.isNotEmpty) ...[
          20.h,
          Html(
            data: detail.intro!,
            style: {
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(16),
                fontFamily: 'Masir',
                lineHeight: const LineHeight(1.7),
                color: c.ink,
                textAlign: TextAlign.right,
                direction: TextDirection.rtl,
              ),
            },
          ),
        ],
        20.h,
        ..._homeMiddle(context, detail),
        24.h,
        const CustomText('دوره‌ها', fontWeight: FontWeight.w800, fontSize: 18),
        12.h,
        BlocBuilder<CoursesBloc, CoursesState>(
          bloc: coursesBloc,
          builder: (context, state) {
            return state.maybeWhen(
              loading: (_) => const SkeletonList(count: 3, itemHeight: 96),
              success: (_, data) {
                if (data.isEmpty) {
                  return CustomText(
                    'هنوز دوره‌ای منتشر نشده. به‌زودی!',
                    color: c.inkMuted,
                  );
                }
                return Column(
                  children: [
                    for (final course in data) ...[
                      CourseCard(
                        course: course,
                        locked: !isMember,
                        onTap: isMember
                            ? () => CustomNavigator.pushNamed(
                                OutlinePage.routeName,
                                arguments: {
                                  'id': course.id ?? '',
                                  'title': course.title ?? '',
                                },
                              )
                            : null,
                      ),
                      12.h,
                    ],
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
        if (detail.links.isNotEmpty) ...[
          12.h,
          Row(
            children: [
              for (final link in detail.links)
                if (link.url != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: ChunkyBox(
                      width: 48,
                      height: 48,
                      radius: 16,
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
      ],
    );
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
    if (announcements.isEmpty) return [continueCard];
    if (unreadOnTop) {
      return [announcementsSlot, 16.h, continueCard];
    }
    return [continueCard, 16.h, announcementsSlot];
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
        const CustomText('اطلاعیه‌ها', fontWeight: FontWeight.w800, fontSize: 18),
        12.h,
        for (final item in preview) ...[
          AnnouncementPreviewCard(
            item: item,
            onTap: () => context.go('/i/$instituteId/announcements/${item.id}'),
          ),
          12.h,
        ],
        OnClick(
          onTap: () => context.go('/i/$instituteId/announcements'),
          child: CustomText(
            'همه‌ی اطلاعیه‌ها',
            color: context.colors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
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
      radius: 24,
      padding: const EdgeInsets.all(16),
      onTap: () {
        if (action.courseId != null) {
          CustomNavigator.pushNamed(
            OutlinePage.routeName,
            arguments: {
              'id': action.courseId!,
              'title': action.courseTitle ?? '',
            },
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'ادامه یادگیری',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.onPrimary.withValues(alpha: 0.85),
                ),
                4.h,
                CustomText(
                  action.unitTitle ?? action.courseTitle ?? '',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: c.onPrimary,
                  maxLines: 2,
                ),
                12.h,
                ProgressPill(
                  value: action.progressPercent,
                  color: c.onPrimary,
                  trackColor: c.onPrimary.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
          16.w,
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
