import '/core/feedback/masir_feedback.dart';
import 'package:flutter/material.dart';

import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';
import '/core/theme/masir_style.dart';

class MasirBottomBarItem {
  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool hidden;

  const MasirBottomBarItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.hidden = false,
  });
}

/// Flat bar with a 2px top border, a tinted pill behind the selected tab and
/// a small bounce on select. Uses whatever primary colour is in scope, so
/// inside an institute it automatically turns into the institute's colour.
class MasirBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<MasirBottomBarItem> items;

  const MasirBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final visible = items.where((e) => !e.hidden).toList();
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              for (final item in visible)
                Expanded(
                  child: _Tab(
                    item: item,
                    selected: currentIndex == item.index,
                    onTap: () => onTap(item.index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final MasirBottomBarItem item;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.primary : c.inkMuted;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!selected) MasirFeedback.select();
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: selected ? 1.0 : 0.92,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? c.primaryTint : Colors.transparent,
                borderRadius: BorderRadius.circular(MasirRadius.row),
              ),
              child: Icon(
                selected ? item.selectedIcon : item.icon,
                size: 26,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          CustomText(
            item.label,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }
}

List<MasirBottomBarItem> masirGlobalTabs() => const [
  MasirBottomBarItem(
    index: 2,
    label: 'ویترین',
    icon: Icons.storefront_outlined,
    selectedIcon: Icons.storefront_rounded,
  ),
  MasirBottomBarItem(
    index: 1,
    label: 'مؤسسات من',
    icon: Icons.school_rounded,
    selectedIcon: Icons.school_rounded,
  ),
  MasirBottomBarItem(
    index: 0,
    label: 'پروفایل',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];

List<MasirBottomBarItem> masirInstituteTabs() => const [
  MasirBottomBarItem(
    index: 0,
    label: 'خانه',
    icon: Icons.home_rounded,
    selectedIcon: Icons.home_rounded,
  ),
  MasirBottomBarItem(
    index: 1,
    label: 'دوره‌ها',
    icon: Icons.menu_book_rounded,
    selectedIcon: Icons.menu_book_rounded,
  ),
  MasirBottomBarItem(
    index: 2,
    label: 'اساتید',
    icon: Icons.groups_rounded,
    selectedIcon: Icons.groups_rounded,
  ),
  MasirBottomBarItem(
    index: 3,
    label: 'من',
    icon: Icons.emoji_events_rounded,
    selectedIcon: Icons.emoji_events_rounded,
  ),
];
