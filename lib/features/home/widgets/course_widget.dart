import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/domain/entities/teacher.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final List<CourseTeacherSummary> teachers;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.teachers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.border),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        title,
                        textAlign: TextAlign.right,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.colors.ink,
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        description,
                        textAlign: TextAlign.right,
                        fontSize: 14,
                        color: context.colors.inkMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      if (teachers.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CourseTeacherRow(teachers: teachers),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: context.colors.primaryTint,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(icon, size: 34, color: context.colors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
