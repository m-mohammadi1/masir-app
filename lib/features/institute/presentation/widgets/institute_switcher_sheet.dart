import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/main/presentation/page/institutes_page.dart';
import '/widgets/brand_media.dart';
import '/widgets/custom_text.dart';
import '/widgets/icon_tile.dart';
import '/widgets/list_row.dart';
import '/widgets/masir_motion.dart';
import '/widgets/state_view.dart';

/// Opens the shared institute switcher.
///
/// Choosing an institute makes it the current one and opens its home. Pass
/// [replace] when already inside an institute, so the stack is swapped
/// instead of piled up.
Future<void> showInstituteSwitcher(
  BuildContext context, {
  bool replace = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    sheetAnimationStyle: MasirMotion.sheet,
    showDragHandle: true,
    backgroundColor: context.colors.background,
    builder: (_) => _SwitcherSheet(replace: replace),
  );
}

class _SwitcherSheet extends StatefulWidget {
  final bool replace;

  const _SwitcherSheet({required this.replace});

  @override
  State<_SwitcherSheet> createState() => _SwitcherSheetState();
}

class _SwitcherSheetState extends State<_SwitcherSheet> {
  final bloc = inject<WalletBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(const WalletEvent.wallet());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  void _choose(WalletCardModel card) {
    final id = card.instituteId;
    if (id == null || id.isEmpty) return;
    HiveService.setCurrentInstitute(
      id: id,
      name: card.name,
      slug: card.slug,
      logoUrl: card.logoUrl,
      themePreset: card.themePreset,
    );
    Navigator.of(context).pop();
    if (widget.replace) {
      CustomNavigator.go('/i/$id/home');
    } else {
      CustomNavigator.pushNamed('/i/$id/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentId = HiveService.currentInstituteId;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            MasirSpace.gutter,
            0,
            MasirSpace.gutter,
            MasirSpace.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomText.title('کجا می‌خوای بری؟'),
              const SizedBox(height: MasirSpace.md),
              Flexible(
                child: BlocBuilder<WalletBloc, WalletState>(
                  bloc: bloc,
                  builder: (context, state) {
                    return state.when(
                      loading: (_) => const SizedBox(
                        height: 220,
                        child: StateView.loading(count: 3),
                      ),
                      error: (_, message) => SizedBox(
                        height: 220,
                        child: StateView.error(
                          message: message,
                          retry: () => bloc.add(const WalletEvent.wallet()),
                        ),
                      ),
                      success: (_, cards) => ListView(
                        shrinkWrap: true,
                        children: [
                          for (final card in cards) ...[
                            ListRow(
                              leading: InstituteLogo(
                                logoUrl: card.logoUrl,
                                name: card.name ?? '',
                                preset: presetFor(card.themePreset),
                                size: 40,
                                ring: false,
                              ),
                              title: card.name ?? '',
                              subtitle: card.instituteId == currentId
                                  ? 'مؤسسه‌ی فعلی'
                                  : null,
                              highlighted: card.instituteId == currentId,
                              trailing: card.instituteId == currentId
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: context.colors.primary,
                                    )
                                  : null,
                              onTap: () => _choose(card),
                            ),
                            const SizedBox(height: MasirSpace.md),
                          ],
                          ListRow(
                            leading: const IconTile(Icons.search_rounded),
                            title: 'پیدا کردن مؤسسه‌ی جدید',
                            onTap: () {
                              Navigator.of(context).pop();
                              CustomNavigator.pushNamed(
                                InstitutesPage.routeName,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
