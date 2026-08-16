import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
              Center(
                child: CustomText(
                  teacher.name ?? '',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              if (teacher.headline?.isNotEmpty == true) ...[
                6.h,
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
                Html(
                  data: teacher.bio!,
                  style: {
                    'body': Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(15),
                      color: context.colors.ink,
                      textAlign: TextAlign.right,
                      direction: TextDirection.rtl,
                    ),
                  },
                ),
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
                          child: CustomText(
                            link.url!,
                            color: context.colors.primary,
                            fontSize: 13,
                          ),
                        ),
                  ],
                ),
              ],
              if (teacher.courses.isNotEmpty) ...[
                16.h,
                CustomText('دوره‌ها در این مؤسسه', fontWeight: FontWeight.w600),
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
