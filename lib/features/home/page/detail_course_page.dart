import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/masir_html.dart';
import 'package:mohammad/core/helper/route_args.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/course_detail_model.dart';
import 'package:mohammad/features/main/data/models/request_course_detail_model.dart';
import 'package:mohammad/features/main/data/models/request_subscribe_course_model.dart';
import 'package:mohammad/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import 'package:mohammad/features/main/presentation/bloc/subscribe_course/subscribe_course_bloc.dart';
import 'package:mohammad/features/main/presentation/page/outline_page.dart';
import 'package:mohammad/widgets/brand_media.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import '/core/theme/masir_style.dart';
import 'package:mohammad/widgets/custom_button.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/institute_themed.dart';
import '/widgets/masir_card.dart';
import '/widgets/masir_page.dart';
import '/widgets/section_header.dart';
import '/widgets/state_view.dart';
import '/widgets/stat_tile.dart';
import '/features/main/data/models/courses_model.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../../main/data/models/my_subscriptions_model.dart';
import '../../main/presentation/bloc/course_detail/course_detail_bloc.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class DetailCoursePage extends StatefulWidget {
  final String id;

  /// Institute theme carried over from the screen that opened this course.
  final String? themePreset;
  static const String routeName = "/detail-course";

  const DetailCoursePage({super.key, required this.id, this.themePreset});

  @override
  State<DetailCoursePage> createState() => _DetailCoursePageState();
}

class _DetailCoursePageState extends State<DetailCoursePage> {
  final coursesBloc = inject<CourseDetailBloc>();
  final mySubsBloc = inject<MySubscriptionsBloc>();
  final subscribeCourseBloc = inject<SubscribeCourseBloc>();

  late CourseDetailModel dataModel;

  @override
  void initState() {
    super.initState();
    mySubsBloc.add(MySubscriptionsEvent.mySubscriptions());
    coursesBloc.add(
      CourseDetailEvent.courseDetail(
        params: RequestCourseDetailModel(id: widget.id),
      ),
    );
  }

  String? _levelLabel(String? level) {
    switch (level) {
      case 'beginner':
        return 'مقدماتی';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'پیشرفته';
      default:
        return null;
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return '';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0 && minutes > 0) return '$hours ساعت و $minutes دقیقه';
    if (hours > 0) return '$hours ساعت';
    return '$minutes دقیقه';
  }

