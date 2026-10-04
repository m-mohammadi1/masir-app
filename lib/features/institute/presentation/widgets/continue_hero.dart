import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/institute_presets.dart';
import '/features/institute/data/models/wallet_card_model.dart';
import '/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import '/features/main/presentation/page/outline_page.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/progress_pill.dart';

/// The one thing to do next: a large card in the institute's colour that
/// jumps straight into the student's current course.
class ContinueHero extends StatelessWidget {
  final WalletBloc bloc;

  const ContinueHero({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      bloc: bloc,
      builder: (context, state) {
        final card = state.whenOrNull(
          success: (_, data) {
            for (final item in data) {
              if (item.nextAction?.courseId != null) return item;
            }
            return null;
          },
        );
        if (card == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: _Hero(card: card),
        );
      },
    );
  }
}

class _Hero extends StatelessWidget {
  final WalletCardModel card;
  const _Hero({required this.card});

  @override
  Widget build(BuildContext context) {
    final preset = presetFor(card.themePreset);
    final action = card.nextAction!;
    final on = preset.onPrimary;
    return ChunkyBox(
      fill: preset.primary,
      edge: preset.edge,
      radius: 24,
      padding: const EdgeInsets.all(16),
      onTap: () => _open(action.courseId!, action.courseTitle ?? ''),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InstituteLogo(
                logoUrl: card.logoUrl,
                name: card.name ?? '',
                preset: preset,
                size: 32,
                ring: false,
              ),
              8.w,
              Expanded(
                child: CustomText(
                  card.name ?? '',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: on.withValues(alpha: 0.9),
                  maxLines: 1,
                ),
              ),
              CustomText(
                formatProgressPercent(action.progressPercent),
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: on,
              ),
            ],
          ),
          12.h,
          CustomText(
            action.unitTitle ?? action.courseTitle ?? 'ادامه یادگیری',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: on,
            maxLines: 2,
          ),
          if (action.moduleTitle != null) ...[
            2.h,
            CustomText(
              action.moduleTitle!,
              fontSize: 13,
              color: on.withValues(alpha: 0.8),
              maxLines: 1,
            ),
          ],
          14.h,
          ProgressPill(
            value: action.progressPercent,
            height: 10,
            color: on,
            trackColor: on.withValues(alpha: 0.3),
          ),
          16.h,
          Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: on,
              borderRadius: BorderRadius.circular(14),
            ),
            child: CustomText(
              'ادامه یادگیری',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: preset.edge,
            ),
          ),
        ],
      ),
    );
  }

  void _open(String courseId, String title) {
    CustomNavigator.pushNamed(
      OutlinePage.routeName,
      arguments: {'id': courseId, 'title': title},
    );
  }
}