import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card_strip.dart';
import '/features/main/data/models/institutes_model.dart';
import '/features/main/presentation/bloc/institutes/institutes_bloc.dart';
import '/widgets/custom_error.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key});

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  final walletBloc = inject<WalletBloc>();
  final institutesBloc = inject<InstitutesBloc>();

  @override
  void initState() {
    super.initState();
    walletBloc.add(const WalletEvent.wallet());
    institutesBloc.add(const InstitutesEvent.institutes());
  }

  void _openInstitute(String id) {
    CustomNavigator.pushNamed('/i/$id/home');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.appSize.width.w,
        48.h,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomText('خانه', fontWeight: FontWeight.bold, fontSize: 20),
        ),
        12.h,
        MembershipCardStrip(
          bloc: walletBloc,
          onTap: (card) {
            if (card.instituteId != null) _openInstitute(card.instituteId!);
          },
        ),
        20.h,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomText(
            'مؤسسه‌های دیگر',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        8.h,
        Expanded(
          child: BlocBuilder<InstitutesBloc, InstitutesState>(
            bloc: institutesBloc,
            builder: (context, state) {
              return state.when(
                loading: (_) => const SkeletonList(),
                error: (_, message) => CustomError(
                  message: message,
                  retry: () =>
                      institutesBloc.add(const InstitutesEvent.institutes()),
                ),
                success: (_, data) {
                  if (data.isEmpty) {
                    return const EmptyWidget(
                      text: 'مؤسسه‌ای یافت نشد',
                      description: 'در حال حاضر مؤسسه جدیدی برای عضویت نیست.',
                      icon: Icons.school_outlined,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.length,
                    separatorBuilder: (_, _) => 12.h,
                    itemBuilder: (context, index) {
                      final institute = data[index];
                      return _BrowseTile(
                        institute: institute,
                        onTap: () {
                          if (institute.id != null) {
                            _openInstitute(institute.id!);
                          }
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BrowseTile extends StatelessWidget {
  final InstitutesModel institute;
  final VoidCallback onTap;

  const _BrowseTile({required this.institute, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 48,
                height: 48,
                color: context.colors.borderF9,
                child: institute.logoUrl != null && institute.logoUrl!.isNotEmpty
                    ? Image.network(institute.logoUrl!, fit: BoxFit.cover)
                    : Icon(Icons.school, color: context.colors.inkMuted),
              ),
            ),
            12.w,
            Expanded(
              child: CustomText(
                institute.name ?? '',
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.chevron_left),
          ],
        ),
      ),
    );
  }
}
