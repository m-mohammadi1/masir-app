import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

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
            child: SkeletonBox(height: 220, radius: 16),
          ),
          error: (_, _) => const SizedBox.shrink(),
          success: (_, data) {
            if (data.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: EmptyWidget(
                  text: 'مؤسسه‌ای ندارید',
                  description: 'از فهرست زیر یک مؤسسه را ببینید و عضو شوید.',
                  icon: Icons.school_outlined,
                ),
              );
            }
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
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: data.length,
                separatorBuilder: (_, _) => 12.w,
                itemBuilder: (context, index) {
                  final card = data[index];
                  return SizedBox(
                    width: context.appSize.width * 0.78,
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
