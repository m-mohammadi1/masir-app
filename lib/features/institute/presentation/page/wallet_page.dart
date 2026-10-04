import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/features/main/presentation/page/institutes_page.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/masir_style.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final bloc = inject<WalletBloc>();

  /// 'learning' | 'joined'
  String _segment = 'learning';

  @override
  void initState() {
    super.initState();
    bloc.add(const WalletEvent.wallet());
  }

  @override
  Widget build(BuildContext context) {
    return MasirPage.tab(
      title: 'مؤسسه‌های من',
      subtitle: 'کارت‌های عضویت تو',
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
              final learning = data
                  .where((e) => e.segment != 'joined')
                  .toList();
              final joined = data.where((e) => e.segment == 'joined').toList();
              final shown = _segment == 'learning' ? learning : joined;
              return Column(
                children: [
                  _SegmentSwitch(
                    selected: _segment,
                    learningCount: learning.length,
                    joinedCount: joined.length,
                    onChanged: (v) => setState(() => _segment = v),
                  ),
                  const SizedBox(height: MasirSpace.lg),
                  Expanded(
                    child: _CardList(cards: shown, segment: _segment),
                  ),
                ],
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
  final String segment;

  const _CardList({required this.cards, required this.segment});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return StateView.empty(
        text: segment == 'learning'
            ? 'هنوز درسی شروع نکرده‌ای'
            : 'همه‌ی مؤسساتت رو شروع کردی',
        description: segment == 'learning'
            ? 'از بخش «عضو شده» یه دوره انتخاب کن و بریم سراغش.'
            : 'دمت گرم! یه مؤسسه‌ی تازه هم پیدا کن.',
        icon: segment == 'learning'
            ? Icons.rocket_launch_rounded
            : Icons.celebration_rounded,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: MasirSpace.xl),
      itemCount: cards.length,
      separatorBuilder: (_, _) => MasirSpace.lg.h,
      itemBuilder: (context, index) {
        final card = cards[index];
        return MembershipCard(
          card: card,
          onTap: () {
            if (card.instituteId != null) {
              CustomNavigator.pushNamed('/i/${card.instituteId}/home');
            }
          },
        );
      },
    );
  }
}

class _SegmentSwitch extends StatelessWidget {
  final String selected;
  final int learningCount;
  final int joinedCount;
  final ValueChanged<String> onChanged;

  const _SegmentSwitch({
    required this.selected,
    required this.learningCount,
    required this.joinedCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget tab(String key, String label, int count) {
      final on = selected == key;
      return Expanded(
        child: ChunkyBox(
          height: 48,
          radius: MasirRadius.row,
          fill: on ? c.primary : c.surface,
          edge: on ? c.primaryEdge : c.lip,
          borderColor: on ? null : c.border,
          alignment: Alignment.center,
          onTap: () => onChanged(key),
          child: CustomText.bodyStrong(
            '$label · ${faDigits(count)}',
            color: on ? c.onPrimary : c.ink,
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('learning', 'در حال یادگیری', learningCount),
        12.w,
        tab('joined', 'عضو شده', joinedCount),
      ],
    );
  }
}
