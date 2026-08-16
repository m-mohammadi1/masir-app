import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/main/data/models/request_courses_model.dart';
import '/features/main/presentation/bloc/courses/courses_bloc.dart';
import '/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/features/teacher/domain/entities/teacher.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

class InstituteCoursesPage extends StatefulWidget {
  const InstituteCoursesPage({super.key});

  @override
  State<InstituteCoursesPage> createState() => _InstituteCoursesPageState();
}

class _InstituteCoursesPageState extends State<InstituteCoursesPage> {
  final coursesBloc = inject<CoursesBloc>();
  final subscriptionsBloc = inject<MySubscriptionsBloc>();
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final id = GoRouterState.of(context).pathParameters['instituteId'] ?? '';
    coursesBloc.add(
      CoursesEvent.courses(params: RequestCoursesModel(instituteId: id)),
    );
    subscriptionsBloc.add(MySubscriptionsEvent.mySubscriptions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MySubscriptionsBloc, MySubscriptionsState>(
      bloc: subscriptionsBloc,
      builder: (context, subState) {
        final mineIds =
            subState.whenOrNull(
              success: (_, data) => data.map((e) => e.courseId ?? '').toSet(),
            ) ??
            <String>{};

        return BlocBuilder<CoursesBloc, CoursesState>(
          bloc: coursesBloc,
          builder: (context, state) {
            return state.when(
              loading: (_) => const SkeletonList(),
              error: (_, message) => Center(child: CustomText(message)),
              success: (_, data) {
                if (data.isEmpty) {
                  return const EmptyWidget(
                    text: 'دوره‌ای یافت نشد',
                    description: 'این مؤسسه هنوز دوره‌ای منتشر نکرده است.',
                    icon: Icons.menu_book_outlined,
                  );
                }
                final mine = data
                    .where((c) => mineIds.contains(c.id))
                    .toList();
                final others = data
                    .where((c) => !mineIds.contains(c.id))
                    .toList();
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (mine.isNotEmpty) ...[
                      CustomText(
                        'دوره‌های من',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      8.h,
                      for (final course in mine)
                        _CourseTile(
                          title: course.title ?? '',
                          teachers: course.teachers,
                          onTap: () => CustomNavigator.pushNamed(
                            OutlinePage.routeName,
                            arguments: {
                              'id': course.id ?? '',
                              'title': course.title ?? '',
                            },
                          ),
                        ),
                      16.h,
                    ],
                    CustomText(
                      'دوره‌های دیگر',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    8.h,
                    if (others.isEmpty)
                      CustomText(
                        'دوره دیگری نیست',
                        color: context.colors.inkMuted,
                      )
                    else
                      for (final course in others)
                        _CourseTile(
                          title: course.title ?? '',
                          teachers: course.teachers,
                          onTap: () => CustomNavigator.pushNamed(
                            OutlinePage.routeName,
                            arguments: {
                              'id': course.id ?? '',
                              'title': course.title ?? '',
                            },
                          ),
                        ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _CourseTile extends StatelessWidget {
  final String title;
  final List<CourseTeacherSummary> teachers;
  final VoidCallback onTap;

  const _CourseTile({
    required this.title,
    required this.teachers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: context.colors.border),
        ),
        title: CustomText(title),
        subtitle: teachers.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: 6),
                child: CourseTeacherRow(teachers: teachers),
              ),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }
}
