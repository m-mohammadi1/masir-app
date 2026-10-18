import 'package:dartz/dartz.dart' show Left, Right;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/institute/home_page.dart' show Polaroid;
import '/app/institute/institute_shell.dart';
import '/app/institute/teachers_page.dart';
import '/app/routes.dart';
import '/app/state/load_cubit.dart';
import '/app/state/nav.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

typedef _Data = ({TeacherPage page, List<Teacher> others});

/// «صفحه‌ی استاد»: polaroid, links, numbers, bio, courses and the other
/// teachers of the institute the student is in.
class TeacherPageView extends StatelessWidget {
  final String userId;
  const TeacherPageView({super.key, required this.userId});

  Future<Res<_Data>> _fetch() async {
    final api = inject<MasirApi>();
    final inst = Session.instituteId.value;
    final res = await api.teacher(userId);
    return res.fold((e) async => Left<ApiError, _Data>(e), (p) async {
      var others = <Teacher>[];
      if (inst != null) {
        (await api.instituteTeachers(inst)).fold(
          (_) {},
          (t) => others = t.where((x) => x.userId != userId).toList(),
        );
      }
      return Right<ApiError, _Data>((page: p, others: others));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.paper,
    body: BlocProvider(
      create: (_) => LoadCubit<_Data>(_fetch)..load(),
      child: LoadView<_Data>(
        skeleton: const _Skeleton(),
        builder: (context, d) => _Body(page: d.page, others: d.others),
      ),
    ),
  );
}

class _Body extends StatelessWidget {
  final TeacherPage page;
  final List<Teacher> others;
  const _Body({required this.page, required this.others});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final t = page.teacher;
    final top = MediaQuery.paddingOf(context).top;
    final instId = Session.instituteId.value;
    final instName =
        (instId != null ? InstituteCache.peek(instId)?.name : null) ??
        (page.institutes.isNotEmpty ? page.institutes.first.name : '');
    final first = t.name.trim().split(' ').first;
    MI icon(String k) => switch (k) {
      'telegram' => MI.telegram,
      'instagram' => MI.camera,
      _ => MI.globe,
    };
    Widget stat(String v, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: C.surface,
          border: Border.all(color: C.border, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(v, style: T.of(19, FontWeight.w800)),
            Text(label, style: T.of(12, FontWeight.w500, C.muted)),
          ],
        ),
      ),
    );
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          height: 170 + top,
          decoration: BoxDecoration(
            color: pal.p,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            boxShadow: [lip(pal.e, 5)],
          ),
          padding: EdgeInsets.fromLTRB(16, top + 12, 16, 0),
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              BackSquare(onTap: () => back(context), lipColor: pal.e),
              const Spacer(),
              if (instName.isNotEmpty)
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: pal.darkText
                        ? const Color(0x1A000000)
                        : const Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      'استاد $instName',
                      style: T.of(13, FontWeight.w800, pal.on),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShiftUp(
                dy: 96,
                child: Column(
                  children: [
                    Transform.rotate(
                      angle: -3 * 3.14159 / 180,
                      child: Container(
                        width: 176,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 22),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: C.border, width: 2),
                          boxShadow: [lip(C.lip)],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                            height: 152,
                            child: TeacherPhoto(teacher: t),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      t.name,
                      textAlign: TextAlign.center,
                      style: T.of(26, FontWeight.w900, C.ink, 1.3),
                    ),
                    if (t.headline.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        t.headline,
                        textAlign: TextAlign.center,
                        style: T.of(15, FontWeight.w500, C.muted),
                      ),
                    ],
                    if (t.links.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final l in t.links) ...[
                            if (l != t.links.first) const SizedBox(width: 8),
                            RoundIcon(
                              icon(l.kind),
                              bg: C.surface,
                              label: l.kind == 'telegram' ? 'کانال' : 'وب‌سایت',
                              onTap: () => launchUrl(
                                Uri.parse(l.url),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  stat(fa(page.courses.length), 'دوره'),
                  const SizedBox(width: 10),
                  stat(fa(page.studentCount), 'شاگرد'),
                  if (page.yearsExperience != null) ...[
                    const SizedBox(width: 10),
                    stat('${fa(page.yearsExperience)} سال', 'سابقه'),
                  ],
                ],
              ),
              if (t.bio.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: C.surface,
                    border: Border.all(color: C.border, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('درباره‌ی من', style: T.of(17, FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                        plain(t.bio, max: 2000),
                        style: T.of(15, FontWeight.w500, C.body, 1.95),
                      ),
                    ],
                  ),
                ),
              ],
              if (page.courses.isNotEmpty) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'دوره‌های $first',
                    style: T.of(17, FontWeight.w800),
                  ),
                ),
                for (final c in page.courses) ...[
                  const SizedBox(height: 10),
                  _CourseRow(course: c),
                ],
              ],
              if (others.isNotEmpty) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'بقیه‌ی استادهای $instName',
                    style: T.of(17, FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 196,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    itemCount: others.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (_, i) => Polaroid(
                      teacher: others[i],
                      width: 128,
                      tilt: i.isEven ? 2.5 : -2,
                      onTap: () => context.pushReplacement(
                        Routes.teacher(others[i].userId),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CourseRow extends StatelessWidget {
  final CourseCard course;
  const _CourseRow({required this.course});

  @override
  Widget build(BuildContext context) {
    final c = course;
    final meta = [
      if (c.level != null && levelNames[c.level] != null) levelNames[c.level]!,
      if (c.unitCount > 0) '${fa(c.unitCount)} واحد',
    ].join(' • ');
    final tag = switch (c.access.state) {
      AccessState.active || AccessState.expiring => (
        text: 'اشتراک فعال',
        fg: C.greenText,
        bg: C.greenSoft,
      ),
      AccessState.expired => (
        text: 'اشتراک تموم شده',
        fg: C.coralText,
        bg: C.coralSoft,
      ),
      _ when c.freeCourse => (text: 'رایگان', fg: C.greenText, bg: C.greenSoft),
      _ when c.previewUnits > 0 => (
        text: '${fa(c.previewUnits)} واحد رایگان',
        fg: C.sunText,
        bg: C.sunSoft,
      ),
      _ => null,
    };
    return GestureDetector(
      onTap: () => context.push(Routes.course(c.id)),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: cardDecoration(radius: 20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 84,
                height: 64,
                child: CoverImage(url: c.coverUrl, brand: context.brand),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: T.of(15, FontWeight.w800),
                  ),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(meta, style: T.of(13, FontWeight.w500, C.muted)),
                  ],
                ],
              ),
            ),
            if (tag != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tag.bg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(tag.text, style: T.of(11, FontWeight.w800, tag.fg)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    children: [
      Bone(height: 170 + MediaQuery.paddingOf(context).top, radius: 32),
      const SizedBox(height: 24),
      const Center(child: Bone(width: 176, height: 200, radius: 8)),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Bone(height: 120, radius: 20),
      ),
    ],
  );
}
