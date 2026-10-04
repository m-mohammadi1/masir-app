import 'package:flutter/material.dart';

import '/core/theme/theme_context.dart';
import '/features/main/domain/entities/courses.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/pill_chip.dart';
import '/widgets/progress_pill.dart';

String? levelLabelFa(String? level) {
  switch (level) {
    case 'beginner':
      return 'مبتدی';
    case 'intermediate':
      return 'متوسط';
    case 'advanced':
      return 'پیشرفته';
  }
  return null;
}

/// Shared course row: cover, title, teacher, level, and either progress
/// (when the student has started) or a lock (when not a member yet).
class CourseCard extends StatelessWidget {
  final CoursesEntity course;
  final bool locked;

  /// 0..100 when the student already subscribed and has progress.
  final int? progress;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.locked = false,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final level = levelLabelFa(course.level);
    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 76,
              height: 76,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CoverImage(
                    url: course.coverUrl,
                    fallback: c.primaryTint,
                    width: 76,
                    height: 76,
                  ),
                  if (locked)
                    ColoredBox(
                      color: Colors.black.withValues(alpha: 0.35),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  course.title ?? '',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  maxLines: 2,
                ),
                if (course.teachers.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  CourseTeacherRow(teachers: course.teachers),
                ],
                if (progress != null) ...[
                  const SizedBox(height: 8),
                  ProgressPill(value: progress!, height: 8),
                ] else if (level != null) ...[
                  const SizedBox(height: 8),
                  PillChip(level, tone: PillTone.neutral),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_left_rounded, color: c.locked),
        ],
      ),
    );
  }
}
