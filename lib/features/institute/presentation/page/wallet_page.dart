import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/service_locator.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/current_institute_card.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/features/main/presentation/page/institutes_page.dart';
import '/core/services/hive_service.dart';
import '/widgets/icon_tile.dart';
import '/widgets/list_row.dart';
import '/widgets/masir_motion.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';
import '/core/theme/masir_style.dart';

/// One list, most useful first: the current institute, then institutes with
/// something to continue, then the ones not started yet. Ties keep the order
/// the server sent.
List<WalletCardModel> orderWalletCards(
  List<WalletCardModel> data,
  String? currentId,
) {
  int rank(WalletCardModel e) {
    if (currentId != null && e.instituteId == currentId) return 0;
    return e.nextAction?.courseId != null ? 1 : 2;
  }

  final indexed = [for (var i = 0; i < data.length; i++) (i, data[i])];
  indexed.sort((a, b) {
    final byRank = rank(a.$2).compareTo(rank(b.$2));
    return byRank != 0 ? byRank : a.$1.compareTo(b.$1);
  });
  return [for (final e in indexed) e.$2];
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final bloc = inject<WalletBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(const WalletEvent.wallet());
  }

  @override
  Widget build(BuildContext context) {
    return MasirPage.tab(
      title: 'مؤسسه‌های من',
      subtitle: 'هر جا عضوی، از همین‌جا ادامه بده',
      body: BlocBuilder<WalletBloc, WalletState>(
        bloc: bloc,
        builder: (context, state) {
          return state.when(
            loading: (_) => const StateView.loading(
              variant: SkeletonVariant.cards,
              count: 2,
            ),
            error: (_, message) => StateView.error(
              message: message,
              retry: () => bloc.add(const WalletEvent.wallet()),
            ),
            success: (_, data) {
              if (data.isEmpty) {
                return StateView.empty(
                  text: 'هنوز عضو جایی نیستی',
                  description: 'یه مؤسسه پیدا کن و با یه لمس عضو شو.',
                  icon: Icons.school_rounded,
                  actionLabel: 'پیدا کردن مؤسسه',
                  onAction: () =>
                      CustomNavigator.pushNamed(InstitutesPage.routeName),
                );
              }
              final currentId = CurrentInstituteCard.resolve(
                data,
                HiveService.currentInstituteId,
              )?.instituteId;
              return _CardList(
                cards: orderWalletCards(data, currentId),
                currentId: currentId,
                onRefresh: () async => bloc.add(const WalletEvent.wallet()),
              );
            },
          );
        },
      ),
    );
  }
}

class _CardList extends StatelessWidget {
  final List<WalletCardModel> cards;
  final String? currentId;
  final Future<void> Function() onRefresh;

  const _CardList({
    required this.cards,
    required this.currentId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Only worth a badge when there is more than one to tell apart.
    final showBadge = cards.length > 1;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: MasirSpace.xl),
        itemCount: cards.length + 1,
        separatorBuilder: (_, _) => MasirSpace.lg.h,
        itemBuilder: (context, index) {
          if (index == cards.length) {
            return MasirEntrance(
              index: index,
              child: ListRow(
                leading: const IconTile(
                  Icons.add_rounded,
                  tone: IconTileTone.sun,
                ),
                title: 'پیدا کردن مؤسسه‌ی تازه',
                subtitle: 'با کد دعوت یا از ویترین',
                onTap: () =>
                    CustomNavigator.pushNamed(InstitutesPage.routeName),
              ),
            );
          }
          final card = cards[index];
          return MasirEntrance(
            index: index,
            child: MembershipCard(
              card: card,
              badge: showBadge && card.instituteId == currentId
                  ? 'مؤسسه‌ی فعلی'
                  : null,
              onTap: () {
                if (card.instituteId != null) {
                  CustomNavigator.pushNamed('/i/${card.instituteId}/home');
                }
              },
            ),
          );
        },
      ),
    );
  }
}
