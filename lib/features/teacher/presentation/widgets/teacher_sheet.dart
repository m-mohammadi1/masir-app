import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/widgets/masir_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/theme/theme_context.dart';
import '/features/teacher/data/models/teacher_model.dart';
import '/features/teacher/presentation/widgets/teacher_avatar.dart';
import '/widgets/base_modal.dart';
import '/widgets/custom_text.dart';

Future<void> showInstituteTeacherSheet({
  required BuildContext context,
  required TeacherModel teacher,
}) async {
  await showCustomModal(
    context: context,
    isScrollControlled: true,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TeacherAvatar(
                  name: teacher.name ?? '',
                  photoUrl: teacher.photoUrl,
                  size: 88,
                ),
              ),
              12.h,
              Center(child: CustomText.headline(teacher.name ?? '')),
              if (teacher.headline?.isNotEmpty == true) ...[
                4.h,
                Center(
                  child: CustomText(
                    teacher.headline!,
                    color: context.colors.inkMuted,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (teacher.bio?.isNotEmpty == true) ...[
                16.h,
                MasirHtml(teacher.bio!),
              ],
              if (teacher.links.isNotEmpty) ...[
                16.h,
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    for (final link in teacher.links)
                      if (link.url != null && link.url!.isNotEmpty)
                        OnClick(
                          onTap: () => launchUrl(Uri.parse(link.url!)),
                          child: CustomText.caption(
                            link.url!,
                            color: context.colors.primary,
                          ),
                        ),
                  ],
                ),
              ],
              if (teacher.courses.isNotEmpty) ...[
                16.h,
                CustomText.body('دوره‌ها در این مؤسسه'),
                8.h,
                for (final course in teacher.courses)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: CustomText(course.title ?? ''),
                  ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
