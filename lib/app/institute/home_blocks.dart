part of 'home_page.dart';

/// One block of the institute home (rules/home-page.md), drawn natively.
/// Returns nothing for a type this version doesn't know.
Widget? homeBlock(
  BuildContext context,
  HomeBlockData b, {
  required InstituteDetail detail,
}) {
  final id = detail.id;
  return switch (b.type) {
    'featured' when b.course != null => _FeaturedBlock(
      b: b,
      brand: detail.brand,
    ),
    'event' => _EventBlock(b: b, instituteId: id),
    'announcement' when b.announcement != null => _NoticeBoard(
      heading: b.heading,
      items: [b.announcement!],
      instituteId: id,
      instituteName: detail.name,
    ),
    'courses' when b.courses.isNotEmpty => _CoursesBlock(
      b: b,
      instituteId: id,
      brand: detail.brand,
    ),
    'offer' when b.offer != null => _OfferBlock(offer: b.offer!),
    'teachers' when b.teachers.length > 1 => _TeachersBlock(
      b: b,
      instituteId: id,
    ),
    'photos' when b.photos.length > 1 => _PhotosBlock(
      b: b,
      brand: detail.brand,
    ),
    'about' => _AboutBlock(b: b),
    'contact' => _ContactBlock(b: b),
    _ => null,
  };
}

