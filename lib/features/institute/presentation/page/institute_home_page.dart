import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/helper/jalali_format.dart';
import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/institute_detail_model.dart';
import '/features/institute/data/models/request_institute_id_model.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart';
import '/features/institute/presentation/bloc/join_institute/join_institute_bloc.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/main/data/models/request_courses_model.dart';
import '/features/main/presentation/bloc/courses/courses_bloc.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
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

class _HomeBody extends StatelessWidget {
  final InstituteDetailModel detail;
  final CoursesBloc coursesBloc;

  const _HomeBody({required this.detail, required this.coursesBloc});

  @override
  Widget build(BuildContext context) {
    final isMember = detail.membership.isMember;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (detail.coverUrl != null && detail.coverUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 3 / 1,
              child: Image.network(detail.coverUrl!, fit: BoxFit.cover),
            ),
          ),
        12.h,
        Row(
          children: [
            Expanded(
              child: CustomText(
                detail.name ?? '',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (detail.topic?.name != null)
              CustomText(
                detail.topic!.name!,
                fontSize: 12,
                color: context.colors.inkMuted,
              ),
          ],
        ),
        if (isMember && detail.membership.memberSince != null) ...[
          4.h,
          CustomText(
            formatMemberSince(detail.membership.memberSince),
            fontSize: 12,
            color: context.colors.inkMuted,
          ),
        ],
        if (!isMember) ...[
          16.h,
          CustomButton(
            title: 'عضو شوید',
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
        ],
        if (detail.intro != null && detail.intro!.isNotEmpty) ...[
          16.h,
          Html(
            data: detail.intro!,
            style: {
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(16),
                color: context.colors.ink,
                textAlign: TextAlign.right,
                direction: TextDirection.rtl,
              ),
            },
          ),
        ],
        16.h,
        BlocBuilder<WalletBloc, WalletState>(
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
        ),
        16.h,
        CustomText('دوره‌ها', fontWeight: FontWeight.w600, fontSize: 16),
        8.h,
        BlocBuilder<CoursesBloc, CoursesState>(
          bloc: coursesBloc,
          builder: (context, state) {
            return state.maybeWhen(
              loading: (_) => const SkeletonList(count: 3, itemHeight: 72),
              success: (_, data) {
                if (data.isEmpty) {
                  return CustomText(
                    'دوره‌ای منتشر نشده',
                    color: context.colors.inkMuted,
                  );
                }
                return Column(
                  children: [
                    for (final course in data)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Opacity(
                          opacity: isMember ? 1 : 0.55,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: context.colors.border),
                            ),
                            title: CustomText(course.title ?? ''),
                            trailing: isMember
                                ? const Icon(Icons.chevron_left)
                                : Icon(
                                    Icons.lock_outline,
                                    color: context.colors.inkMuted,
                                  ),
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
                        ),
                      ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
        16.h,
        Row(
          children: [
            CustomText(
              '${detail.courseCount} دوره',
              fontSize: 12,
              color: context.colors.inkMuted,
            ),
            16.w,
            CustomText(
              '${detail.studentCount} دانش‌آموز',
              fontSize: 12,
              color: context.colors.inkMuted,
            ),
          ],
        ),
        if (detail.links.isNotEmpty) ...[
          16.h,
          Wrap(
            spacing: 12,
            children: [
              for (final link in detail.links)
                if (link.url != null)
                  IconButton(
                    onPressed: () => launchUrl(Uri.parse(link.url!)),
                    icon: Icon(_iconFor(link.kind), color: context.colors.primary),
                  ),
            ],
          ),
        ],
        24.h,
        const SizedBox(height: 8),
      ],
    );
  }

  IconData _iconFor(String? kind) {
    switch (kind) {
      case 'instagram':
        return Icons.camera_alt_outlined;
      case 'telegram':
        return Icons.send;
      default:
        return Icons.language;
    }
  }
}

class _ContinueCard extends StatelessWidget {
  final WalletCardModel card;

  const _ContinueCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final action = card.nextAction!;
    return OnClick(
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.primaryTint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText('ادامه یادگیری', fontWeight: FontWeight.w600),
            4.h,
            CustomText(
              action.unitTitle ?? action.courseTitle ?? '',
              color: context.colors.inkMuted,
            ),
            8.h,
            LinearProgressIndicator(
              value: (action.progressPercent.clamp(0, 100)) / 100,
              color: context.colors.primary,
              backgroundColor: context.colors.ink.withValues(alpha: 0.08),
            ),
          ],
        ),
      ),
    );
  }
}
