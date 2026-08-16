import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/features/institute/presentation/bloc/announcements/announcements_bloc.dart';
import '/features/institute/presentation/widgets/announcement_preview_card.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

class InstituteAnnouncementsPage extends StatelessWidget {
  final String instituteId;

  const InstituteAnnouncementsPage({super.key, required this.instituteId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
      builder: (context, state) {
        return state.when(
          loading: (_) => const SkeletonList(count: 4, itemHeight: 96),
          error: (_, message) => Center(child: CustomText(message)),
          success: (_, items, hasMore, loadingMore) {
            if (items.isEmpty) {
              return const EmptyWidget(
                text: 'اطلاعیه‌ای نیست',
                description: 'هنوز اطلاعیه‌ای در این مؤسسه منتشر نشده است.',
                icon: Icons.campaign_outlined,
              );
            }
            return CustomPagination(
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: items.length,
                separatorBuilder: (_, _) => 12.h,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return AnnouncementPreviewCard(
                    item: item,
                    onTap: () => context.go(
                      '/i/$instituteId/announcements/${item.id}',
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
