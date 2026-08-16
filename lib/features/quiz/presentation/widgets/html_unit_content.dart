import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_content_framework.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class HtmlUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;
  final Widget? banner;
  final Widget? footer;

  const HtmlUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onComplete,
    required this.onBack,
    this.banner,
    this.footer,
  });

  String get _body => data.payload?.body ?? '';

  @override
  Widget build(BuildContext context) {
    return UnitContentFramework(
      title: data.title ?? '',
      typeLabel: 'درس',
      isCompleted: isCompleted,
      instructionText: '',
      headerIcon: unitTeacherHeaderIcon(data.teachers),
      banner: banner,
      footer: footer,
      isSubmitting: isSubmitting,
      onComplete: onComplete,
      onBack: onBack,
      content: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: Html(
          data: _body,
          style: {
            'body': Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontSize: FontSize(16),
              color: context.colors.ink,
              textAlign: TextAlign.right,
              direction: TextDirection.rtl,
              lineHeight: LineHeight.number(1.7),
            ),
            'p': Style(color: context.colors.ink, fontSize: FontSize(16)),
            'h2': Style(
              color: context.colors.ink,
              fontSize: FontSize(20),
              fontWeight: FontWeight.w700,
            ),
            'h3': Style(
              color: context.colors.ink,
              fontSize: FontSize(18),
              fontWeight: FontWeight.w700,
            ),
            'a': Style(color: context.colors.primary),
          },
        ),
      ),
    );
  }
}
