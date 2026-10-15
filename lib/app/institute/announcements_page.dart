import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/app/institute/institute_shell.dart';
import '/app/routes.dart';
import '/app/state/load_cubit.dart';
import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «اطلاعیه‌ها»: the institute's announcements, filterable by course.
class AnnouncementsPage extends StatefulWidget {
  final String instituteId;
  const AnnouncementsPage({super.key, required this.instituteId});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final name = InstituteCache.peek(widget.instituteId)?.name;
    return InstituteBrand(
      instituteId: widget.instituteId,
      child: Scaffold(
        backgroundColor: C.paper,
        body: BlocProvider(
          create: (_) => LoadCubit<List<Announcement>>(
            () => inject<MasirApi>().announcements(widget.instituteId),
          )..load(),
          child:
              BlocBuilder<
                LoadCubit<List<Announcement>>,
                Load<List<Announcement>>
              >(
                builder: (context, s) {
                  final all = s.data ?? const <Announcement>[];
                  final courses = <String>{
                    for (final a in all)
                      if (a.courseTitle != null) a.courseTitle!,
                  }.toList();
                  final hasGeneral = all.any((a) => a.courseTitle == null);
                  final labels = [
                    'همه',
                    ...courses,
                    if (hasGeneral && courses.isNotEmpty) 'عمومی',
                  ];
                  final idx = _filter.clamp(0, labels.length - 1);
                  final shown = idx == 0
                      ? all
                      : labels[idx] == 'عمومی' &&
                            idx == labels.length - 1 &&
                            hasGeneral
                      ? all.where((a) => a.courseTitle == null).toList()
                      : all.where((a) => a.courseTitle == labels[idx]).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: C.border, width: 2),
                          ),
                        ),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PaperHeader(
                              title: 'اطلاعیه‌ها',
                              subtitle: name,
                              onBack: () => back(context),
                            ),
                            if (labels.length > 1)
                              ChipRow(
                                soft: true,
                                labels: labels,
                                index: idx,
                                onChanged: (i) => setState(() => _filter = i),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: s.data == null
                            ? LoadView<List<Announcement>>(
                                builder: (_, _) => const SizedBox(),
                              )
                            : RefreshIndicator(
                                onRefresh: () => context
                                    .read<LoadCubit<List<Announcement>>>()
                                    .load(),
                                child: shown.isEmpty
                                    ? ListView(
                                        children: const [
                                          SizedBox(height: 40),
                                          EmptyState(
                                            icon: MI.megaphone,
                                            title: 'اطلاعیه‌ای نیست',
                                            body:
                                                'خبرهای تازه‌ی مؤسسه که برسه، اینجا می‌بینیش.',
                                          ),
                                        ],
                                      )
                                    : ListView.separated(
                                        padding: const EdgeInsets.all(16),
                                        itemCount: shown.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(height: 12),
                                        itemBuilder: (_, i) => AnnouncementCard(
                                          a: shown[i],
                                          instituteId: widget.instituteId,
                                        ),
                                      ),
                              ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}

/// «آمادگی آیلتس · فصل ۲» or «عمومی».
String announcementScope(Announcement a) {
  if (a.courseTitle == null) return 'عمومی';
  return a.moduleNumber > 0
      ? '${a.courseTitle} · فصل ${fa(a.moduleNumber)}'
      : a.courseTitle!;
}

class AnnouncementCard extends StatelessWidget {
  final Announcement a;
  final String instituteId;
  const AnnouncementCard({
    super.key,
    required this.a,
    required this.instituteId,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final general = a.courseTitle == null;
    final recent =
        a.publishedAt != null &&
        DateTime.now().difference(a.publishedAt!).inDays < 7;
    return GestureDetector(
      onTap: () => context.push(Routes.announcement(instituteId, a.id)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: cardDecoration(radius: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: general ? C.sand : pal.soft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      announcementScope(a),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: T.of(
                        12,
                        FontWeight.w800,
                        general ? C.body : pal.ink,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (a.unread) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: C.coral,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  recent
                      ? ago(a.publishedAt)
                      : (a.publishedAt != null ? jDay(a.publishedAt!) : ''),
                  style: T.of(12, FontWeight.w500, C.muted),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(a.title, style: T.of(16, FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              plain(a.body, max: 200),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: T.of(14, FontWeight.w500, C.body, 1.8),
            ),
          ],
        ),
      ),
    );
  }
}
