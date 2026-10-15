import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/common/widgets.dart';
import '/app/institute/institute_shell.dart';
import '/app/routes.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «خانه‌ی مؤسسه»: cover, identity, the next step (or join), photos, the
/// notice board, courses, teachers and outside links.
class InstituteHomePage extends StatefulWidget {
  final String instituteId;
  const InstituteHomePage({super.key, required this.instituteId});

  @override
  State<InstituteHomePage> createState() => _InstituteHomePageState();
}

class _InstituteHomePageState extends State<InstituteHomePage> {
  final api = inject<MasirApi>();
  InstituteDetail? _detail;
  ApiError? _error;
  InstituteMe? _me;
  List<Announcement>? _ann;
  List<CourseCard>? _courses;
  List<Teacher>? _teachers;
  bool _joining = false;

  String get id => widget.instituteId;

  @override
  void initState() {
    super.initState();
    _detail = InstituteCache.peek(id);
    _load();
  }

  Future<void> _load() async {
    await Future.wait([
      InstituteCache.load(id).then(
        (r) => r.fold(
          (e) => _set(() => _error = e),
          (d) => _set(() => _detail = d),
        ),
      ),
      api
          .instituteMe(id)
          .then((r) => r.fold((_) {}, (m) => _set(() => _me = m))),
      api
          .announcements(id)
          .then((r) => r.fold((_) {}, (a) => _set(() => _ann = a))),
      api
          .instituteCourses(id)
          .then((r) => r.fold((_) {}, (c) => _set(() => _courses = c))),
      api
          .instituteTeachers(id)
          .then((r) => r.fold((_) {}, (t) => _set(() => _teachers = t))),
    ]);
  }

  void _set(VoidCallback f) {
    if (mounted) setState(f);
  }

  Future<void> _join() async {
    setState(() => _joining = true);
    final res = await api.joinInstitute(id);
    if (!mounted) return;
    setState(() => _joining = false);
    res.fold(
      (e) => Toast.show(
        context,
        title: 'عضو نشدی',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (_) {
        Toast.show(
          context,
          title: 'عضو ${_detail?.name ?? ''} شدی!',
          body: 'دوره‌ها و پیشرفتت همین‌جا کنار هم میان.',
        );
        InstituteCache.forget(id);
        _load();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = _detail;
    if (d == null) {
      return _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: InlineError(body: _error!.friendly, onRetry: _load),
              ),
            )
          : const _HomeSkeleton();
    }
    final member = _me?.member ?? d.isMember;
    final current = _me?.courses
        .where((c) => c.currentUnit != null)
        .firstOrNull;
    final photos = [
      ...d.photos,
      if (d.brand.coverUrl.isNotEmpty) d.brand.coverUrl,
    ];
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Hero(detail: d),
          ShiftUp(
            dy: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: member
                  ? (current != null
                        ? _ContinueCard(course: current)
                        : _StartCard(
                            onTap: () => context.go(Routes.instCourses(id)),
                          ))
                  : _JoinCard(name: d.name, busy: _joining, onJoin: _join),
            ),
          ),
          const SizedBox(height: 32),
          if (photos.length > 1) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'یه نگاه به ${d.name}',
                style: T.of(20, FontWeight.w900),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: 220,
                    child: CoverImage(url: photos[i], brand: d.brand),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
          if ((_ann ?? []).isNotEmpty) ...[
            _NoticeBoard(
              items: _ann!.take(2).toList(),
              instituteId: id,
              instituteName: d.name,
            ),
            const SizedBox(height: 32),
          ],
          if ((_courses ?? []).isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                'دوره‌ها',
                action: 'همه',
                onAction: () => context.go(Routes.instCourses(id)),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 272,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                itemCount: _courses!.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, i) =>
                    _CourseMini(course: _courses![i], brand: d.brand),
              ),
            ),
            const SizedBox(height: 32),
          ],
          if ((_teachers ?? []).isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                'اساتید',
                action: 'همه',
                onAction: () => context.go(Routes.instTeachers(id)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 216,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                itemCount: _teachers!.length,
                separatorBuilder: (_, _) => const SizedBox(width: 18),
                itemBuilder: (_, i) =>
                    Polaroid(teacher: _teachers![i], tilt: i.isEven ? -3 : 2.5),
              ),
            ),
            const SizedBox(height: 32),
          ],
          if (d.links.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Links(detail: d),
            ),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final InstituteDetail detail;
  const _Hero({required this.detail});

  @override
  Widget build(BuildContext context) {
    final d = detail;
    final brand = d.brand;
    final pal = brand.palette;
    final top = MediaQuery.paddingOf(context).top;
    final chipBg = pal.darkText
        ? const Color(0x1A000000)
        : const Color(0x33FFFFFF);
    final chips = [
      '${fa(d.courseCount)} دوره',
      '${fa(d.teacherCount)} استاد',
      '${fa(d.studentCount)} هم‌کلاسی',
    ];
    Widget glass(
      Widget child, {
      String? label,
      VoidCallback? onTap,
      bool wide = false,
    }) => Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          width: wide ? null : 44,
          padding: wide ? const EdgeInsets.symmetric(horizontal: 14) : null,
          decoration: BoxDecoration(
            color: C.scrim,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
    return ColoredBox(
      color: pal.p,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 232 + top,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CoverImage(url: brand.coverUrl, brand: brand),
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 112,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x8C14101C), Color(0x0014101C)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: top + 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      glass(
                        const MIcon(
                          MI.swap,
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                        label: 'عوض کردن مؤسسه',
                        onTap: () =>
                            showInstituteSwitcher(context, currentId: d.id),
                      ),
                      const Spacer(),
                      glass(
                        const MIcon(MI.bell, color: Colors.white),
                        label: 'صندوق پیام',
                        onTap: () => context.push(Routes.inbox),
                      ),
                      const SizedBox(width: 8),
                      glass(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const MasirSmallMark(size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'مسیر',
                              style: T.of(14, FontWeight.w800, Colors.white),
                            ),
                          ],
                        ),
                        label: 'خروج به مسیر',
                        wide: true,
                        onTap: () {
                          Session.exitToMasir();
                          context.go(Routes.vitrine);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Positioned.fill(
                child: PatternFill(pattern: brand.pattern, color: pal.e),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 76),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShiftUp(
                      dy: 48,
                      child: LippedLogo(
                        brand: brand,
                        size: 96,
                        inverted: true,
                        lipHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(d.name, style: T.of(30, FontWeight.w900, pal.on, 1.3)),
                    Text(
                      [
                        if (d.topic.isNotEmpty) d.topic,
                        if (d.foundedYear != null) 'از ${fa(d.foundedYear)}',
                      ].join('، '),
                      style: T.of(14, FontWeight.w600, pal.on),
                    ),
                    if (d.description.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        d.description,
                        style: T.of(15, FontWeight.w500, pal.on, 1.9),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final c in chips)
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              widthFactor: 1,
                              child: Text(
                                c,
                                style: T.of(14, FontWeight.w800, pal.on),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final CourseCard course;
  const _ContinueCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final unit = course.currentUnit!;
    return PaperCard(
      radius: 24,
      onTap: () =>
          context.push(Routes.unit(unit.id), extra: {'course_id': course.id}),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'از همون‌جا که موندی',
                  style: T.of(13, FontWeight.w800, pal.ink),
                ),
                const SizedBox(height: 6),
                Text(
                  unit.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: T.of(19, FontWeight.w800),
                ),
                Text(
                  course.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: T.of(13, FontWeight.w500, C.muted),
                ),
                const SizedBox(height: 10),
                Track(value: course.progressPercent / 100),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: pal.p,
              shape: BoxShape.circle,
              boxShadow: [lip(pal.e)],
            ),
            alignment: Alignment.center,
            child: MIcon(MI.play, color: pal.on, size: 26),
          ),
        ],
      ),
    );
  }
}

