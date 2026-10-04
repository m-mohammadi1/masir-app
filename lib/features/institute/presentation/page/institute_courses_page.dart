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
import '/features/home/page/detail_course_page.dart';
import '/core/helper/route_args.dart';
import '/core/theme/institute_themed.dart';
import '/core/theme/masir_style.dart';
import '/widgets/custom_text.dart';
import '/widgets/masir_page.dart';
import '/widgets/section_header.dart';
import '/widgets/state_view.dart';

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

  void _open(String? id) {
    CustomNavigator.pushNamed(
      DetailCoursePage.routeName,
      arguments: courseDetailArgs(
        id ?? '',
        themePreset: InstituteThemed.presetOf(context),
      ),
    );
  }

  void _reload() {
    coursesBloc.add(
      CoursesEvent.courses(
        params: RequestCoursesModel(
          instituteId:
              GoRouterState.of(context).pathParameters['instituteId'] ?? '',
        ),
      ),
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
                  if (e.courseId != null)
                    e.courseId!: e.courseProgressPercent ?? 0,
              },
            ) ??
            <String, int>{};

        return BlocBuilder<CoursesBloc, CoursesState>(
          bloc: coursesBloc,
          builder: (context, state) {
            return state.when(
              loading: (_) => const MasirPage.tab(
                title: 'دوره‌ها',
                children: [
                  StateView.loading(variant: SkeletonVariant.cards, count: 3),
                ],
              ),
              error: (_, message) => MasirPage.tab(
                title: 'دوره‌ها',
                body: StateView.error(message: message, retry: _reload),
              ),
              success: (_, data) {
                if (data.isEmpty) {
                  return const MasirPage.tab(
                    title: 'دوره‌ها',
                    body: StateView.empty(
                      text: 'هنوز دوره‌ای نیست',
                      description:
                          'این مؤسسه داره دوره‌هاش رو آماده می‌کنه، به‌زودی!',
                      icon: Icons.menu_book_rounded,
                    ),
                  );
                }
                final mine = data
                    .where((c) => progressById.containsKey(c.id))
                    .toList();
                final others = data
                    .where((c) => !progressById.containsKey(c.id))
                    .toList();
                return MasirPage.tab(
                  title: 'دوره‌ها',
                  children: [
                    if (mine.isNotEmpty) ...[
                      const SectionHeader('دوره‌های من'),
                      for (final course in mine) ...[
                        CourseCard(
                          course: course,
                          progress: progressById[course.id],
                          onTap: () => _open(course.id),
                        ),
                        const SizedBox(height: MasirSpace.md),
                      ],
                      const SizedBox(height: MasirSpace.md),
                    ],
                    const SectionHeader('دوره‌های دیگر'),
                    if (others.isEmpty)
                      CustomText.body(
                        'همه‌ی دوره‌ها رو شروع کردی. دمت گرم!',
                        color: context.colors.inkMuted,
                      )
                    else
                      for (final course in others) ...[
                        CourseCard(
                          course: course,
                          onTap: () => _open(course.id),
                        ),
                        const SizedBox(height: MasirSpace.md),
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
