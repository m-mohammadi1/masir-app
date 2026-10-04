import '/core/helper/go_back.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/masir_html.dart';

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
import '/core/helper/route_args.dart';
import '/core/theme/institute_themed.dart';
import '/widgets/custom_text.dart';
import '/widgets/masir_page.dart';
import '/widgets/pill_chip.dart';
import '/widgets/state_view.dart';
import '/core/theme/masir_style.dart';

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
    result.fold(
      (_) {
        if (!mounted) return;
        CustomNavigator.pushNamed(
          DetailCoursePage.routeName,
          arguments: courseDetailArgs(
            courseId,
            themePreset: InstituteThemed.presetOf(context),
          ),
        );
      },
      (detail) {
        if (!mounted) return;
        final preset =
            detail.coursesModel?.institute?.themePreset ??
            InstituteThemed.presetOf(context);
        final subscribed = detail.coursesModel?.isSubscribed == true;
        if (!subscribed) {
          CustomNavigator.pushNamed(
            DetailCoursePage.routeName,
            arguments: courseDetailArgs(courseId, themePreset: preset),
          );
          return;
        }
        CustomNavigator.pushNamed(
          OutlinePage.routeName,
          arguments: withThemePreset({
            'id': courseId,
            'title': detail.coursesModel?.title ?? '',
            if (moduleId != null && moduleId.isNotEmpty) 'moduleId': moduleId,
          }, preset),
        );
      },
    );
  }

  void _back() =>
      goBack(context, fallback: '/i/${widget.instituteId}/announcements');

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
          loading: (_) => MasirPage.detail(
            title: 'اطلاعیه',
            onBack: _back,
            body: const StateView.loading(variant: SkeletonVariant.detail),
          ),
          error: (_, message) => MasirPage.detail(
            title: 'اطلاعیه',
            onBack: _back,
            body: StateView.error(message: message),
          ),
          success: (_, data) {
            return MasirPage.detail(
              title: 'اطلاعیه',
              onBack: _back,
              children: [
                CustomText.title(data.title ?? ''),
                const SizedBox(height: MasirSpace.sm),
                CustomText.caption(
                  formatRelativeFa(data.publishedAt),
                  color: context.colors.inkMuted,
                ),
                if (data.courseTitle != null &&
                    data.courseTitle!.isNotEmpty) ...[
                  const SizedBox(height: MasirSpace.md),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: PillChip(
                      data.courseTitle!,
                      icon: Icons.menu_book_rounded,
                    ),
                  ),
                ],
                if (data.body != null && data.body!.isNotEmpty) ...[
                  const SizedBox(height: MasirSpace.lg),
                  MasirHtml(data.body!),
                ],
                if (data.moduleId != null &&
                    data.moduleId!.isNotEmpty &&
                    data.courseId != null) ...[
                  const SizedBox(height: MasirSpace.xl),
                  CustomButton(
                    title: 'رفتن به فصل',
                    onTap: () => _goToModule(data.courseId!, data.moduleId),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
