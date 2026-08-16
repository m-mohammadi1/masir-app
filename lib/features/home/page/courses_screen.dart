import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_courses_model.dart';
import 'package:mohammad/features/main/presentation/bloc/courses/courses_bloc.dart';
import 'package:mohammad/features/discovery/presentation/bloc/topics/topics_bloc.dart';
import 'package:mohammad/features/discovery/presentation/widgets/topic_chip_row.dart';
import 'package:mohammad/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'detail_course_page.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';
import '/widgets/custom_error.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

class CoursesScreen extends StatefulWidget {
  static const String routeName = "/courses";
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final coursesBloc = inject<CoursesBloc>();
  final mySubscriptions = inject<MySubscriptionsBloc>();
  final topicsBloc = inject<TopicsBloc>();
  String? _topic;

  @override
  void initState() {
    super.initState();
    topicsBloc.add(const TopicsEvent.load());
    coursesBloc.add(const CoursesEvent.courses());
  }

  void _load() {
    coursesBloc.add(CoursesEvent.courses(
      params: RequestCoursesModel(topic: _topic),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          context.appSize.width.w,
          CustomAppBar(title: "دوره‌ها"),
          8.h,
          CustomText("همه دوره‌های منتشرشده"),
          12.h,
          TopicChipRow(
            bloc: topicsBloc,
            selectedSlug: _topic,
            onSelected: (slug) {
              setState(() => _topic = slug);
              _load();
            },
          ),
          12.h,
          Expanded(
            child: BlocBuilder<CoursesBloc, CoursesState>(
              bloc: coursesBloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => const SkeletonList(itemHeight: 220),
                  error: (_, message) => CustomError(
                    message: message,
                    retry: () => _load(),
                  ),
                  success: (isLoading, data) {
                    if (data.isEmpty) {
                      return const EmptyWidget(
                        text: 'دوره‌ای نیست',
                        description: 'هنوز دوره‌ای منتشر نشده است.',
                        icon: Icons.menu_book_outlined,
                      );
                    }
                    return ListView.separated(
                      itemCount: data.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      separatorBuilder: (_, __) => SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final course = data[index];
                        final isFree =
                            course.price == null || course.price == 0;
                        return OnClick(
                          onTap: () {
                            CustomNavigator.pushNamed(
                              DetailCoursePage.routeName,
                              arguments: course.id,
                            );
                          },
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: context.colors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colors.ink.withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 160,
                                    alignment: Alignment.center,
                                    color: context.colors.primary.withValues(
                                      alpha: 0.55,
                                    ),
                                    child:
                                        course.coverUrl != null &&
                                            course.coverUrl!.isNotEmpty
                                        ? Image.network(
                                            course.coverUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.menu_book_rounded,
                                              size: 48,
                                              color: context.colors.white.withValues(
                                                alpha: 0.85,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.menu_book_rounded,
                                            size: 48,
                                            color: context.colors.white.withValues(
                                              alpha: 0.85,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          course.title ?? "",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: context.colors.ink,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        if (course.description != null &&
                                            course.description!.isNotEmpty) ...[
                                          SizedBox(height: 6),
                                          Text(
                                            course.description!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: context.colors.inkMuted,
                                            ),
                                            textAlign: TextAlign.right,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        if (course.topic?.name != null) ...[
                                          SizedBox(height: 6),
                                          Text(
                                            course.topic!.name!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: context.colors.inkMuted,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                        if (course.teachers.isNotEmpty) ...[
                                          SizedBox(height: 10),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: CourseTeacherRow(
                                              teachers: course.teachers,
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: context.colors.primaryTint,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              isFree
                                                  ? "رایگان"
                                                  : "${course.price} تومان",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: context.colors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          20.h,
        ],
      ),
    );
  }
}