/// «دوره‌ی ویژه»: one course, big, with a badge on the cover and an
/// automatic button («شروع رایگان» / «ادامه»).
class _FeaturedBlock extends StatelessWidget {
  final HomeBlockData b;
  final Brand brand;
  const _FeaturedBlock({required this.b, required this.brand});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final c = b.course!;
    final started =
        c.access.enrolled && (c.progressPercent > 0 || c.currentUnit != null);
    final teacher = c.teachers.firstOrNull;
    final free = c.freeCourse
        ? 'رایگان'
        : c.previewUnits > 0
        ? '${fa(c.previewUnits)} واحد اول رایگان'
        : '';
    void open() {
      final unit = c.currentUnit;
      if (started && unit != null) {
        context.push(Routes.unit(unit.id), extra: {'course_id': c.id});
      } else {
        context.push(Routes.course(c.id));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(b.heading, style: T.of(20, FontWeight.w900)),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => context.push(Routes.course(c.id)),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: cardDecoration(radius: 24, lipHeight: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 190,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CoverImage(url: c.coverUrl, brand: brand),
                        if (b.badge.isNotEmpty)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: pal.p,
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: [lip(pal.e, 3)],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                b.badge,
                                style: T.of(13, FontWeight.w800, pal.on),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.title,
                          style: T.of(21, FontWeight.w900, C.ink, 1.4),
                        ),
                        if (teacher != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: teacher.photoUrl.isNotEmpty
                                      ? CoverImage(url: teacher.photoUrl)
                                      : ColoredBox(color: pal.soft),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                teacher.name,
                                style: T.of(14, FontWeight.w500, C.body),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _Chip(
                              '${fa(c.moduleCount)} فصل • ${fa(c.unitCount)} واحد',
                              bg: C.sand,
                              fg: C.body,
                            ),
                            if (free.isNotEmpty)
                              _Chip(free, bg: C.greenSoft, fg: C.greenText),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: Btn(
                            started ? 'ادامه' : 'شروع رایگان',
                            height: 52,
                            fontSize: 16,
                            onPressed: open,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Chip(this.text, {required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Center(
      widthFactor: 1,
      child: Text(text, style: T.of(12, FontWeight.w800, fg)),
    ),
  );
}

/// «رویداد»: a month/day tile, «N روز مونده» and a button to the linked
/// announcement. There's no sign-up in the app.
class _EventBlock extends StatelessWidget {
  final HomeBlockData b;
  final String instituteId;
  const _EventBlock({required this.b, required this.instituteId});

  static String _hour(DateTime d) {
    final h = d.hour;
    final part = h < 12
        ? 'صبح'
        : h < 14
        ? 'ظهر'
        : h < 18
        ? 'عصر'
        : 'شب';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    final m = d.minute == 0 ? '' : ':${d.minute.toString().padLeft(2, '0')}';
    return fa('ساعت $h12$m $part');
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final at = b.startsAt!.toLocal();
    final j = Jalali.fromDateTime(at);
    final today = DateTime.now();
    final days = DateTime(
      at.year,
      at.month,
      at.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    final left = days <= 0
        ? 'امروز'
        : days == 1
        ? 'فردا'
        : '${fa(days)} روز مونده';
    final when = [
      weekdayNames[(at.weekday + 1) % 7],
      if (at.hour != 0 || at.minute != 0) _hour(at),
      if (b.place.isNotEmpty) b.place,
    ].join(' • ');
    final announcement = b.announcementId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: pal.soft,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 66,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: C.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [lip(C.lip, 3)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: pal.p,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          jalaliMonths[j.month - 1],
                          textAlign: TextAlign.center,
                          style: T.of(12, FontWeight.w800, pal.on),
                        ),
                      ),
                      Text(
                        fa(j.day),
                        textAlign: TextAlign.center,
                        style: T.of(26, FontWeight.w900, C.ink, 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (b.kicker.isNotEmpty)
                        Text(
                          b.kicker,
                          style: T.of(12, FontWeight.w800, pal.ink),
                        ),
                      Text(
                        b.title,
                        style: T.of(17, FontWeight.w900, C.ink, 1.5),
                      ),
                      Text(when, style: T.of(13, FontWeight.w500, C.body)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: C.surface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MIcon(MI.clock, size: 15, color: pal.ink),
                      const SizedBox(width: 6),
                      Text(left, style: T.of(13, FontWeight.w800, pal.ink)),
                    ],
                  ),
                ),
                const Spacer(),
                if (announcement != null)
                  Btn(
                    b.cta.isNotEmpty ? b.cta : 'جزئیات',
                    height: 42,
                    fontSize: 14,
                    expand: false,
                    onPressed: () => context.push(
                      Routes.announcement(instituteId, announcement),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// «ردیف دوره‌ها»: the same course cards as before; members see progress.
class _CoursesBlock extends StatelessWidget {
  final HomeBlockData b;
  final String instituteId;
  final Brand brand;
  const _CoursesBlock({
    required this.b,
    required this.instituteId,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SectionTitle(
          b.heading,
          action: 'همه',
          onAction: () => context.go(Routes.instCourses(instituteId)),
        ),
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 272,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          itemCount: b.courses.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) =>
              _CourseMini(course: b.courses[i], brand: brand),
        ),
      ),
    ],
  );
}

/// «پیشنهاد و تخفیف»: a discount code as a ticket, with «کپی».
class _OfferBlock extends StatelessWidget {
  final HomeOffer offer;
  const _OfferBlock({required this.offer});

  static const _ink = Color(0xFF3D2600);
  static const _brown = Color(0xFF6B4300);
  static const _dash = Color(0xFFFFD27A);

  @override
  Widget build(BuildContext context) {
    final title =
        '${fa(offer.percent)}٪ تخفیف${offer.firstPaymentOnly ? ' اولین اشتراک' : ''}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _DashedBox(
        color: _dash,
        radius: 22,
        fill: const Color(0xFFFFF4DC),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: C.sun,
                      shape: BoxShape.circle,
                      boxShadow: [lip(C.sunDark, 3)],
                    ),
                    alignment: Alignment.center,
                    child: Text('٪', style: T.of(22, FontWeight.w900, _ink)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: T.of(17, FontWeight.w900, _ink)),
                        Text(
                          'روی «${offer.courseTitle}»؛ موقع پرداخت کد رو بزن.',
                          style: T.of(13, FontWeight.w500, _brown, 1.7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _DashedBox(
                    color: _dash,
                    radius: 12,
                    fill: C.surface,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      child: Text(
                        offer.code,
                        textDirection: TextDirection.ltr,
                        style: T
                            .of(15, FontWeight.w900, _ink)
                            .copyWith(letterSpacing: 0.9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      offer.expiresAt == null
                          ? ''
                          : 'تا ${jDay(offer.expiresAt!)}',
                      style: T.of(12, FontWeight.w700, _brown),
                    ),
                  ),
                  MasirPressable(
                    semanticLabel: 'کپی کد ${offer.code}',
                    sink: 3,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: offer.code));
                      Toast.show(context, title: 'کد کپی شد', body: offer.code);
                    },
                    builder: (context, pressed) => Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: pressed
                            ? null
                            : [lip(const Color(0xFFEBD9AE), 3)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const MIcon(MI.copy, size: 14, color: _ink),
                          const SizedBox(width: 6),
                          Text('کپی', style: T.of(13, FontWeight.w800, _ink)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeachersBlock extends StatelessWidget {
  final HomeBlockData b;
  final String instituteId;
  const _TeachersBlock({required this.b, required this.instituteId});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SectionTitle(
          b.heading,
          action: 'همه',
          onAction: () => context.go(Routes.instTeachers(instituteId)),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 216,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: b.teachers.length,
          separatorBuilder: (_, _) => const SizedBox(width: 18),
          itemBuilder: (_, i) =>
              Polaroid(teacher: b.teachers[i], tilt: i.isEven ? -3 : 2.5),
        ),
      ),
    ],
  );
}

class _PhotosBlock extends StatelessWidget {
  final HomeBlockData b;
  final Brand brand;
  const _PhotosBlock({required this.b, required this.brand});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(b.heading, style: T.of(20, FontWeight.w900)),
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: b.photos.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, i) => ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 220,
              child: CoverImage(url: b.photos[i], brand: brand),
            ),
          ),
        ),
      ),
    ],
  );
}

