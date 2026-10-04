import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/widgets/custom_error.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

/// Skeleton shapes that match the real content they stand in for.
enum SkeletonVariant { list, cards, grid, detail }

/// Loading, empty and error in one widget, so every screen shows the same
/// states. Skeletons carry no horizontal padding: the page gutter applies.
class StateView extends StatelessWidget {
  final _StateKind _kind;
  final SkeletonVariant variant;
  final int count;
  final String? text;
  final String? description;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? message;
  final VoidCallback? retry;

  const StateView.loading({
    super.key,
    this.variant = SkeletonVariant.list,
    this.count = 5,
  }) : _kind = _StateKind.loading,
       text = null,
       description = null,
       icon = null,
       actionLabel = null,
       onAction = null,
       message = null,
       retry = null;

  const StateView.empty({
    super.key,
    required String this.text,
    required String this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
  }) : _kind = _StateKind.empty,
       variant = SkeletonVariant.list,
       count = 0,
       message = null,
       retry = null;

  const StateView.error({super.key, required String this.message, this.retry})
    : _kind = _StateKind.error,
      variant = SkeletonVariant.list,
      count = 0,
      text = null,
      description = null,
      icon = null,
      actionLabel = null,
      onAction = null;

  @override
  Widget build(BuildContext context) {
    switch (_kind) {
      case _StateKind.empty:
        return EmptyWidget(
          text: text!,
          description: description!,
          icon: icon ?? Icons.inbox_rounded,
          actionLabel: actionLabel,
          onAction: onAction,
        );
      case _StateKind.error:
        return CustomError(message: message!, retry: retry);
      case _StateKind.loading:
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: MasirSpace.sm),
          child: switch (variant) {
            SkeletonVariant.list => _ListSkeleton(count: count),
            SkeletonVariant.cards => _CardsSkeleton(count: count.clamp(1, 3)),
            SkeletonVariant.grid => _GridSkeleton(count: count.clamp(2, 6)),
            SkeletonVariant.detail => const _DetailSkeleton(),
          },
        );
    }
  }
}

enum _StateKind { loading, empty, error }

class _ListSkeleton extends StatelessWidget {
  final int count;
  const _ListSkeleton({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(height: MasirSpace.md),
          const Row(
            children: [
              SkeletonBox(width: 48, height: 48, radius: MasirRadius.chip),
              SizedBox(width: MasirSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 14, radius: MasirRadius.chip),
                    SizedBox(height: MasirSpace.sm),
                    SkeletonBox(
                      width: 140,
                      height: 12,
                      radius: MasirRadius.chip,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CardsSkeleton extends StatelessWidget {
  final int count;
  const _CardsSkeleton({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(height: MasirSpace.lg),
          const SkeletonBox(height: 180, radius: MasirRadius.card),
        ],
      ],
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  final int count;
  const _GridSkeleton({required this.count});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MasirSpace.md,
      runSpacing: MasirSpace.md,
      children: [
        for (var i = 0; i < count; i++)
          LayoutBuilder(
            builder: (context, _) {
              final w =
                  (MediaQuery.sizeOf(context).width -
                      MasirSpace.gutter * 2 -
                      MasirSpace.md) /
                  2;
              return SkeletonBox(
                width: w,
                height: 150,
                radius: MasirRadius.card,
              );
            },
          ),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(height: 180, radius: MasirRadius.hero),
        SizedBox(height: MasirSpace.lg),
        SkeletonBox(width: 220, height: 22, radius: MasirRadius.chip),
        SizedBox(height: MasirSpace.md),
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 76, radius: MasirRadius.row)),
            SizedBox(width: MasirSpace.md),
            Expanded(child: SkeletonBox(height: 76, radius: MasirRadius.row)),
            SizedBox(width: MasirSpace.md),
            Expanded(child: SkeletonBox(height: 76, radius: MasirRadius.row)),
          ],
        ),
        SizedBox(height: MasirSpace.lg),
        SkeletonBox(height: 14, radius: MasirRadius.chip),
        SizedBox(height: MasirSpace.sm),
        SkeletonBox(height: 14, radius: MasirRadius.chip),
        SizedBox(height: MasirSpace.sm),
        SkeletonBox(width: 180, height: 14, radius: MasirRadius.chip),
      ],
    );
  }
}
