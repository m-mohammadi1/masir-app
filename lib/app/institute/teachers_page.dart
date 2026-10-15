import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/app/institute/institute_shell.dart';
import '/app/routes.dart';
import '/app/state/load_cubit.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «اساتید»: polaroids in two columns; a tap opens the teacher sheet.
class InstituteTeachersPage extends StatelessWidget {
  final String instituteId;
  const InstituteTeachersPage({super.key, required this.instituteId});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LoadCubit<List<Teacher>>(() => inject<MasirApi>().instituteTeachers(instituteId))..load(),
    child: LoadView<List<Teacher>>(
      builder: (context, teachers) {
        final inst = InstituteCache.peek(instituteId);
        final name = inst?.name ?? '';
        final courses = {for (final t in teachers) ...t.courses.map((c) => c.id)}.length;
        return RefreshIndicator(
          onRefresh: () => context.read<LoadCubit<List<Teacher>>>().load(),
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 32), children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('استادهای $name', style: T.of(22, FontWeight.w900)),
                const SizedBox(height: 2),
                Text('${fa(teachers.length)} استاد · ${fa(courses)} دوره · رو هر کدوم بزنی، دوره‌هاش رو می‌بینی',
                    style: T.of(14, FontWeight.w500, C.muted)),
              ]),
            ),
            const SizedBox(height: 20),
            if (teachers.isEmpty)
              const EmptyState(icon: MI.teachers, title: 'هنوز استادی معرفی نشده', body: 'استادهای این مؤسسه که اضافه بشن، اینجا میان.')
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: LayoutBuilder(builder: (context, box) {
                  final w = (box.maxWidth - 18) / 2;
                  return Wrap(spacing: 18, runSpacing: 22, children: [
                    for (var i = 0; i < teachers.length; i++)
                      SizedBox(
                        width: w,
                        child: _GridPolaroid(
                          teacher: teachers[i],
                          tilt: i.isEven ? -2.5 : 2,
                          onTap: () => showTeacherSheet(context, teachers[i], instituteName: name),
                        ),
                      ),
                  ]);
                }),
              ),
          ]),
        );
      },
    ),
  );
}

class _GridPolaroid extends StatelessWidget {
  final Teacher teacher;
  final double tilt;
  final VoidCallback onTap;
  const _GridPolaroid({required this.teacher, required this.tilt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Transform.rotate(
      angle: tilt * 3.14159 / 180,
      child: Semantics(
        button: true,
        label: teacher.name,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: C.border, width: 2),
              boxShadow: [lip(C.lip, 3)],
            ),
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(height: 150, width: double.infinity, child: TeacherPhoto(teacher: teacher)),
              ),
              const SizedBox(height: 8),
              Text(teacher.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.of(15, FontWeight.w800, C.ink, 1.5)),
              if (teacher.headline.isNotEmpty)
                Text(teacher.headline, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.of(12, FontWeight.w500, C.muted, 1.6)),
              const SizedBox(height: 8),
              Container(
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: pal.soft, borderRadius: BorderRadius.circular(999)),
                child: Center(widthFactor: 1, child: Text('${fa(teacher.courses.length)} دوره', style: T.of(12, FontWeight.w800, pal.ink))),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// A teacher's photo, or their initial on the institute's soft colour.
class TeacherPhoto extends StatelessWidget {
  final Teacher teacher;
  const TeacherPhoto({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    if (teacher.photoUrl.isNotEmpty) return CoverImage(url: teacher.photoUrl);
    final pal = context.pal;
    return ColoredBox(
      color: pal.soft,
      child: Center(
        child: Text(teacher.name.isEmpty ? '' : String.fromCharCode(teacher.name.runes.first), style: T.of(40, FontWeight.w900, pal.ink)),
      ),
    );
  }
}

/// Bottom sheet: photo, role, bio, the teacher's courses and the full page.
Future<void> showTeacherSheet(BuildContext context, Teacher t, {required String instituteName}) => showMasirSheet(
  context,
  builder: (sheet) => SheetFrame(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Transform.rotate(
            angle: -4 * 3.14159 / 180,
            child: Container(
              width: 92,
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 16),
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: C.border, width: 2),
                boxShadow: [lip(C.lip, 3)],
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(4), child: SizedBox(height: 80, child: TeacherPhoto(teacher: t))),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.name, style: T.of(20, FontWeight.w800)),
            Text([if (t.headline.isNotEmpty) t.headline, 'در $instituteName'].join(' '), style: T.of(14, FontWeight.w500, C.muted)),
          ])),
        ]),
        if (t.bio.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(plain(t.bio, max: 400), style: T.of(15, FontWeight.w500, C.body, 1.9)),
        ],
        if (t.courses.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text('دوره‌ها', style: T.of(13, FontWeight.w800, C.muted)),
          for (final c in t.courses) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.of(sheet).pop();
                context.push(Routes.course(c.id));
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: C.sand, borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Expanded(child: Text(c.title, style: T.of(15, FontWeight.w800))),
                  const MIcon(MI.forward, size: 18, color: C.muted),
                ]),
              ),
            ),
          ],
        ],
        const SizedBox(height: 14),
        Btn('صفحه‌ی کامل استاد', kind: BtnKind.secondary, height: 52, fontSize: 16, onPressed: () {
          Navigator.of(sheet).pop();
          context.push(Routes.teacher(t.userId));
        }),
      ]),
    ),
  ),
);
