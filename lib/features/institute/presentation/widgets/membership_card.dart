import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/widgets/custom_text.dart';

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
    final preset =
        kInstitutePresets[card.themePreset] ?? kInstitutePresets[kDefaultPreset]!;
    final name = card.name ?? '';
    final action = card.nextAction;
    final memberSince = formatMemberSince(card.memberSince);

    return OnClick(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: preset.primarySoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.ink.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 1.5, color: preset.primary),
            AspectRatio(
              aspectRatio: 3 / 1,
              child: card.coverUrl != null && card.coverUrl!.isNotEmpty
                  ? Image.network(
                      card.coverUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          ColoredBox(color: preset.primary),
                    )
                  : ColoredBox(color: preset.primary),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Hero(
                    tag: 'institute-logo-${card.instituteId}',
                    child: _Logo(
                      name: name,
                      logoUrl: card.logoUrl,
                      preset: preset,
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          name,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        if (memberSince.isNotEmpty) ...[
                          4.h,
                          CustomText(
                            memberSince,
                            fontSize: 12,
                            color: context.colors.inkMuted,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: action == null
                  ? CustomText(
                      'شروع یادگیری',
                      fontSize: 13,
                      color: context.colors.inkMuted,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                'ادامه یادگیری',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CustomText(
                              formatProgressPercent(action.progressPercent),
                              fontSize: 12,
                              color: context.colors.inkMuted,
                            ),
                          ],
                        ),
                        if ((action.unitTitle ?? action.courseTitle) !=
                            null) ...[
                          4.h,
                          CustomText(
                            action.unitTitle ?? action.courseTitle ?? '',
                            fontSize: 12,
                            color: context.colors.inkMuted,
                          ),
                        ],
                        8.h,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: (action.progressPercent.clamp(0, 100)) /
                                100,
                            minHeight: 6,
                            backgroundColor: context.colors.ink.withValues(
                              alpha: 0.1,
                            ),
                            color: preset.primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String name;
  final String? logoUrl;
  final InstitutePreset preset;

  const _Logo({required this.name, required this.logoUrl, required this.preset});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 48,
        height: 48,
        color: preset.primary,
        alignment: Alignment.center,
        child: logoUrl != null && logoUrl!.isNotEmpty
            ? Image.network(
                logoUrl!,
                fit: BoxFit.cover,
                width: 48,
                height: 48,
                errorBuilder: (_, _, _) => _Initial(name: name, preset: preset),
              )
            : _Initial(name: name, preset: preset),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  final String name;
  final InstitutePreset preset;

  const _Initial({required this.name, required this.preset});

  @override
  Widget build(BuildContext context) {
    return Text(
      name.isNotEmpty ? name.characters.first : 'م',
      style: TextStyle(
        color: preset.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}
