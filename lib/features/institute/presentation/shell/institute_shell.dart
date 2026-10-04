import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/institute_themed.dart';
import '/widgets/masir_page.dart';
import '/core/theme/masir_style.dart';
import '/widgets/brand_media.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/request_institute_id_model.dart';
import '/features/institute/domain/usecases/enter_institute.dart';
import '/features/institute/presentation/bloc/announcements/announcements_bloc.dart';
import '/features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart';
import '/features/institute/presentation/bloc/join_institute/join_institute_bloc.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/institute_switcher_sheet.dart';
import '/features/main/presentation/page/main_page.dart';
import '/widgets/custom_error.dart';
import '/widgets/base_modal.dart';
import '/widgets/exit_modal.dart';
import '/widgets/custom_text.dart';
import '/widgets/masir_bottom_bar.dart';
import '/widgets/skeleton.dart';

class InstituteShell extends StatefulWidget {
  final String instituteId;
  final Widget child;

  const InstituteShell({
    super.key,
    required this.instituteId,
    required this.child,
  });

  @override
  State<InstituteShell> createState() => _InstituteShellState();
}

class _InstituteShellState extends State<InstituteShell> {
  late final InstituteDetailBloc _detailBloc;
  late final JoinInstituteBloc _joinBloc;
  late final WalletBloc _walletBloc;
  late final AnnouncementsBloc _announcementsBloc;
  bool _entered = false;
  bool _announcementsLoaded = false;

  @override
  void initState() {
    super.initState();
    _detailBloc = inject<InstituteDetailBloc>();
    _joinBloc = inject<JoinInstituteBloc>();
    _walletBloc = inject<WalletBloc>();
    _announcementsBloc = inject<AnnouncementsBloc>();
    _detailBloc.add(
      InstituteDetailEvent.load(
        params: RequestInstituteIdModel(id: widget.instituteId),
      ),
    );
    _walletBloc.add(const WalletEvent.wallet());
    _enterOnce();
  }

  Future<void> _enterOnce() async {
    if (_entered) return;
    _entered = true;
    await inject<EnterInstituteUseCase>()(
      params: RequestInstituteIdModel(id: widget.instituteId),
    );
  }

  @override
  void dispose() {
    _detailBloc.close();
    _joinBloc.close();
    _walletBloc.close();
    _announcementsBloc.close();
    super.dispose();
  }

  int _tabFor(String path) {
    if (path.endsWith('/courses')) return 1;
    if (path.endsWith('/teachers')) return 2;
    if (path.endsWith('/me')) return 3;
    return 0;
  }

