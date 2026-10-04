import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/theme_context.dart';
import '/features/teacher/domain/entities/teacher.dart';
import '/features/teacher/presentation/widgets/teacher_avatar.dart';
import '/widgets/custom_text.dart';

bool inInstituteShell(BuildContext context) {
  try {
    return GoRouterState.of(context).uri.path.startsWith('/i/');
  } catch (_) {
    return false;
  }
}

void openTeacherIfAllowed(BuildContext context, String? userId) {
  if (userId == null || userId.isEmpty) return;
  if (inInstituteShell(context)) return;
  context.push('/teachers/$userId');
}

String persianOthersLabel(int extra) {
  const digits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  final raw = extra.toString().split('').map((c) {
    final n = int.tryParse(c);
    return n == null ? c : digits[n];
  }).join();
  return 'و $raw نفر دیگر';
}

class CourseTeacherRow extends StatelessWidget {
  final List<CourseTeacherSummary> teachers;
  final bool compact;
  final bool showHeadlines;

  const CourseTeacherRow({
    super.key,
    required this.teachers,
    this.compact = true,
    this.showHeadlines = false,
  });

  @override
  Widget build(BuildContext context) {
    if (teachers.isEmpty) return const SizedBox.shrink();
    if (!compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final teacher in teachers)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TeacherLine(
                teacher: teacher,
                showHeadline: showHeadlines,
              ),
            ),
        ],
      );
    }

    final first = teachers.first;
    final extra = teachers.length - 1;
    return _TeacherLine(
      teacher: first,
      trailing: extra > 0 ? persianOthersLabel(extra) : null,
      showHeadline: false,
    );
  }
}

class _TeacherLine extends StatelessWidget {
  final CourseTeacherSummary teacher;
  final String? trailing;
  final bool showHeadline;

  const _TeacherLine({
    required this.teacher,
    this.trailing,
    this.showHeadline = false,
  });

  @override
  Widget build(BuildContext context) {
    final tappable = !inInstituteShell(context);
    final row = Row(
      children: [
        TeacherAvatar(
          name: teacher.name ?? '',
          photoUrl: teacher.photoUrl,
          size: 28,
        ),
        8.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText.caption(teacher.name ?? ''),
              if (showHeadline && (teacher.headline?.isNotEmpty ?? false))
                CustomText.caption(
                  teacher.headline!,
                  color: context.colors.inkMuted,
                ),
            ],
          ),
        ),
        if (trailing != null)
          CustomText.caption(trailing!, color: context.colors.inkMuted),
      ],
    );
    if (!tappable) return row;
    return OnClick(
      onTap: () => openTeacherIfAllowed(context, teacher.userId),
      child: row,
    );
  }
}

Widget? unitTeacherHeaderIcon(List<CourseTeacherSummary> teachers) {
  if (teachers.isEmpty) return null;
  return TeacherHeaderChip(teacher: teachers.first);
}

class TeacherHeaderChip extends StatelessWidget {
  final CourseTeacherSummary teacher;

  const TeacherHeaderChip({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TeacherAvatar(
          name: teacher.name ?? '',
          photoUrl: teacher.photoUrl,
          size: 24,
        ),
        4.w,
        CustomText.caption(teacher.name ?? '', maxLines: 1),
      ],
    );
  }
}
