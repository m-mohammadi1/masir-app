import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/theme/theme_context.dart';
import '/features/discovery/data/models/main_feed_model.dart';
import '/features/discovery/presentation/bloc/topics/topics_bloc.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/core/theme/masir_style.dart';

class TopicChipRow extends StatelessWidget {
  final TopicsBloc bloc;
  final String? selectedSlug;
  final ValueChanged<String?> onSelected;

  const TopicChipRow({
    super.key,
    required this.bloc,
    required this.selectedSlug,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicsBloc, TopicsState>(
      bloc: bloc,
      builder: (context, state) {
        return state.maybeWhen(
          success: (_, items) => SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                _Chip(
                  label: 'همه',
                  selected: selectedSlug == null,
                  onTap: () => onSelected(null),
                ),
                ...items.map(
                  (DiscoveryTopicModel topic) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: MasirSpace.sm,
                    ),
                    child: _Chip(
                      label: topic.name ?? topic.slug ?? '',
                      selected: selectedSlug == topic.slug,
                      onTap: () => onSelected(topic.slug),
                    ),
                  ),
                ),
              ],
            ),
          ),
          orElse: () => const SizedBox(height: 8),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ChunkyBox(
      radius: MasirRadius.chip,
      fill: selected ? c.primary : c.surface,
      edge: selected ? c.primaryEdge : c.lip,
      borderColor: selected ? null : c.border,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      onTap: onTap,
      child: CustomText.caption(label, color: selected ? c.onPrimary : c.ink),
    );
  }
}
