import '/core/helper/go_back.dart';
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
import '/core/helper/route_args.dart';
import '/core/theme/institute_themed.dart';
import '/core/theme/masir_style.dart';
import '/widgets/icon_tile.dart';
import '/widgets/list_row.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';

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
      context.push(
        '/i/${widget.instituteId}/announcements/${item.announcementId}',
      );
      return;
    }
    final courseId = item.courseId;
    if (courseId != null && courseId.isNotEmpty) {
      final preset = InstituteThemed.presetOf(context);
      CustomNavigator.pushNamed(
        item.type == 'course.published'
            ? DetailCoursePage.routeName
            : OutlinePage.routeName,
        arguments: item.type == 'course.published'
            ? courseDetailArgs(courseId, themePreset: preset)
            : withThemePreset({
                'id': courseId,
                'title': item.payload['course_title']?.toString() ?? '',
              }, preset),
      );
    }
  }

  void _back() => goBack(context, fallback: '/i/${widget.instituteId}/home');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      bloc: _bloc,
      builder: (context, state) {
        return state.when(
          loading: (_) => MasirPage.detail(
            title: 'اطلاع‌رسانی‌ها',
            onBack: _back,
            body: const StateView.loading(),
          ),
          error: (_, message) => MasirPage.detail(
            title: 'اطلاع‌رسانی‌ها',
            onBack: _back,
            body: StateView.error(message: message),
          ),
          success: (_, items, hasMore, loadingMore) {
            final filtered = items
                .where((item) => item.instituteId == widget.instituteId)
                .toList();
            if (filtered.isEmpty) {
              return MasirPage.detail(
                title: 'اطلاع‌رسانی‌ها',
                onBack: _back,
                body: const StateView.empty(
                  text: 'اطلاع‌رسانی‌ای نیست',
                  description: 'هنوز پیامی از این مؤسسه نرسیده.',
                  icon: Icons.notifications_rounded,
                ),
              );
            }
            return MasirPage.detail(
              title: 'اطلاع‌رسانی‌ها',
              onBack: _back,
              body: CustomPagination(
                isData: hasMore,
                paginationLoading: loadingMore,
                pagination: hasMore
                    ? () async {
                        _bloc.add(const NotificationsEvent.loadMore());
                      }
                    : null,
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    top: MasirSpace.sm,
                    bottom: MasirSpace.xl,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: MasirSpace.md),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return ListRow(
                      highlighted: item.isUnread,
                      leading: IconTile(
                        item.type == 'announcement.published'
                            ? Icons.campaign_rounded
                            : Icons.menu_book_rounded,
                      ),
                      title:
                          item.payload['title']?.toString() ??
                          item.payload['course_title']?.toString() ??
                          'اطلاع‌رسانی',
                      subtitle: formatRelativeFa(item.createdAt),
                      trailing: item.isUnread
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                      onTap: () => _open(item),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
