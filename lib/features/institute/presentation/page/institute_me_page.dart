import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/widgets/custom_text.dart';
import '/widgets/masir_card.dart';
import '/widgets/masir_page.dart';
import '/widgets/pill_chip.dart';
import '/widgets/state_view.dart';

class InstituteMePage extends StatelessWidget {
  const InstituteMePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return BlocBuilder<InstituteDetailBloc, InstituteDetailState>(
      builder: (context, detailState) {
        return detailState.when(
          loading: (_) => const MasirPage.tab(
            title: 'من در این مؤسسه',
            children: [
              StateView.loading(variant: SkeletonVariant.cards, count: 1),
            ],
          ),
          error: (_, _) => const MasirPage.tab(
            title: 'من در این مؤسسه',
            children: [SizedBox.shrink()],
          ),
          success: (_, detail) {
            final isMember = detail.membership.isMember;
            return MasirPage.tab(
              title: 'من در این مؤسسه',
              children: [
                Row(
                  children: [
                    PillChip(
                      isMember ? 'عضو' : 'هنوز عضو نشده‌ای',
                      tone: isMember ? PillTone.success : PillTone.neutral,
                      icon: isMember
                          ? Icons.verified_rounded
                          : Icons.lock_rounded,
                    ),
                    if (detail.membership.memberSince != null) ...[
                      const SizedBox(width: MasirSpace.sm),
                      CustomText.caption(
                        formatMemberSince(detail.membership.memberSince),
                        color: c.inkMuted,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: MasirSpace.xl),
                BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, walletState) {
                    final card = walletState.whenOrNull(
                      success: (_, data) {
                        for (final item in data) {
                          if (item.instituteId == detail.id) return item;
                        }
                        return null;
                      },
                    );
                    if (card == null) {
                      return MasirCard.tinted(
                        child: Row(
                          children: [
                            Icon(
                              Icons.badge_rounded,
                              color: c.primary,
                              size: 32,
                            ),
                            const SizedBox(width: MasirSpace.md),
                            Expanded(
                              child: CustomText.bodyStrong(
                                'کارت عضویتت بعد از عضو شدن اینجا نشونش می‌دیم.',
                                color: c.ink,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return MembershipCard(card: card);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
