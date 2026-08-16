import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/service_locator.dart';
import '/features/discovery/presentation/bloc/main_feed/main_feed_bloc.dart';
import '/features/discovery/presentation/widgets/section_renderer.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return NonScrollableRefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          48.h,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomText('خانه', fontWeight: FontWeight.bold, fontSize: 20),
          ),
          12.h,
          MembershipCardStrip(
            bloc: walletBloc,
            onTap: (card) {
              if (card.instituteId != null) {
                CustomNavigator.pushNamed('/i/${card.instituteId}/home');
              }
            },
          ),
          12.h,
          Expanded(
            child: BlocBuilder<MainFeedBloc, MainFeedState>(
              bloc: feedBloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => ListView(
                    children: const [
                      SectionSkeleton(),
                      SizedBox(height: 24),
                      SectionSkeleton(),
                    ],
                  ),
                  error: (_, message) => CustomError(
                    message: message,
                    retry: () => feedBloc.add(const MainFeedEvent.load()),
                  ),
                  success: (_, sections) {
                    if (sections.isEmpty) {
                      return const EmptyWidget(
                        text: 'هنوز محتوایی نیست',
                        description: 'به‌زودی مؤسسات و دوره‌ها اینجا می‌آیند.',
                        icon: Icons.explore_outlined,
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: sections.length,
                      separatorBuilder: (_, _) => 20.h,
                      itemBuilder: (context, index) {
                        return SectionRenderer(section: sections[index]);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
