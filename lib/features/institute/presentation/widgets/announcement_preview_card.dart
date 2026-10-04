import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/announcement_model.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';

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
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: unread ? c.sun : c.primaryTint,
              borderRadius: BorderRadius.circular(12),
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
                CustomText(
                  item.title ?? '',
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  maxLines: 2,
                ),
                4.h,
                CustomText(
                  htmlExcerpt(item.body),
                  fontSize: 13,
                  color: c.inkMuted,
                  maxLines: 2,
                ),
                6.h,
                CustomText(
                  formatRelativeFa(item.publishedAt),
                  fontSize: 12,
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
