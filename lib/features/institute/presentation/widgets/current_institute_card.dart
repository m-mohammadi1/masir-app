import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/helper/jalali_format.dart';
import '/core/helper/route_args.dart';
import '/core/services/hive_service.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/masir_style.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/domain/entities/wallet_card.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/institute_switcher_sheet.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/progress_pill.dart';
import '/widgets/skeleton.dart';

/// The student's current institute, pinned at the top of ویترین.
///
/// It paints from the locally stored institute on the very first frame, then
/// upgrades to the wallet card (progress, next unit) once that arrives. With
/// no stored institute it falls back to the most useful wallet card; with no
/// memberships at all it renders nothing (the strip below explains how to
/// join).
class CurrentInstituteCard extends StatelessWidget {
  final WalletBloc bloc;

  const CurrentInstituteCard({super.key, required this.bloc});

  /// The institute to pin: the stored one if the wallet still has it, else the
  /// first card with something to continue, else the first card.
  static WalletCardModel? resolve(
    List<WalletCardModel> cards,
    String? currentId,
  ) {
    if (cards.isEmpty) return null;
    if (currentId != null && currentId.isNotEmpty) {
      for (final card in cards) {
        if (card.instituteId == currentId) return card;
      }
    }
    for (final card in cards) {
      if (card.nextAction?.courseId != null) return card;
    }
    return cards.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      bloc: bloc,
      builder: (context, state) {
        final stored = HiveService.hasCurrentInstitute
            ? WalletCardModel(
                instituteId: HiveService.currentInstituteId,
                name: HiveService.currentInstituteName,
                slug: HiveService.currentInstituteSlug,
                logoUrl: HiveService.currentInstituteLogoUrl,
                themePreset: HiveService.currentInstitutePreset,
              )
            : null;

        final card = state.when(
          loading: (_) => stored,
          error: (_, _) => stored,
          success: (_, data) => resolve(data, HiveService.currentInstituteId),
        );

        if (card == null) {
          final waiting = state.maybeWhen(
            loading: (_) => true,
            orElse: () => false,
          );
          return waiting
              ? const Padding(
                  padding: MasirSpace.pageH,
                  child: SkeletonBox(height: 168, radius: MasirRadius.hero),
                )
              : const SizedBox.shrink();
        }
        return Padding(
          padding: MasirSpace.pageH,
          child: _Card(card: card),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final WalletCardModel card;

  const _Card({required this.card});

  void _enter() {
    final id = card.instituteId;
    if (id == null || id.isEmpty) return;
    CustomNavigator.pushNamed('/i/$id/home');
  }

  void _continue(WalletNextAction action) {
    CustomNavigator.pushNamed(
      OutlinePage.routeName,
      arguments: withThemePreset({
        'id': action.courseId!,
        'title': action.courseTitle ?? '',
      }, card.themePreset),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preset = presetFor(card.themePreset);
    final on = preset.onPrimary;
    final action = card.nextAction;
    final canContinue = action?.courseId != null;

    return ChunkyBox(
      fill: preset.primary,
      edge: preset.edge,
      radius: MasirRadius.hero,
      padding: const EdgeInsets.all(MasirSpace.lg),
      onTap: _enter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InstituteLogo(
                logoUrl: card.logoUrl,
                name: card.name ?? '',
                preset: preset,
                size: 48,
                ring: false,
              ),
              const SizedBox(width: MasirSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText.micro(
                      'مؤسسه‌ی فعلی تو',
                      color: on.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 2),
                    CustomText.headline(
                      card.name ?? '',
                      color: on,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showInstituteSwitcher(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MasirSpace.md,
                    vertical: MasirSpace.sm - 2,
                  ),
                  decoration: BoxDecoration(
                    color: on.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(MasirRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        size: MasirIconSize.sm,
                        color: on,
                      ),
                      const SizedBox(width: MasirSpace.xs),
                      CustomText.micro('عوض کردن', color: on),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (canContinue) ...[
            const SizedBox(height: MasirSpace.lg),
            CustomText.bodyStrong(
              action!.unitTitle ?? action.courseTitle ?? 'ادامه یادگیری',
              color: on,
              maxLines: 1,
            ),
            if (action.moduleTitle != null) ...[
              const SizedBox(height: 2),
              CustomText.caption(
                action.moduleTitle!,
                color: on.withValues(alpha: 0.8),
                maxLines: 1,
              ),
            ],
            const SizedBox(height: MasirSpace.md),
            Row(
              children: [
                Expanded(
                  child: ProgressPill(
                    value: action.progressPercent,
                    height: 10,
                    color: on,
                    trackColor: on.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(width: MasirSpace.md),
                CustomText.caption(
                  formatProgressPercent(action.progressPercent),
                  color: on,
                  weight: MasirText.heavy,
                ),
              ],
            ),
          ],
          const SizedBox(height: MasirSpace.lg),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _CardButton(
                  label: canContinue ? 'ادامه یادگیری' : 'ورود به مؤسسه',
                  fill: on,
                  fg: preset.edge,
                  onTap: canContinue ? () => _continue(action!) : _enter,
                ),
              ),
              if (canContinue) ...[
                const SizedBox(width: MasirSpace.sm),
                Expanded(
                  flex: 2,
                  child: _CardButton(
                    label: 'ورود به مؤسسه',
                    fill: on.withValues(alpha: 0.2),
                    fg: on,
                    onTap: _enter,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final String label;
  final Color fill;
  final Color fg;
  final VoidCallback onTap;

  const _CardButton({
    required this.label,
    required this.fill,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(MasirRadius.row),
        ),
        child: CustomText.bodyStrong(label, color: fg, maxLines: 1),
      ),
    );
  }
}