class _StartCard extends StatelessWidget {
  final VoidCallback onTap;
  const _StartCard({required this.onTap});

  @override
  Widget build(BuildContext context) => PaperCard(
    radius: 24,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('یه دوره شروع کن', style: T.of(19, FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          'واحدهای اول هر دوره رایگانه؛ اول مزه کن.',
          style: T.of(14, FontWeight.w500, C.body, 1.8),
        ),
        const SizedBox(height: 12),
        Btn('دیدن دوره‌ها', height: 52, fontSize: 16, onPressed: onTap),
      ],
    ),
  );
}

class _JoinCard extends StatelessWidget {
  final String name;
  final bool busy;
  final VoidCallback onJoin;
  const _JoinCard({
    required this.name,
    required this.busy,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) => PaperCard(
    radius: 24,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('عضو $name شو', style: T.of(19, FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          'عضویت رایگانه. عضو که بشی، دوره‌ها و پیشرفتت همین‌جا کنار هم میان.',
          style: T.of(14, FontWeight.w500, C.body, 1.8),
        ),
        const SizedBox(height: 12),
        Btn(
          'عضو شو',
          height: 52,
          fontSize: 16,
          loading: busy,
          onPressed: onJoin,
        ),
      ],
    ),
  );
}

class _NoticeBoard extends StatelessWidget {
  final List<Announcement> items;
  final String instituteId;
  final String instituteName;
  const _NoticeBoard({
    required this.items,
    required this.instituteId,
    required this.instituteName,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SectionTitle(
              'تابلوی اعلانات',
              action: 'همه',
              onAction: () => context.push(Routes.announcements(instituteId)),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EBDD),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 24),
                  _Note(
                    a: items[i],
                    yellow: i.isOdd,
                    pin: i.isOdd ? C.coral : pal.p,
                    pinLip: i.isOdd ? C.coralDark : pal.e,
                    tilt: i.isOdd ? 1.0 : -1.2,
                    source: items[i].authorName.isNotEmpty
                        ? items[i].authorName
                        : instituteName,
                    onTap: () => context.push(
                      Routes.announcement(instituteId, items[i].id),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  final Announcement a;
  final bool yellow;
  final Color pin;
  final Color pinLip;
  final double tilt;
  final String source;
  final VoidCallback onTap;
  const _Note({
    required this.a,
    required this.yellow,
    required this.pin,
    required this.pinLip,
    required this.tilt,
    required this.source,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: tilt * 3.14159 / 180,
    child: GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            decoration: BoxDecoration(
              color: yellow ? const Color(0xFFFFF6DE) : C.surface,
              borderRadius: yellow
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(18),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(18),
                    ),
              boxShadow: [lip(yellow ? const Color(0xFFEBD9AE) : C.lip, 3)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.title, style: T.of(16, FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  plain(a.body, max: 120),
                  style: T.of(14, FontWeight.w500, C.body, 1.8),
                ),
                const SizedBox(height: 6),
                Text(
                  '$source، ${ago(a.publishedAt)}',
                  style: T.of(12, FontWeight.w500, C.muted),
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: pin,
                  shape: BoxShape.circle,
                  boxShadow: [lip(pinLip, 3)],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CourseMini extends StatelessWidget {
  final CourseCard course;
  final Brand brand;
  const _CourseMini({required this.course, required this.brand});

  @override
  Widget build(BuildContext context) {
    final started = course.access.enrolled && course.progressPercent > 0;
    return GestureDetector(
      onTap: () => context.push(Routes.course(course.id)),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(bottom: 5),
        clipBehavior: Clip.antiAlias,
        decoration: cardDecoration(radius: 22, lipHeight: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 128,
              child: CoverImage(url: course.coverUrl, brand: brand),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.of(16, FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.teacherLine.isEmpty
                        ? '${fa(course.unitCount)} واحد'
                        : course.teacherLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.of(13, FontWeight.w500, C.muted),
                  ),
                  const SizedBox(height: 6),
                  if (started)
                    Row(
                      children: [
                        Expanded(
                          child: Track(
                            value: course.progressPercent / 100,
                            height: 6,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          pct(course.progressPercent),
                          style: T.of(12, FontWeight.w800, C.greenText),
                        ),
                      ],
                    )
                  else
                    Text(
                      course.freeCourse
                          ? 'رایگان'
                          : course.previewUnits > 0
                          ? '${fa(course.previewUnits)} واحد اولش رایگانه'
                          : 'از ${perMonth(course.fromPerMonth)}',
                      style: T.of(13, FontWeight.w800, C.greenText),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Teacher as a tilted polaroid.
class Polaroid extends StatelessWidget {
  final Teacher teacher;
  final double tilt;
  final double width;
  final VoidCallback? onTap;
  const Polaroid({
    super.key,
    required this.teacher,
    this.tilt = 0,
    this.width = 130,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: tilt * 3.14159 / 180,
    child: GestureDetector(
      onTap: onTap ?? () => context.push(Routes.teacher(teacher.userId)),
      child: Container(
        width: width,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: C.border, width: 2),
          boxShadow: [lip(C.lip, 3)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: width - 12,
                width: double.infinity,
                child: teacher.photoUrl.isNotEmpty
                    ? CoverImage(url: teacher.photoUrl)
                    : ColoredBox(
                        color: context.pal.soft,
                        child: Center(
                          child: Text(
                            teacher.name.isEmpty
                                ? ''
                                : String.fromCharCode(teacher.name.runes.first),
                            style: T.of(40, FontWeight.w900, context.pal.ink),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              teacher.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: T.of(14, FontWeight.w800),
            ),
            if (teacher.headline.isNotEmpty)
              Text(
                teacher.headline,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: T.of(12, FontWeight.w500, C.muted),
              ),
          ],
        ),
      ),
    ),
  );
}

class _Links extends StatelessWidget {
  final InstituteDetail detail;
  const _Links({required this.detail});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    MI icon(String k) => switch (k) {
      'telegram' => MI.telegram,
      'instagram' => MI.camera,
      _ => MI.globe,
    };
    String label(String k) => switch (k) {
      'telegram' => 'کانال تلگرام',
      'instagram' => 'اینستاگرام',
      _ => 'وب‌سایت',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: C.surface,
        border: Border.all(color: C.border, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${detail.name} رو بیرون از اپ هم دنبال کن',
              style: T.of(15, FontWeight.w800),
            ),
          ),
          for (final l in detail.links) ...[
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: label(l.kind),
              child: GestureDetector(
                onTap: () => launchUrl(
                  Uri.parse(l.url),
                  mode: LaunchMode.externalApplication,
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: pal.soft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: MIcon(icon(l.kind), color: pal.ink),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    children: [
      const Bone(height: 420, radius: 0),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Bone(height: 110, radius: 24),
            SizedBox(height: 24),
            Bone(height: 150, radius: 18),
          ],
        ),
      ),
    ],
  );
}
