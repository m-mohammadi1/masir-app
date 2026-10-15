import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/app/common/rich_body.dart';
import '/app/institute/announcements_page.dart';
import '/app/institute/institute_shell.dart';
import '/app/routes.dart';
import '/app/state/load_cubit.dart';
import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «اطلاعیه»: who sent it, the full text, and the course it's about.
class AnnouncementDetailPage extends StatelessWidget {
  final String instituteId;
  final String announcementId;
  const AnnouncementDetailPage({
    super.key,
    required this.instituteId,
    required this.announcementId,
  });

  @override
  Widget build(BuildContext context) => InstituteBrand(
    instituteId: instituteId,
    child: Scaffold(
      backgroundColor: C.paper,
      body: BlocProvider(
        create: (_) => LoadCubit<Announcement>(
          () => inject<MasirApi>().announcement(instituteId, announcementId),
        )..load(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 12,
                16,
                12,
              ),
              child: Row(
                children: [
                  BackSquare(
                    onTap: () => back(
                      context,
                      fallback: Routes.announcements(instituteId),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('اطلاعیه', style: T.of(15, FontWeight.w700, C.muted)),
                ],
              ),
            ),
            Expanded(
              child: LoadView<Announcement>(
                builder: (context, a) => _Body(a: a, instituteId: instituteId),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Body extends StatelessWidget {
  final Announcement a;
  final String instituteId;
  const _Body({required this.a, required this.instituteId});

  @override
  Widget build(BuildContext context) {
    final inst = InstituteCache.peek(instituteId);
    final brand = inst?.brand ?? context.brand;
    final pal = brand.palette;
    final courseId = a.courseId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Row(
                children: [
                  InstituteLogo(brand: brand, size: 40, fontSize: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inst?.name ?? '',
                          style: T.of(14, FontWeight.w800),
                        ),
                        Text(
                          [
                            if (a.authorName.isNotEmpty) a.authorName,
                            if (a.publishedAt != null)
                              jDay(a.publishedAt!, year: true),
                          ].join(' · '),
                          style: T.of(12, FontWeight.w500, C.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(a.title, style: T.of(26, FontWeight.w900, C.ink, 1.45)),
              const SizedBox(height: 16),
              RichBody(a.body),
              if (courseId != null) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => context.push(Routes.roadmap(courseId)),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: cardDecoration(radius: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: pal.p,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [lip(pal.e, 3)],
                          ),
                          alignment: Alignment.center,
                          child: MasirSmallMark(size: 22, color: pal.on),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مربوط به',
                                style: T.of(12, FontWeight.w500, C.muted),
                              ),
                              Text(
                                a.moduleTitle != null && a.moduleNumber > 0
                                    ? '${a.courseTitle} · فصل ${fa(a.moduleNumber)} ${a.moduleTitle}'
                                    : announcementScope(a),
                                style: T.of(15, FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                        const MIcon(
                          MI.forward,
                          size: 20,
                          color: C.muted,
                          strokeWidth: 2.4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (courseId != null)
          Container(
            decoration: const BoxDecoration(
              color: C.surface,
              border: Border(top: BorderSide(color: C.border, width: 2)),
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              20 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Btn(
              'برو سراغ دوره',
              height: 54,
              fontSize: 17,
              palette: pal,
              onPressed: () => context.push(Routes.roadmap(courseId)),
            ),
          ),
      ],
    );
  }
}
