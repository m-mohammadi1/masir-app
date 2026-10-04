import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/presentation/widgets/course_card.dart';
import '/features/main/data/models/request_courses_model.dart';
import '/features/main/presentation/bloc/courses/courses_bloc.dart';
import '/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/custom_error.dart';
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

  void _open(String? id, String? title) {
    CustomNavigator.pushNamed(
      OutlinePage.routeName,
      arguments: {'id': id ?? '', 'title': title ?? ''},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MySubscriptionsBloc, MySubscriptionsState>(
      bloc: subscriptionsBloc,
      builder: (context, subState) {
        final progressById =
            subState.whenOrNull(
              success: (_, data) => {
                for (final e in data)
                  if (e.courseId != null) e.courseId!: e.courseProgressPercent ?? 0,
              },
            ) ??
            <String, int>{};

        return BlocBuilder<CoursesBloc, CoursesState>(
          bloc: coursesBloc,
          builder: (context, state) {
            return state.when(
              loading: (_) => const SkeletonList(itemHeight: 96),
              error: (_, message) => CustomError(
                message: message,
                retry: () => coursesBloc.add(
                  CoursesEvent.courses(
                    params: RequestCoursesModel(
                      instituteId:
                          GoRouterState.of(context).pathParameters['instituteId'] ??
                          '',
                    ),
                  ),
                ),
              ),
              success: (_, data) {
                if (data.isEmpty) {
                  return const EmptyWidget(
                    text: 'دوره‌ای یافت نشد',
                    description: 'این مؤسسه هنوز دوره‌ای منتشر نکرده است.',
                    icon: Icons.menu_book_rounded,
                  );
                }
                final mine = data
                    .where((c) => progressById.containsKey(c.id))
                    .toList();
                final others = data
                    .where((c) => !progressById.containsKey(c.id))
                    .toList();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    const CustomText(
                      'دوره‌ها',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                    16.h,
                    if (mine.isNotEmpty) ...[
                      const _SectionTitle('دوره‌های من'),
                      for (final course in mine) ...[
                        CourseCard(
                          course: course,
                          progress: progressById[course.id],
                          onTap: () => _open(course.id, course.title),
                        ),
                        12.h,
                      ],
                      12.h,
                    ],
                    const _SectionTitle('دوره‌های دیگر'),
                    if (others.isEmpty)
                      CustomText(
                        'همه‌ی دوره‌ها را شروع کرده‌ای. آفرین!',
                        color: context.colors.inkMuted,
                      )
                    else
                      for (final course in others) ...[
                        CourseCard(
                          course: course,
                          onTap: () => _open(course.id, course.title),
                        ),
                        12.h,
                      ],
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomText(text, fontWeight: FontWeight.w800, fontSize: 18),
    );
  }
}
