import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/core/theme/institute_presets.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/request_institute_id_model.dart';
import '/features/institute/domain/usecases/enter_institute.dart';
import '/features/institute/presentation/bloc/announcements/announcements_bloc.dart';
import '/features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart';
import '/features/institute/presentation/bloc/join_institute/join_institute_bloc.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/main/presentation/page/main_page.dart';
import '/widgets/custom_error.dart';
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
              if (data.id != null) {
                HiveService.setCurrentInstitute(
                  id: data.id!,
                  name: data.name,
                  slug: data.slug,
                  logoUrl: data.logoUrl,
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
          final base = Theme.of(context);
          return Theme(
            data: base.copyWith(
              extensions: [
                instituteColors(presetKey, base.brightness),
              ],
            ),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  backgroundColor: context.colors.background,
                  body: Column(
                    children: [
                      _Header(
                        instituteId: widget.instituteId,
                        state: state,
                      ),
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
                          orElse: () => widget.child,
                        ),
                      ),
                      MasirBottomBar(
                        currentIndex: _tabFor(path),
                        onTap: _onTab,
                        items: masirInstituteTabs(),
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

  const _Header({
    required this.instituteId,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(16, 48, 16, 8),
        child: SkeletonBox(height: 72, radius: 16),
      ),
      error: (_, _) => const SizedBox(height: 24),
      success: (_, data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 8),
          child: Row(
            children: [
              OnClick(
                onTap: () => CustomNavigator.go(MainPage.routeName),
                child: Icon(Icons.close, color: context.colors.ink),
              ),
              12.w,
              Hero(
                tag: 'institute-logo-$instituteId',
                child: ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: context.colors.primary,
                    child: data.logoUrl != null && data.logoUrl!.isNotEmpty
                        ? Image.network(data.logoUrl!, fit: BoxFit.cover)
                        : Icon(Icons.school, color: context.colors.onPrimary),
                  ),
                ),
              ),
              8.w,
              Expanded(
                child: CustomText(
                  data.name ?? '',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              OnClick(
                onTap: () => context.go('/i/$instituteId/inbox'),
                child: Icon(
                  Icons.notifications_none,
                  color: context.colors.ink,
                ),
              ),
              8.w,
              OnClick(
                onTap: () => CustomNavigator.go(MainPage.routeName),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: context.colors.primaryTint,
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
