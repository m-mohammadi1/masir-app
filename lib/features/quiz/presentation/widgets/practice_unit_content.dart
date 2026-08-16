import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_content_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class PracticeUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;
  final Widget? banner;
  final Widget? footer;

  const PracticeUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onComplete,
    required this.onBack,
    this.banner,
    this.footer,
  });

  String get _instructions => data.payload?.instructions ?? '';

  String? get _attachmentUrl => data.payload?.attachmentUrl;

  Future<void> _openAttachment() async {
    final url = _attachmentUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnitContentFramework(
      title: data.title ?? '',
      typeLabel: 'تمرین',
      isCompleted: isCompleted,
      instructionText: _instructions,
      attachmentUrl: _attachmentUrl,
      headerIcon: unitTeacherHeaderIcon(data.teachers),
      banner: banner,
      footer: footer,
      isSubmitting: isSubmitting,
      onComplete: onComplete,
      onBack: onBack,
      onAttachmentTap: _openAttachment,
    );
  }
}
