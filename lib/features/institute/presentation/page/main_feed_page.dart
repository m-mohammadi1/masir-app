import '/core/copy/masir_copy.dart';
import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/discovery/presentation/bloc/main_feed/main_feed_bloc.dart';
import '/features/discovery/presentation/widgets/section_renderer.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/current_institute_card.dart';
import '/features/institute/presentation/widgets/membership_card_strip.dart';
import '/widgets/custom_text.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';
import '/core/theme/masir_style.dart';

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
    final name = _name;
    return MasirPage.tab(
      title: 'ویترین',
      subtitle: MasirCopy.greeting(name),
      trailing: _Avatar(name: name),
      onRefresh: _refresh,
      bleed: true,
      children: [
        CurrentInstituteCard(bloc: walletBloc),
        const SizedBox(height: MasirSpace.section),
        MembershipCardStrip(
          bloc: walletBloc,
          currentInstituteId: HiveService.currentInstituteId,
          onTap: (card) {
            if (card.instituteId != null) {
              CustomNavigator.pushNamed('/i/${card.instituteId}/home');
            }
          },
        ),
        BlocBuilder<MainFeedBloc, MainFeedState>(
          bloc: feedBloc,
          builder: (context, state) {
            return state.when(
              loading: (_) => const Column(
                children: [
                  SectionSkeleton(hero: true),
                  SizedBox(height: MasirSpace.section),
                  SectionSkeleton(),
                ],
              ),
              error: (_, message) => SizedBox(
                height: 320,
                child: StateView.error(
                  message: message,
                  retry: () => feedBloc.add(const MainFeedEvent.load()),
                ),
              ),
              success: (_, sections) {
                if (sections.isEmpty) {
                  return const SizedBox(
                    height: 320,
                    child: StateView.empty(
                      text: 'هنوز چیزی اینجا نیست',
                      description:
                          'تا مؤسسه‌ها و دوره‌های خوب آماده بشن، اینجا خالیه. زود برمی‌گردیم!',
                      icon: Icons.auto_stories_rounded,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (var i = 0; i < sections.length; i++) ...[
                      if (i > 0) const SizedBox(height: MasirSpace.section),
                      SectionRenderer(section: sections[i]),
                    ],
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? name;
  const _Avatar({this.name});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasName = name != null && name!.isNotEmpty;
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.primaryTint,
        shape: BoxShape.circle,
        border: Border.all(color: c.primary, width: Chunky.border),
      ),
      child: CustomText.title(
        hasName ? name!.characters.first : 'م',
        color: c.primary,
      ),
    );
  }
}
