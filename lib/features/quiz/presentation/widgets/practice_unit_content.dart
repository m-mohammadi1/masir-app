import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/unit_kit/unit_shell.dart';
import 'package:url_launcher/url_launcher.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';
import '/widgets/icon_tile.dart';
import '/widgets/list_row.dart';

/// A practice task: what to do on a sun-coloured card, the attached file as
/// a tappable row, and a tip about the button below.
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
    final c = context.colors;
    final hasAttachment = _attachmentUrl != null && _attachmentUrl!.isNotEmpty;
    return UnitShell(
      type: 'practice',
      title: data.title ?? '',
      isCompleted: isCompleted,
      meta: hasAttachment ? 'همراه با فایل' : null,
      headerIcon: unitTeacherHeaderIcon(data.teachers),
      banner: banner,
      footer: footer,
      isSubmitting: isSubmitting,
      onComplete: onComplete,
      onBack: onBack,
      children: [
        if (_instructions.isNotEmpty)
          ChunkyBox(
            fill: c.sunSoft,
            edge: c.sunEdge,
            borderColor: c.sun,
            radius: MasirRadius.card,
            padding: const EdgeInsets.all(MasirSpace.xl - MasirSpace.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flag_rounded,
                      size: MasirIconSize.md,
                      color: c.sunEdge,
                    ),
                    const SizedBox(width: MasirSpace.sm),
                    Expanded(
                      child: CustomText.caption(
                        'کاری که باید انجام بدی',
                        color: c.sunEdge,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MasirSpace.md),
                CustomText.headline(_instructions, color: c.ink),
              ],
            ),
          ),
        if (hasAttachment) ...[
          const SizedBox(height: MasirSpace.md),
          ListRow(
            leading: const IconTile(
              Icons.attach_file_rounded,
              tone: IconTileTone.sun,
            ),
            title: 'باز کردن فایل',
            subtitle: 'فایل همراه تمرین',
            onTap: _openAttachment,
          ),
        ],
        if (!isCompleted) ...[
          const SizedBox(height: MasirSpace.lg),
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: MasirIconSize.md,
                color: c.inkFaint,
              ),
              const SizedBox(width: MasirSpace.sm),
              Expanded(
                child: CustomText.caption(
                  'وقتی انجامش دادی، دکمه‌ی پایین رو بزن.',
                  color: c.inkMuted,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
