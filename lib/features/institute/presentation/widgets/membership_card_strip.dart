import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/theme/theme_context.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/current_institute_card.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/features/main/presentation/page/institutes_page.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/paper_card.dart';
import '/widgets/section_header.dart';
import '/widgets/skeleton.dart';
import '/core/theme/masir_style.dart';

/// Horizontal strip of collectible membership cards. A single membership
/// collapses to one full-width card, so a student with one club never learns
/// that switching exists.
class MembershipCardStrip extends StatelessWidget {
  final WalletBloc bloc;
  final void Function(WalletCardModel card) onTap;

  /// The stored current institute. The card pinned above the strip (resolved
  /// the same way) is left out of the strip.
  final String? currentInstituteId;

  const MembershipCardStrip({
    super.key,
    required this.bloc,
    required this.onTap,
    this.currentInstituteId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      bloc: bloc,
      builder: (context, state) {
        return state.when(
          loading: (_) => const Padding(
            padding: EdgeInsets.fromLTRB(
              MasirSpace.gutter,
              0,
              MasirSpace.gutter,
              MasirSpace.section,
            ),
            child: SkeletonBox(height: 120, radius: MasirRadius.card),
          ),
          error: (_, _) => const SizedBox.shrink(),
          success: (_, all) {
            if (all.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(bottom: MasirSpace.section),
                child: _NoMembershipsCard(),
              );
            }
            final pinned = CurrentInstituteCard.resolve(
              all,
              currentInstituteId,
            )?.instituteId;
            final data = [
              for (final card in all)
                if (card.instituteId != pinned) card,
            ];
            // Nothing besides the pinned institute: no strip at all.
            if (data.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: MasirSpace.pageH,
                  child: SectionHeader('مؤسسه‌های دیگر'),
                ),
                _cards(context, data),
                const SizedBox(height: MasirSpace.section),
              ],
            );
          },
        );
      },
    );
  }

  Widget _cards(BuildContext context, List<WalletCardModel> data) {
    if (data.length == 1) {
      return Padding(
        padding: MasirSpace.pageH,
        child: MembershipCard(card: data.first, onTap: () => onTap(data.first)),
      );
    }
    return SizedBox(
      height: 216,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: MasirSpace.pageH,
        itemCount: data.length,
        separatorBuilder: (_, _) => 12.w,
        itemBuilder: (context, index) {
          final card = data[index];
          return SizedBox(
            width: context.appSize.width * 0.72,
            child: MembershipCard(
              card: card,
              compact: true,
              onTap: () => onTap(card),
            ),
          );
        },
      ),
    );
  }
}

class _NoMembershipsCard extends StatelessWidget {
  const _NoMembershipsCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: MasirSpace.pageH,
      child: PaperCard(
        tint: c.primaryTint,
        tintEdge: c.primary.withValues(alpha: 0.35),
        padding: const EdgeInsets.all(MasirSpace.card),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school_rounded, color: c.onPrimary, size: 28),
            ),
            16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText.headline('هنوز عضو جایی نیستی'),
                  4.h,
                  CustomText.caption(
                    'یه مؤسسه پیدا کن و با یه لمس عضو شو.',
                    color: c.inkMuted,
                  ),
                  12.h,
                  CustomButton(
                    title: 'پیدا کردن مؤسسه',
                    height: 44,
                    width: 170,
                    onTap: () =>
                        CustomNavigator.pushNamed(InstitutesPage.routeName),
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
