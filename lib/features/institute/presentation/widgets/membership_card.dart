import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/progress_pill.dart';
import '/core/theme/masir_style.dart';

/// Collectible membership card in the institute's own colours.
class MembershipCard extends StatelessWidget {
  final WalletCardModel card;
  final VoidCallback? onTap;
  final bool compact;

  const MembershipCard({
    super.key,
    required this.card,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final preset = presetFor(card.themePreset);
    final name = card.name ?? '';
    final action = card.nextAction;
    final memberSince = formatMemberSince(card.memberSince);
    final logoSize = compact ? 48.0 : 56.0;
    final coverHeight = compact ? 84.0 : 112.0;

    return ChunkyBox(
      fill: c.surface,
      edge: preset.edge,
      borderColor: preset.primary,
      onTap: onTap,
      clip: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(MasirRadius.card),
                ),
                child: SizedBox(
                  height: coverHeight,
                  child: CoverImage(
                    url: card.coverUrl,
                    fallback: preset.primary,
                    height: coverHeight,
                  ),
                ),
              ),
              PositionedDirectional(
                bottom: -logoSize / 2,
                start: 14,
                child: Hero(
                  tag: 'institute-logo-${card.instituteId}',
                  child: InstituteLogo(
                    logoUrl: card.logoUrl,
                    name: name,
                    preset: preset,
                    size: logoSize,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, logoSize / 2 + 8, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.headline(name, maxLines: 1),
                if (!compact && memberSince.isNotEmpty) ...[
                  4.h,
                  CustomText.caption(memberSince, color: c.inkMuted),
                ],
                8.h,
                if (action == null)
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_rounded,
                        size: 18,
                        color: preset.primary,
                      ),
                      4.w,
                      CustomText.caption('شروع یادگیری', color: preset.primary),
                    ],
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomText.caption(
                          action.unitTitle ??
                              action.courseTitle ??
                              'ادامه یادگیری',
                          maxLines: 1,
                        ),
                      ),
                      8.w,
                      CustomText.caption(
                        formatProgressPercent(action.progressPercent),
                        color: preset.primary,
                      ),
                    ],
                  ),
                  8.h,
                  ProgressPill(
                    value: action.progressPercent,
                    height: 8,
                    color: preset.primary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
