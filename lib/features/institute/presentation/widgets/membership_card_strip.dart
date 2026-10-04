import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/theme/theme_context.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/features/main/presentation/page/institutes_page.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/paper_card.dart';
import '/widgets/skeleton.dart';

/// Horizontal strip of collectible membership cards. A single membership
/// collapses to one full-width card, so a student with one club never learns
/// that switching exists.
class MembershipCardStrip extends StatelessWidget {
  final WalletBloc bloc;
  final void Function(WalletCardModel card) onTap;

  const MembershipCardStrip({
    super.key,
    required this.bloc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      bloc: bloc,
      builder: (context, state) {
        return state.when(
          loading: (_) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SkeletonBox(height: 200, radius: 20),
          ),
          error: (_, _) => const SizedBox.shrink(),
          success: (_, data) {
            if (data.isEmpty) return const _NoMembershipsCard();
            if (data.length == 1) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MembershipCard(
                  card: data.first,
                  onTap: () => onTap(data.first),
                ),
              );
            }
            return SizedBox(
              height: 216,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
          },
        );
      },
    );
  }
}

class _NoMembershipsCard extends StatelessWidget {
  const _NoMembershipsCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PaperCard(
        tint: c.primaryTint,
        tintEdge: c.primary.withValues(alpha: 0.35),
        padding: const EdgeInsets.all(20),
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
                  const CustomText(
                    'هنوز عضو جایی نیستی',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  4.h,
                  CustomText(
                    'یک مؤسسه پیدا کن و با یک لمس عضو شو.',
                    fontSize: 13,
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
