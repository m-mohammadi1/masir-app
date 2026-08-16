import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/helper/jalali_format.dart';
import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/home/page/detail_course_page.dart';
import '/features/institute/data/models/app_notification_model.dart';
import '/features/institute/presentation/bloc/notifications/notifications_bloc.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

class InstituteInboxPage extends StatefulWidget {
  final String instituteId;

  const InstituteInboxPage({super.key, required this.instituteId});

  @override
  State<InstituteInboxPage> createState() => _InstituteInboxPageState();
}

class _InstituteInboxPageState extends State<InstituteInboxPage> {
  late final NotificationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = inject<NotificationsBloc>()..add(const NotificationsEvent.load());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _open(AppNotificationModel item) {
    if (item.id != null) {
      _bloc.add(NotificationsEvent.markRead(item.id!));
    }
    if (item.type == 'announcement.published' && item.announcementId != null) {
      context.go(
        '/i/${widget.instituteId}/announcements/${item.announcementId}',
      );
      return;
    }
    final courseId = item.courseId;
    if (courseId != null && courseId.isNotEmpty) {
      CustomNavigator.pushNamed(
        item.type == 'course.published'
            ? DetailCoursePage.routeName
            : OutlinePage.routeName,
        arguments: item.type == 'course.published'
            ? courseId
            : {
                'id': courseId,
                'title': item.payload['course_title']?.toString() ?? '',
              },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      bloc: _bloc,
      builder: (context, state) {
        return state.when(
          loading: (_) => const SkeletonList(count: 5, itemHeight: 72),
          error: (_, message) => Center(child: CustomText(message)),
          success: (_, items, hasMore, loadingMore) {
            final filtered = items
                .where((item) => item.instituteId == widget.instituteId)
                .toList();
            if (filtered.isEmpty) {
              return const EmptyWidget(
                text: 'اطلاع‌رسانی‌ای نیست',
                description: 'هنوز پیامی از این مؤسسه نرسیده است.',
                icon: Icons.notifications_none,
              );
            }
            return CustomPagination(
              isData: hasMore,
              paginationLoading: loadingMore,
              pagination: hasMore
                  ? () async {
                      _bloc.add(const NotificationsEvent.loadMore());
                    }
                  : null,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => 8.h,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return OnClick(
                    onTap: () => _open(item),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.type == 'announcement.published'
                                ? Icons.campaign_outlined
                                : Icons.menu_book_outlined,
                            color: context.colors.primary,
                          ),
                          12.w,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  item.payload['title']?.toString() ??
                                      item.payload['course_title']
                                          ?.toString() ??
                                      'اطلاع‌رسانی',
                                  fontWeight: item.isUnread
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  maxLines: 2,
                                ),
                                4.h,
                                CustomText(
                                  formatRelativeFa(item.createdAt),
                                  fontSize: 12,
                                  color: context.colors.inkMuted,
                                ),
                              ],
                            ),
                          ),
                          if (item.isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
