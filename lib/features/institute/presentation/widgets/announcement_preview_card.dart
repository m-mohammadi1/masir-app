import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/announcement_model.dart';
import '/widgets/custom_text.dart';

class AnnouncementPreviewCard extends StatelessWidget {
  final AnnouncementModel item;
  final VoidCallback onTap;

  const AnnouncementPreviewCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (item.isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                Expanded(
                  child: CustomText(
                    item.title ?? '',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            6.h,
            CustomText(
              formatRelativeFa(item.publishedAt),
              fontSize: 12,
              color: context.colors.inkMuted,
            ),
            6.h,
            CustomText(
              htmlExcerpt(item.body),
              fontSize: 13,
              color: context.colors.inkMuted,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
