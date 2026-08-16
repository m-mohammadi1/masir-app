import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/helper/assets.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';

class MasirBottomBarItem {
  final int index;
  final String label;
  final String icon;
  final String selectedIcon;
  final bool hidden;

  const MasirBottomBarItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.hidden = false,
  });
}

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
    final visible = items.where((e) => !e.hidden).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 99,
          width: context.appSize.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            boxShadow: [
              BoxShadow(
                color: context.colors.ink.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: context.colors.border),
            color: context.colors.surface,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final item in visible)
                OnClick(
                  onTap: () => onTap(item.index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImage(
                        assets: currentIndex == item.index
                            ? item.selectedIcon
                            : item.icon,
                        width: 24,
                        color: currentIndex == item.index
                            ? context.colors.primary
                            : context.colors.secondary,
                      ),
                      2.h,
                      CustomText(
                        item.label,
                        color: currentIndex == item.index
                            ? context.colors.primary
                            : context.colors.secondary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        16.h,
      ],
    );
  }
}

List<MasirBottomBarItem> masirGlobalTabs() => [
  MasirBottomBarItem(
    index: 2,
    label: 'خانه',
    icon: Assets.home,
    selectedIcon: Assets.homeSelected,
  ),
  MasirBottomBarItem(
    index: 1,
    label: 'مؤسسات من',
    icon: Assets.home,
    selectedIcon: Assets.homeSelected,
  ),
  MasirBottomBarItem(
    index: 0,
    label: 'پروفایل',
    icon: Assets.profile,
    selectedIcon: Assets.profileSelected,
  ),
];

List<MasirBottomBarItem> masirInstituteTabs() => [
  MasirBottomBarItem(
    index: 0,
    label: 'خانه',
    icon: Assets.home,
    selectedIcon: Assets.homeSelected,
  ),
  MasirBottomBarItem(
    index: 1,
    label: 'دوره‌ها',
    icon: Assets.home,
    selectedIcon: Assets.homeSelected,
  ),
  MasirBottomBarItem(
    index: 2,
    label: 'اساتید',
    icon: Assets.profile,
    selectedIcon: Assets.profileSelected,
    hidden: true,
  ),
  MasirBottomBarItem(
    index: 3,
    label: 'من',
    icon: Assets.profile,
    selectedIcon: Assets.profileSelected,
  ),
];
