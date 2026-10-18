import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/common/widgets.dart';
import '/app/routes.dart';
import '/core/api/models.dart';
import '/design/design.dart';

/// Full-width course card: cover with the intro badge and access tag, title,
/// teacher • level • units, then progress or price.
class CourseTile extends StatelessWidget {
  final CourseCard course;
  const CourseTile({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final c = course;
    final a = c.access;
    final meta = [
      if (c.teacherLine.isNotEmpty) c.teacherLine,
      if (c.level != null && levelNames[c.level] != null) levelNames[c.level]!,
      if (c.unitCount > 0) '${fa(c.unitCount)} واحد',
    ].join(' • ');
    final tag = switch (a.state) {
      AccessState.active => (
        text: 'اشتراک فعال • ${pct(c.progressPercent)}',
        fg: C.greenText,
        bg: C.greenSoft,
      ),
      AccessState.expiring => (
        text: '${fa(a.daysLeft ?? 0)} روز تا تمدید',
        fg: const Color(0xFF8A5A00),
        bg: const Color(0xFFFFF2D6),
      ),
      AccessState.expired => (
        text: 'اشتراک تموم شده',
        fg: C.coralText,
        bg: C.coralSoft,
      ),
      _ => null,
    };
    final started = a.enrolled && (c.progressPercent > 0 || a.fullAccess);
    return GestureDetector(
      onTap: () => context.push(Routes.course(c.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        clipBehavior: Clip.antiAlias,
        decoration: cardDecoration(radius: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CoverImage(url: c.coverUrl, brand: context.brand),
                  if (c.introVideoUrl.isNotEmpty)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: VideoBadge(c.introVideoSeconds),
                    ),
                  if (tag != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: tag.bg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tag.text,
                          style: T.of(12, FontWeight.w800, tag.fg),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(c.title, style: T.of(17, FontWeight.w800)),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(meta, style: T.of(13, FontWeight.w500, C.muted)),
                  ],
                  const SizedBox(height: 6),
                  if (started && !c.freeCourse)
                    Track(value: c.progressPercent / 100, height: 6)
                  else if (c.freeCourse)
                    Text(
                      'رایگان',
                      style: T.of(13, FontWeight.w800, C.greenText),
                    )
                  else
                    Row(
                      children: [
                        if (c.previewUnits > 0)
                          Text(
                            '${fa(c.previewUnits)} واحد رایگان',
                            style: T.of(13, FontWeight.w800, C.greenText),
                          ),
                        const Spacer(),
                        if (c.fromPerMonth > 0)
                          Text(
                            'از ${perMonth(c.fromPerMonth)}',
                            style: T.of(13, FontWeight.w800),
                          ),
                      ],
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
