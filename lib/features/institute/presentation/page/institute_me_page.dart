import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/widgets/custom_text.dart';
import '/widgets/skeleton.dart';

class InstituteMePage extends StatelessWidget {
  const InstituteMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstituteDetailBloc, InstituteDetailState>(
      builder: (context, detailState) {
        return detailState.when(
          loading: (_) => const SkeletonList(),
          error: (_, _) => const SizedBox.shrink(),
          success: (_, detail) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                CustomText('من در این مؤسسه', fontWeight: FontWeight.bold, fontSize: 20),
                8.h,
                CustomText(
                  detail.membership.isMember ? 'در حال یادگیری' : 'هنوز عضو نشده‌اید',
                  color: context.colors.inkMuted,
                ),
                if (detail.membership.memberSince != null) ...[
                  4.h,
                  CustomText(
                    formatMemberSince(detail.membership.memberSince),
                    fontSize: 12,
                    color: context.colors.inkMuted,
                  ),
                ],
                16.h,
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
                      return CustomText(
                        'کارت عضویت پس از عضویت اینجا نمایش داده می‌شود.',
                        color: context.colors.inkMuted,
                      );
                    }
                    return MembershipCard(card: card);
                  },
                ),
                24.h,
              ],
            );
          },
        );
      },
    );
  }
}
