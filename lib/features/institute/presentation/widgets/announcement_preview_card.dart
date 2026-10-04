import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/announcement_model.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/core/theme/masir_style.dart';

/// Announcement as a "megaphone" card. Unread ones glow in sun colours.
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
    final c = context.colors;
    final unread = item.isUnread;
    return ChunkyBox(
      fill: unread ? c.sunSoft : c.surface,
      edge: unread ? c.sun : c.lip,
      borderColor: unread ? c.sun : c.border,
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: unread ? c.sun : c.primaryTint,
              borderRadius: BorderRadius.circular(MasirRadius.chip),
            ),
            child: Icon(
              Icons.campaign_rounded,
              size: 22,
              color: unread ? Colors.white : c.primary,
            ),
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bodyStrong(item.title ?? '', maxLines: 2),
                4.h,
                CustomText.caption(
                  htmlExcerpt(item.body),
                  color: c.inkMuted,
                  maxLines: 2,
                ),
                4.h,
                CustomText.caption(
                  formatRelativeFa(item.publishedAt),
                  color: c.inkMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
