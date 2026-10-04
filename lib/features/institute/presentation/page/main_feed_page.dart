import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/discovery/presentation/bloc/main_feed/main_feed_bloc.dart';
import '/features/discovery/presentation/widgets/section_renderer.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/continue_hero.dart';
import '/features/institute/presentation/widgets/membership_card_strip.dart';
import '/widgets/custom_error.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_widget.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key});

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  final walletBloc = inject<WalletBloc>();
  final feedBloc = inject<MainFeedBloc>();

  @override
  void initState() {
    super.initState();
    walletBloc.add(const WalletEvent.wallet());
    feedBloc.add(const MainFeedEvent.load());
  }

  Future<void> _refresh() async {
    walletBloc.add(const WalletEvent.wallet());
    feedBloc.add(const MainFeedEvent.load());
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  String? get _name {
    final name = HiveService.user?.name?.trim();
    return (name != null && name.isNotEmpty) ? name : null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return RefreshIndicator(
      color: c.primary,
      backgroundColor: c.surface,
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          56.h,
          _Header(name: _name),
          20.h,
          ContinueHero(bloc: walletBloc),
          MembershipCardStrip(
            bloc: walletBloc,
            onTap: (card) {
              if (card.instituteId != null) {
                CustomNavigator.pushNamed('/i/${card.instituteId}/home');
              }
            },
          ),
          28.h,
          BlocBuilder<MainFeedBloc, MainFeedState>(
            bloc: feedBloc,
            builder: (context, state) {
              return state.when(
                loading: (_) => const Column(
                  children: [
                    SectionSkeleton(hero: true),
                    SizedBox(height: 32),
                    SectionSkeleton(),
                  ],
                ),
                error: (_, message) => SizedBox(
                  height: 320,
                  child: CustomError(
                    message: message,
                    retry: () => feedBloc.add(const MainFeedEvent.load()),
                  ),
                ),
                success: (_, sections) {
                  if (sections.isEmpty) {
                    return const SizedBox(
                      height: 320,
                      child: EmptyWidget(
                        text: 'هنوز چیزی اینجا نیست',
                        description:
                            'وقتی مؤسسات و دوره‌های خوب آماده شوند، اینجا می‌آیند.',
                        icon: Icons.auto_stories_rounded,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < sections.length; i++) ...[
                        if (i > 0) 32.h,
                        SectionRenderer(section: sections[i]),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? name;
  const _Header({this.name});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  name == null ? 'سلام!' : 'سلام $name',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.inkMuted,
                  maxLines: 1,
                ),
                2.h,
                const CustomText(
                  'امروز چی یاد می‌گیری؟',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
          ),
          12.w,
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.primaryTint,
              shape: BoxShape.circle,
              border: Border.all(color: c.primary, width: 2),
            ),
            child: CustomText(
              (name != null && name!.isNotEmpty) ? name!.characters.first : 'م',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: c.primary,
            ),
          ),
        ],
      ),
    );
  }
}