/// «درباره‌ی ما»: a short paragraph and a few ticked points.
class _AboutBlock extends StatelessWidget {
  final HomeBlockData b;
  const _AboutBlock({required this.b});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(b.heading, style: T.of(20, FontWeight.w900)),
          const SizedBox(height: 10),
          Text(b.text, style: T.of(15, FontWeight.w500, C.body, 1.95)),
          for (final it in b.items) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: pal.soft,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: MIcon(
                    MI.check,
                    size: 13,
                    color: pal.ink,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(it, style: T.of(15, FontWeight.w500, C.ink, 1.8)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// «راه‌های ارتباط»: address, phone and outside links; empty rows hide.
class _ContactBlock extends StatelessWidget {
  final HomeBlockData b;
  const _ContactBlock({required this.b});

  static String _label(String kind) => switch (kind) {
    'telegram' => 'تلگرام',
    'instagram' => 'اینستاگرام',
    _ => 'وب‌سایت',
  };

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    Widget row(MI icon, Widget text, {VoidCallback? onTap}) => GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          MIcon(icon, size: 18, color: pal.ink),
          const SizedBox(width: 8),
          Expanded(child: text),
        ],
      ),
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: C.surface,
        border: Border.all(color: C.border, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(b.heading, style: T.of(16, FontWeight.w900)),
          if (b.address.isNotEmpty) ...[
            const SizedBox(height: 10),
            row(
              MI.pin,
              Text(b.address, style: T.of(14, FontWeight.w500, C.body)),
            ),
          ],
          if (b.phone.isNotEmpty) ...[
            const SizedBox(height: 10),
            row(
              MI.call,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  fa(b.phone),
                  textDirection: TextDirection.ltr,
                  style: T.of(14, FontWeight.w500, C.body),
                ),
              ),
              onTap: () => launchUrl(
                Uri.parse('tel:${b.phone.replaceAll(RegExp(r'[^0-9+]'), '')}'),
              ),
            ),
          ],
          if (b.links.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final l in b.links)
                  Semantics(
                    button: true,
                    child: GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse(l.url),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: pal.soft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MIcon(MI.link, size: 14, color: pal.ink),
                            const SizedBox(width: 6),
                            Text(
                              _label(l.kind),
                              style: T.of(13, FontWeight.w800, pal.ink),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A filled box with a dashed outline (the offer ticket).
class _DashedBox extends StatelessWidget {
  final Color color;
  final Color fill;
  final double radius;
  final Widget child;
  const _DashedBox({
    required this.color,
    required this.fill,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: DashedRRectPainter(color: color, radius: radius),
    child: Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    ),
  );
}