  void _openOutline(CourseDetailModel data) {
    CustomNavigator.pushNamed(
      OutlinePage.routeName,
      arguments: withThemePreset({
        'id': data.coursesModel?.id ?? widget.id,
        'title': data.coursesModel?.title ?? '',
      }, data.coursesModel?.institute?.themePreset ?? widget.themePreset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailBloc, CourseDetailState>(
      bloc: coursesBloc,
      builder: (context, state) {
        final loadedPreset = state.whenOrNull(
          success: (_, data) => data.coursesModel?.institute?.themePreset,
        );
        return InstituteThemed(
          preset: loadedPreset ?? widget.themePreset,
          child: Builder(builder: (context) => _buildPage(context, state)),
        );
      },
    );
  }

  Widget _buildPage(BuildContext context, CourseDetailState state) {
    return state.when(
      loading: (_) => const MasirPage.detail(
        title: 'دوره',
        body: StateView.loading(variant: SkeletonVariant.detail),
      ),
      error: (_, message) => MasirPage.detail(
        title: 'دوره',
        body: StateView.error(
          message: message,
          retry: () => coursesBloc.add(
            CourseDetailEvent.courseDetail(
              params: RequestCourseDetailModel(id: widget.id),
            ),
          ),
        ),
      ),
      success: (isLoading, data) {
        dataModel = data;
        final c = context.colors;
        final course = data.coursesModel;
        final coverUrl =
            (course?.coverUrl != null && course!.coverUrl!.isNotEmpty)
            ? course.coverUrl
            : course?.institute?.coverUrl;
        final outcomes = course?.outcomes ?? const <String>[];
        final requirements = course?.requirements ?? const <String>[];
        final intro = course?.intro?.trim() ?? '';
        final levelLabel = _levelLabel(course?.level);
        final topicName = course?.topic?.name;
        final duration = _formatDuration(course?.totalDurationSeconds);
        final previewCount = course?.previewUnitCount ?? 0;
        final isSubscribed =
            course?.isSubscribed == true ||
            mySubsBloc.values.any((e) => e.courseId == widget.id);

        return MasirPage.detail(
          title: 'دوره',
          stickyBottom: _buildCta(
            course: course,
            isLoading: isLoading,
            isSubscribed: isSubscribed,
            previewCount: previewCount,
          ),
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(MasirRadius.hero),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: CoverImage(url: coverUrl, fallback: c.primary),
                  ),
                ),
                PositionedDirectional(
                  bottom: MasirSpace.md,
                  start: MasirSpace.md,
                  end: MasirSpace.md,
                  child: Wrap(
                    spacing: MasirSpace.sm,
                    runSpacing: MasirSpace.xs,
                    children: [
                      if (levelLabel != null)
                        PillChip(
                          levelLabel,
                          icon: Icons.signal_cellular_alt_rounded,
                          tone: PillTone.onDark,
                        ),
                      if (topicName != null)
                        PillChip(topicName, tone: PillTone.onDark),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: MasirSpace.lg),
            CustomText.display(course?.title ?? '', color: c.ink),
            if (course?.institute?.name != null &&
                course!.institute!.name!.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.xs),
              CustomText.bodyStrong(course.institute!.name!, color: c.primary),
            ],
            if (data.teachers.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.md),
              CourseTeacherRow(
                teachers: data.teachers,
                compact: false,
                showHeadlines: true,
              ),
            ],
            const SizedBox(height: MasirSpace.lg),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.folder_rounded,
                    value: faDigits(data.moduleCount ?? 0),
                    label: 'فصل',
                  ),
                ),
                const SizedBox(width: MasirSpace.sm),
                Expanded(
                  child: StatTile(
                    icon: Icons.play_lesson_rounded,
                    value: faDigits(data.unitCount ?? 0),
                    label: 'واحد',
                  ),
                ),
                if (duration.isNotEmpty) ...[
                  const SizedBox(width: MasirSpace.sm),
                  Expanded(
                    flex: 2,
                    child: StatTile(
                      icon: Icons.schedule_rounded,
                      value: duration,
                      label: 'مدت',
                    ),
                  ),
                ],
              ],
            ),
            if (!isSubscribed && previewCount > 0) ...[
              const SizedBox(height: MasirSpace.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: MasirSpace.lg,
                  vertical: MasirSpace.md,
                ),
                decoration: BoxDecoration(
                  color: c.sunSoft,
                  borderRadius: BorderRadius.circular(MasirRadius.row),
                ),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard_rounded, color: c.sunEdge),
                    const SizedBox(width: MasirSpace.sm),
                    Expanded(
                      child: CustomText.bodyStrong(
                        '${faDigits(previewCount)} واحد اول رایگان است',
                        color: c.sunEdge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (outcomes.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.section),
              const SectionHeader('توی این دوره چی یاد می‌گیری؟'),
              MasirCard(
                child: Column(
                  children: [
                    for (var i = 0; i < outcomes.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == outcomes.length - 1 ? 0 : MasirSpace.md,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: c.green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: MasirIconSize.sm,
                                color: c.onPrimary,
                              ),
                            ),
                            const SizedBox(width: MasirSpace.md),
                            Expanded(
                              child: CustomText.body(outcomes[i], color: c.ink),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (intro.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.section),
              MasirHtml(intro),
            ],
            if (requirements.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.section),
              const SectionHeader('پیش‌نیازها'),
              for (final item in requirements)
                Padding(
                  padding: const EdgeInsets.only(bottom: MasirSpace.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: MasirSpace.sm),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: c.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: MasirSpace.md),
                      Expanded(child: CustomText.body(item, color: c.ink)),
                    ],
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCta({
    required CoursesModel? course,
    required bool isLoading,
    required bool isSubscribed,
    required int previewCount,
  }) {
    final isFree = course?.price == null || course?.price == 0;
    return BlocBuilder<MySubscriptionsBloc, MySubscriptionsState>(
      bloc: mySubsBloc,
      builder: (context, subState) {
        final c = context.colors;
        return BlocConsumer<SubscribeCourseBloc, SubscribeCourseState>(
          bloc: subscribeCourseBloc,
          listener: (context, sub) {
            sub.whenOrNull(
              error: (isLoading, message) {
                CustomToast.toast(context, message);
              },
              success: (isLoading, value) {
                mySubsBloc.values.add(
                  MySubscriptionsModel(courseId: widget.id),
                );
                CustomToast.toast(context, 'عضو دوره شدی! بزن بریم');
                setState(() {});
              },
            );
          },
          builder: (context, sub) {
            final subscribed =
                isSubscribed ||
                mySubsBloc.values.any((e) => e.courseId == widget.id);
            final title = subscribed ? 'شروع یادگیری' : 'شروع رایگان';
            final busy = isLoading || subState.isLoading || sub.isLoading;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!subscribed) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText.caption('قیمت', color: c.inkMuted),
                          CustomText.headline(
                            isFree
                                ? 'رایگان'
                                : formatPrice(
                                    course?.price ?? 0,
                                    unit: 'تومان',
                                  ),
                            color: c.primary,
                          ),
                        ],
                      ),
                      const SizedBox(width: MasirSpace.lg),
                    ],
                    Expanded(
                      child: CustomButton(
                        title: title,
                        loading: busy,
                        enable: !isLoading && !subState.isLoading,
                        onTap: () {
                          if (subscribed) {
                            _openOutline(dataModel);
                            return;
                          }
                          // Payment is not wired yet, so every course can be
                          // joined for free for now.
                          subscribeCourseBloc.add(
                            SubscribeCourseEvent.subscribeCourse(
                              params: RequestSubscribeCourseModel(
                                id: widget.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (!subscribed && previewCount > 0) ...[
                  const SizedBox(height: MasirSpace.sm),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openOutline(dataModel),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: MasirSpace.xs,
                      ),
                      child: CustomText.bodyStrong(
                        'اول پیش‌نمایش رایگان رو ببین',
                        color: c.primary,
                        textAlign: TextAlign.center,
                      ),
                    ),
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
