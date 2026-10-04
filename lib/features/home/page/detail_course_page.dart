import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/course_detail_model.dart';
import 'package:mohammad/features/main/data/models/request_course_detail_model.dart';
import 'package:mohammad/features/main/data/models/request_subscribe_course_model.dart';
import 'package:mohammad/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import 'package:mohammad/features/main/presentation/bloc/subscribe_course/subscribe_course_bloc.dart';
import 'package:mohammad/features/main/presentation/page/outline_page.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/back_button.dart';
import 'package:mohammad/widgets/brand_media.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import '/core/theme/masir_style.dart';
import '/features/main/presentation/page/outline/roadmap/paper_theme.dart'
    show persianDigits;
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../../main/data/models/my_subscriptions_model.dart';
import '../../main/presentation/bloc/course_detail/course_detail_bloc.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';
import '/widgets/custom_error.dart';

class DetailCoursePage extends StatefulWidget {
  final String id;
  static const String routeName = "/detail-course";

  const DetailCoursePage({super.key, required this.id});

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
      arguments: {
        'id': data.coursesModel?.id ?? widget.id,
        'title': data.coursesModel?.title ?? '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: BlocBuilder<CourseDetailBloc, CourseDetailState>(
        bloc: coursesBloc,
        builder: (context, state) {
          return state.when(
            loading: (_) => Column(
              children: [
                CustomAppBar(title: 'دوره'),
                const Expanded(child: Center(child: CustomLoading())),
              ],
            ),
            error: (_, message) => Column(
              children: [
                CustomAppBar(title: 'دوره'),
                Expanded(child: CustomError(message: message)),
              ],
            ),
            success: (isLoading, data) {
              dataModel = data;
              final course = data.coursesModel;
              final coverUrl =
                  (course?.coverUrl != null && course!.coverUrl!.isNotEmpty)
                  ? course.coverUrl
                  : course?.institute?.coverUrl;
              final isFree = course?.price == null || course?.price == 0;
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

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                MasirRadius.sheet,
                              ),
                              child: AspectRatio(
                                aspectRatio: 16 / 10,
                                child: CoverImage(
                                  url: coverUrl,
                                  fallback: context.colors.primary,
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              top: 12,
                              start: 12,
                              child: CustomBackButton(),
                            ),
                            PositionedDirectional(
                              bottom: 12,
                              start: 12,
                              end: 12,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 6,
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
                        20.h,
                        CustomText(
                          course?.title ?? '',
                          fontSize: MasirText.displaySize,
                          fontWeight: FontWeight.w800,
                          color: context.colors.ink,
                          textAlign: TextAlign.right,
                        ),
                        if (course?.institute?.name != null &&
                            course!.institute!.name!.isNotEmpty) ...[
                          6.h,
                          CustomText(
                            course.institute!.name!,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.colors.primary,
                            textAlign: TextAlign.right,
                          ),
                        ],
                        if (data.teachers.isNotEmpty) ...[
                          14.h,
                          CourseTeacherRow(
                            teachers: data.teachers,
                            compact: false,
                            showHeadlines: true,
                          ),
                        ],
                        16.h,
                        Row(
                          children: [
                            Expanded(
                              child: _StatTile(
                                icon: Icons.folder_open_rounded,
                                value: persianDigits(data.moduleCount ?? 0),
                                label: 'فصل',
                              ),
                            ),
                            10.w,
                            Expanded(
                              child: _StatTile(
                                icon: Icons.play_lesson_rounded,
                                value: persianDigits(data.unitCount ?? 0),
                                label: 'واحد',
                              ),
                            ),
                            if (duration.isNotEmpty) ...[
                              10.w,
                              Expanded(
                                flex: 2,
                                child: _StatTile(
                                  icon: Icons.schedule_rounded,
                                  value: duration,
                                  label: 'مدت',
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (!isSubscribed && previewCount > 0) ...[
                          16.h,
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.sunSoft,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.card_giftcard_rounded,
                                  color: context.colors.sunEdge,
                                ),
                                10.w,
                                Expanded(
                                  child: CustomText(
                                    '${persianDigits(previewCount)} واحد اول رایگان است',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: context.colors.sunEdge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (outcomes.isNotEmpty) ...[
                          24.h,
                          CustomText(
                            'در این دوره چه یاد می‌گیرید؟',
                            fontSize: MasirText.titleSize,
                            fontWeight: FontWeight.w800,
                            color: context.colors.ink,
                          ),
                          12.h,
                          ChunkyBox(
                            fill: context.colors.surface,
                            edge: context.colors.lip,
                            borderColor: context.colors.border,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                for (final item in outcomes)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: item == outcomes.last ? 0 : 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: context.colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check_rounded,
                                            size: 15,
                                            color: context.colors.onPrimary,
                                          ),
                                        ),
                                        12.w,
                                        Expanded(
                                          child: CustomText(
                                            item,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: context.colors.ink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        if (intro.isNotEmpty) ...[
                          24.h,
                          Html(
                            data: intro,
                            style: {
                              'body': Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                fontSize: FontSize(16),
                                fontFamily: 'Masir',
                                lineHeight: LineHeight.number(1.7),
                                color: context.colors.ink,
                                textAlign: TextAlign.right,
                                direction: TextDirection.rtl,
                              ),
                            },
                          ),
                        ],
                        if (requirements.isNotEmpty) ...[
                          24.h,
                          CustomText(
                            'پیش‌نیازها',
                            fontSize: MasirText.titleSize,
                            fontWeight: FontWeight.w800,
                            color: context.colors.ink,
                          ),
                          12.h,
                          ...requirements.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: context.colors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  12.w,
                                  Expanded(
                                    child: CustomText(
                                      item,
                                      fontSize: 15,
                                      color: context.colors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  BlocBuilder<MySubscriptionsBloc, MySubscriptionsState>(
                    bloc: mySubsBloc,
                    builder: (context, subState) {
                      return BlocConsumer<
                        SubscribeCourseBloc,
                        SubscribeCourseState
                      >(
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
                              setState(() {});
                            },
                          );
                        },
                        builder: (context, sub) {
                          final subscribed =
                              isSubscribed ||
                              mySubsBloc.values.any(
                                (element) => element.courseId == widget.id,
                              );
                          final title = subscribed
                              ? 'شروع یادگیری'
                              : (previewCount > 0
                                    ? 'شروع رایگان'
                                    : 'ثبت نام دوره');
                          return Container(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
                            decoration: BoxDecoration(
                              color: context.colors.surface,
                              border: Border(
                                top: BorderSide(
                                  color: context.colors.border,
                                  width: Chunky.border,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (!subscribed) ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        'قیمت',
                                        fontSize: 12,
                                        color: context.colors.inkMuted,
                                      ),
                                      CustomText(
                                        isFree
                                            ? 'رایگان'
                                            : '${course?.price ?? 0} تومان',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: context.colors.primary,
                                      ),
                                    ],
                                  ),
                                  16.w,
                                ],
                                Expanded(
                                  child: CustomButton(
                                    title: title,
                                    loading:
                                        isLoading ||
                                        subState.isLoading ||
                                        sub.isLoading,
                                    enable: !isLoading && !subState.isLoading,
                                    onTap: () {
                                      if (subscribed || previewCount > 0) {
                                        _openOutline(dataModel);
                                        return;
                                      }
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
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: c.primary, size: 22),
          6.h,
          CustomText(
            value,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: c.ink,
            maxLines: 1,
          ),
          CustomText(label, fontSize: 12, color: c.inkMuted),
        ],
      ),
    );
  }
}
