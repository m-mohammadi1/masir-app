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
              final coverUrl = (course?.coverUrl != null &&
                      course!.coverUrl!.isNotEmpty)
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
              final isSubscribed = course?.isSubscribed == true ||
                  mySubsBloc.values.any((e) => e.courseId == widget.id);

              return Column(
                children: [
                  CustomAppBar(title: course?.title ?? 'دوره'),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: coverUrl != null && coverUrl.isNotEmpty
                                ? Image.network(
                                    coverUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                                      color: context.colors.primary,
                                    ),
                                  )
                                : ColoredBox(color: context.colors.primary),
                          ),
                        ),
                        16.h,
                        CustomText(
                          course?.title ?? '',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: context.colors.ink,
                          textAlign: TextAlign.right,
                        ),
                        if (course?.institute?.name != null &&
                            course!.institute!.name!.isNotEmpty) ...[
                          6.h,
                          CustomText(
                            course.institute!.name!,
                            fontSize: 13,
                            color: context.colors.inkMuted,
                            textAlign: TextAlign.right,
                          ),
                        ],
                        if (data.teachers.isNotEmpty) ...[
                          12.h,
                          CourseTeacherRow(
                            teachers: data.teachers,
                            compact: false,
                            showHeadlines: true,
                          ),
                        ],
                        if (topicName != null || levelLabel != null) ...[
                          8.h,
                          CustomText(
                            [topicName, levelLabel]
                                .whereType<String>()
                                .join(' · '),
                            fontSize: 12,
                            color: context.colors.inkMuted,
                            textAlign: TextAlign.right,
                          ),
                        ],
                        12.h,
                        CustomText(
                          [
                            '${data.moduleCount ?? 0} فصل',
                            '${data.unitCount ?? 0} واحد',
                            if (duration.isNotEmpty) duration,
                            if ((course?.enrolledCount ?? 0) > 0)
                              '${course!.enrolledCount} دانش‌آموز',
                          ].join(' · '),
                          fontSize: 13,
                          color: context.colors.inkMuted,
                          textAlign: TextAlign.right,
                        ),
                        if (outcomes.isNotEmpty) ...[
                          20.h,
                          CustomText(
                            'در این دوره چه یاد می‌گیرید؟',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.colors.ink,
                          ),
                          8.h,
                          ...outcomes.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 18,
                                    color: context.colors.success,
                                  ),
                                  8.w,
                                  Expanded(
                                    child: CustomText(
                                      item,
                                      fontSize: 14,
                                      color: context.colors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (intro.isNotEmpty) ...[
                          20.h,
                          Html(
                            data: intro,
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
                        if (requirements.isNotEmpty) ...[
                          20.h,
                          CustomText(
                            'پیش‌نیازها',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.colors.ink,
                          ),
                          8.h,
                          ...requirements.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: CustomText(
                                '• $item',
                                fontSize: 14,
                                color: context.colors.ink,
                              ),
                            ),
                          ),
                        ],
                        if (!isSubscribed && previewCount > 0) ...[
                          20.h,
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.colors.primaryTint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomText(
                              '$previewCount واحد اول رایگان است',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.colors.primary,
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
                          final subscribed = isSubscribed ||
                              mySubsBloc.values.any(
                                (element) => element.courseId == widget.id,
                              );
                          final title = subscribed
                              ? 'شروع یادگیری'
                              : (previewCount > 0
                                  ? 'شروع رایگان'
                                  : 'ثبت نام دوره');
                          return Container(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                            decoration: BoxDecoration(
                              color: context.colors.surface,
                              border: Border(
                                top: BorderSide(color: context.colors.border),
                              ),
                            ),
                            child: Column(
                              children: [
                                CustomText(
                                  isFree
                                      ? 'رایگان'
                                      : '${course?.price ?? 0} تومان',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: context.colors.primary,
                                ),
                                8.h,
                                CustomButton(
                                  title: title,
                                  loading: isLoading ||
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
