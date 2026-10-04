import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/widgets/custom_text.dart';
import '/widgets/paper_card.dart';
import '/widgets/pill_chip.dart';
import '/widgets/skeleton.dart';

class InstituteMePage extends StatelessWidget {
  const InstituteMePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return BlocBuilder<InstituteDetailBloc, InstituteDetailState>(
      builder: (context, detailState) {
        return detailState.when(
          loading: (_) => const SkeletonList(),
          error: (_, _) => const SizedBox.shrink(),
          success: (_, detail) {
            final isMember = detail.membership.isMember;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                const CustomText(
                  'من در این مؤسسه',
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
                12.h,
                Row(
                  children: [
                    PillChip(
                      isMember ? 'عضو' : 'هنوز عضو نشده‌ای',
                      tone: isMember ? PillTone.success : PillTone.neutral,
                      icon: isMember
                          ? Icons.verified_rounded
                          : Icons.lock_outline_rounded,
                    ),
                    if (detail.membership.memberSince != null) ...[
                      8.w,
                      CustomText(
                        formatMemberSince(detail.membership.memberSince),
                        fontSize: 12,
                        color: c.inkMuted,
                      ),
                    ],
                  ],
                ),
                20.h,
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
                      return PaperCard(
                        tint: c.primaryTint,
                        tintEdge: c.primary.withValues(alpha: 0.35),
                        child: Row(
                          children: [
                            Icon(Icons.badge_rounded, color: c.primary, size: 32),
                            12.w,
                            Expanded(
                              child: CustomText(
                                'کارت عضویتت پس از عضو شدن اینجا نمایش داده می‌شود.',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
