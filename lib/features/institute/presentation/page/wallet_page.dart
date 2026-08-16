import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/service_locator.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/institute/presentation/widgets/membership_card.dart';
import '/widgets/custom_error.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.appSize.width.w,
          60.h,
          const CustomText('مؤسسات من', fontWeight: FontWeight.bold, fontSize: 20),
          8.h,
          const CustomText('کارت‌های عضویت شما'),
          20.h,
          Expanded(
            child: BlocBuilder<WalletBloc, WalletState>(
              bloc: bloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => const SkeletonList(itemHeight: 220),
                  error: (_, message) => CustomError(
                    message: message,
                    retry: () => bloc.add(const WalletEvent.wallet()),
                  ),
                  success: (_, data) {
                    if (data.isEmpty) {
                      return const EmptyWidget(
                        text: 'مؤسسه‌ای ندارید',
                        description: 'از خانه یک مؤسسه پیدا کنید و عضو شوید.',
                        icon: Icons.school_outlined,
                      );
                    }
                    return ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, _) => 12.h,
                      itemBuilder: (context, index) {
                        final card = data[index];
                        return MembershipCard(
                          card: card,
                          onTap: () {
                            if (card.instituteId != null) {
                              CustomNavigator.pushNamed(
                                '/i/${card.instituteId}/home',
                              );
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
      ),
    );
  }
}
