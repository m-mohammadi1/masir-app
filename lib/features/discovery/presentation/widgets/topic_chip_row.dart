import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/theme/theme_context.dart';
import '/features/discovery/data/models/main_feed_model.dart';
import '/features/discovery/presentation/bloc/topics/topics_bloc.dart';
import '/widgets/custom_text.dart';

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
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _Chip(
                  label: 'همه',
                  selected: selectedSlug == null,
                  onTap: () => onSelected(null),
                ),
                ...items.map(
                  (DiscoveryTopicModel topic) => Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
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
    return OnClick(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : context.colors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
          ),
        ),
        child: CustomText(
          label,
          fontSize: 13,
          color: selected ? context.colors.onPrimary : context.colors.ink,
        ),
      ),
    );
  }
}
