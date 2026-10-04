import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '/core/helper/jalali_format.dart';
import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/home/page/detail_course_page.dart';
import '/features/institute/presentation/bloc/announcement_detail/announcement_detail_bloc.dart';
import '/features/institute/presentation/bloc/announcements/announcements_bloc.dart';
import '/features/main/data/models/request_course_detail_model.dart';
import '/features/main/domain/usecases/course_detail_usecase.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/skeleton.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final String instituteId;
  final String announcementId;

  const AnnouncementDetailPage({
    super.key,
    required this.instituteId,
    required this.announcementId,
  });

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  late final AnnouncementDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = inject<AnnouncementDetailBloc>()
      ..add(
        AnnouncementDetailEvent.load(
          instituteId: widget.instituteId,
          announcementId: widget.announcementId,
        ),
      );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _goToModule(String courseId, String? moduleId) async {
    final result = await inject<CourseDetailUseCase>()(
      params: RequestCourseDetailModel(id: courseId),
    );
    result.fold((_) {
      if (!mounted) return;
      CustomNavigator.pushNamed(
        DetailCoursePage.routeName,
        arguments: courseId,
      );
    }, (detail) {
      if (!mounted) return;
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
          'title': detail.coursesModel?.title ?? '',
          if (moduleId != null && moduleId.isNotEmpty) 'moduleId': moduleId,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnouncementDetailBloc, AnnouncementDetailState>(
      bloc: _bloc,
      listener: (context, state) {
        state.whenOrNull(
          success: (_, data) {
            if (data.id != null) {
              context.read<AnnouncementsBloc>().add(
                AnnouncementsEvent.markLocalRead(data.id!),
              );
            }
          },
        );
      },
      builder: (context, state) {
        return state.when(
          loading: (_) => const SkeletonList(count: 3, itemHeight: 80),
          error: (_, message) => Center(child: CustomText(message)),
          success: (_, data) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                CustomText(
                  data.title ?? '',
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
                8.h,
                CustomText(
                  formatRelativeFa(data.publishedAt),
                  fontSize: 12,
                  color: context.colors.inkMuted,
                ),
                if (data.courseTitle != null && data.courseTitle!.isNotEmpty) ...[
                  12.h,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primaryTint,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomText(
                        data.courseTitle!,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ],
                if (data.body != null && data.body!.isNotEmpty) ...[
                  16.h,
                  Html(
                    data: data.body!,
                    style: {
                      'body': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16),
                        fontFamily: 'Masir',
                        lineHeight: const LineHeight(1.7),
                        color: context.colors.ink,
                        textAlign: TextAlign.right,
                        direction: TextDirection.rtl,
                      ),
                    },
                  ),
                ],
                if (data.moduleId != null &&
                    data.moduleId!.isNotEmpty &&
                    data.courseId != null) ...[
                  24.h,
                  CustomButton(
                    title: 'رفتن به فصل',
                    onTap: () => _goToModule(data.courseId!, data.moduleId),
                  ),
                ],
                16.h,
                OnClick(
                  onTap: () =>
                      context.go('/i/${widget.instituteId}/announcements'),
                  child: CustomText(
                    'همه‌ی اطلاعیه‌ها',
                    color: context.colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
