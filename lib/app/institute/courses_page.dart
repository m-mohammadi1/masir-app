import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/common/course_tile.dart';
import '/app/state/load_cubit.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «دوره‌ها»: every course of the institute, or only the ones the student started.
class InstituteCoursesPage extends StatefulWidget {
  final String instituteId;
  const InstituteCoursesPage({super.key, required this.instituteId});

  @override
  State<InstituteCoursesPage> createState() => _InstituteCoursesPageState();
}

class _InstituteCoursesPageState extends State<InstituteCoursesPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LoadCubit<List<CourseCard>>(
      () => inject<MasirApi>().instituteCourses(widget.instituteId),
    )..load(),
    child: LoadView<List<CourseCard>>(
      builder: (context, all) {
        final mine = all.where((c) => c.access.enrolled).toList();
        final shown = _tab == 0 ? all : mine;
        return RefreshIndicator(
          onRefresh: () => context.read<LoadCubit<List<CourseCard>>>().load(),
          child: MasirStagger(
            id: 'courses-${widget.instituteId}',
            layout: (c) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: c,
            ),
            children: [
              Segments(
                labels: [
                  'همه · ${fa(all.length)}',
                  'دوره‌های من · ${fa(mine.length)}',
                ],
                index: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 14),
              if (shown.isEmpty)
                EmptyState(
                  icon: MI.book,
                  title: _tab == 0
                      ? 'هنوز دوره‌ای منتشر نشده'
                      : 'هنوز دوره‌ای رو شروع نکردی',
                  body: _tab == 0
                      ? 'دوره‌های این مؤسسه که منتشر بشن، همین‌جا میان.'
                      : 'از «همه» یه دوره انتخاب کن؛ واحدهای اولش رایگانه.',
                )
              else
                for (final c in shown) ...[
                  CourseTile(course: c),
                  const SizedBox(height: 14),
                ],
            ],
          ),
        );
      },
    ),
  );
}