  void _onTab(int index) {
    final id = widget.instituteId;
    switch (index) {
      case 1:
        context.go('/i/$id/courses');
      case 2:
        context.go('/i/$id/teachers');
      case 3:
        context.go('/i/$id/me');
      default:
        context.go('/i/$id/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _detailBloc),
        BlocProvider.value(value: _joinBloc),
        BlocProvider.value(value: _walletBloc),
        BlocProvider.value(value: _announcementsBloc),
      ],
      child: BlocListener<InstituteDetailBloc, InstituteDetailState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (_, data) {
              // Only a member's first institute becomes current on its own.
              // Browsing others must not change it (the switcher and joining
              // do that explicitly), or the close confirmation could never
              // tell the current institute apart.
              if (data.id != null &&
                  data.membership.isMember &&
                  !HiveService.hasCurrentInstitute) {
                HiveService.setCurrentInstitute(
                  id: data.id!,
                  name: data.name,
                  slug: data.slug,
                  logoUrl: data.logoUrl,
                  themePreset: data.themePreset,
                );
              }
              if (data.membership.isMember && !_announcementsLoaded) {
                _announcementsLoaded = true;
                _announcementsBloc.add(
                  AnnouncementsEvent.load(instituteId: widget.instituteId),
                );
              }
            },
          );
        },
        child: BlocBuilder<InstituteDetailBloc, InstituteDetailState>(
          builder: (context, state) {
            final presetKey = state.whenOrNull(
              success: (_, data) => data.themePreset,
            );
            return InstituteThemed(
              preset: presetKey ?? kDefaultPreset,
              child: Builder(
                builder: (context) {
                  final tab = _tabFor(path);
                  final scaffold = Scaffold(
                    backgroundColor: context.colors.background,
                    body: Column(
                      children: [
                        _Header(instituteId: widget.instituteId, state: state),
                        Expanded(
                          child: state.maybeWhen(
                            error: (_, message) => CustomError(
                              message: message,
                              retry: () => _detailBloc.add(
                                InstituteDetailEvent.load(
                                  params: RequestInstituteIdModel(
                                    id: widget.instituteId,
                                  ),
                                ),
                              ),
                            ),
                            orElse: () => MasirPageScope(
                              embedded: true,
                              child: widget.child,
                            ),
                          ),
                        ),
                        MasirBottomBar(
                          currentIndex: tab,
                          onTap: _onTab,
                          items: masirInstituteTabs(),
                        ),
                      ],
                    ),
                  );
                  final loaded = state.whenOrNull(success: (_, data) => data);
                  return PopScope(
                    // Inside an institute, back climbs one level at a time:
                    // other tab -> institute home -> ویترین.
                    canPop: false,
                    onPopInvokedWithResult: (didPop, _) {
                      if (didPop) return;
                      if (tab != 0) {
                        _onTab(0);
                      } else {
                        CustomNavigator.go(MainPage.routeName);
                      }
                    },
                    child: Stack(
                      children: [
                        scaffold,
                        if (loaded != null)
                          _BrandWash(
                            key: const ValueKey('brand-wash'),
                            preset: presetFor(loaded.themePreset),
                            logoUrl: loaded.logoUrl,
                            name: loaded.name ?? '',
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String instituteId;
  final InstituteDetailState state;

  const _Header({required this.instituteId, required this.state});

  /// Closing the student's current institute asks first; browsing any other
  /// institute closes straight away.
  void _close(BuildContext context) {
    if (instituteId != HiveService.currentInstituteId) {
      CustomNavigator.go(MainPage.routeName);
      return;
    }
    showCustomModal(
      context: context,
      scrollControlDisabledMaxHeightRatio: .4,
      callBack: (_) {},
      child: ExitModal(
        text: 'از این مؤسسه بیرون می‌ری؟',
        description: 'برمی‌گردی به ویترین. هر وقت خواستی دوباره وارد می‌شی.',
        deleteText: 'برو به ویترین',
        confirmColor: context.colors.primary,
        exitAction: () {
          Navigator.of(context).pop();
          CustomNavigator.go(MainPage.routeName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final top = MediaQuery.paddingOf(context).top + MasirSpace.md;
    return state.when(
      loading: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          MasirSpace.gutter,
          top,
          MasirSpace.gutter,
          MasirSpace.sm,
        ),
        child: const SkeletonBox(height: 64, radius: MasirRadius.hero),
      ),
      error: (_, _) => SizedBox(height: top),
      success: (_, data) {
        final preset = presetFor(data.themePreset);
        final on = c.onPrimary;
        return Container(
          padding: EdgeInsets.fromLTRB(
            MasirSpace.gutter,
            top,
            MasirSpace.gutter,
            MasirSpace.lg,
          ),
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(MasirRadius.sheet),
            ),
            border: Border(
              bottom: BorderSide(color: c.primaryEdge, width: Chunky.lip),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _close(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: on.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, color: on),
                ),
              ),
              12.w,
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => showInstituteSwitcher(context, replace: true),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'institute-logo-$instituteId',
                        child: InstituteLogo(
                          logoUrl: data.logoUrl,
                          name: data.name ?? '',
                          preset: preset,
                          size: 44,
                        ),
                      ),
                      8.w,
                      Flexible(
                        child: CustomText.headline(
                          data.name ?? '',
                          color: on,
                          maxLines: 1,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: on.withValues(alpha: 0.85),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push('/i/$instituteId/inbox'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: on.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications_rounded, color: on),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The threshold: the club's colour floods the screen with its logo, then
/// lifts away to reveal the branded world. Plays once per entry.
class _BrandWash extends StatelessWidget {
  final InstitutePreset preset;
  final String? logoUrl;
  final String name;

  const _BrandWash({
    super.key,
    required this.preset,
    required this.logoUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return const SizedBox.shrink();
    return Positioned.fill(
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          builder: (context, t, _) {
            if (t >= 1) return const SizedBox.shrink();
            // Hold fully covered for the first 35%, then fade out.
            final opacity = t < 0.35 ? 1.0 : 1 - ((t - 0.35) / 0.65);
            final logoScale =
                0.8 + 0.4 * Curves.easeOutBack.transform(t.clamp(0, 1));
            return Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: ColoredBox(
                color: preset.primary,
                child: Center(
                  child: Transform.scale(
                    scale: logoScale,
                    child: InstituteLogo(
                      logoUrl: logoUrl,
                      name: name,
                      preset: preset,
                      size: 96,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
