import '/core/helper/go_back.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/masir_style.dart';
import '/features/institute/presentation/bloc/announcements/announcements_bloc.dart';
import '/features/institute/presentation/widgets/announcement_preview_card.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';

class InstituteAnnouncementsPage extends StatelessWidget {
  final String instituteId;

  const InstituteAnnouncementsPage({super.key, required this.instituteId});

  void _back(BuildContext context) =>
      goBack(context, fallback: '/i/$instituteId/home');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
      builder: (context, state) {
        return state.when(
          loading: (_) => MasirPage.detail(
            title: 'اطلاعیه‌ها',
            onBack: () => _back(context),
            body: const StateView.loading(),
          ),
          error: (_, message) => MasirPage.detail(
            title: 'اطلاعیه‌ها',
            onBack: () => _back(context),
            body: StateView.error(message: message),
          ),
          success: (_, items, hasMore, loadingMore) {
            if (items.isEmpty) {
              return MasirPage.detail(
                title: 'اطلاعیه‌ها',
                onBack: () => _back(context),
                body: const StateView.empty(
                  text: 'اطلاعیه‌ای نیست',
                  description: 'هنوز اطلاعیه‌ای در این مؤسسه منتشر نشده.',
                  icon: Icons.campaign_rounded,
                ),
              );
            }
            return MasirPage.detail(
              title: 'اطلاعیه‌ها',
              onBack: () => _back(context),
              body: CustomPagination(
                isData: hasMore,
                paginationLoading: loadingMore,
                pagination: hasMore
                    ? () async {
                        context.read<AnnouncementsBloc>().add(
                          const AnnouncementsEvent.loadMore(),
                        );
                      }
                    : null,
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    top: MasirSpace.sm,
                    bottom: MasirSpace.xl,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: MasirSpace.md),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AnnouncementPreviewCard(
                      item: item,
                      onTap: () => context.push(
                        '/i/$instituteId/announcements/${item.id}',
                      ),
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
