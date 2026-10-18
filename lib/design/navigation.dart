import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'brand.dart';
import 'components.dart';
import 'icons.dart';
import 'motion.dart';
import 'tokens.dart';

enum MarkStyle { onViolet, onLight, onDark, monoWhite }

/// The «سه قدم» mark. Never mirrored: wrapped in LTR so RTL screens can't flip it.
class MasirMark extends StatelessWidget {
  final double size;
  final MarkStyle style;
  const MasirMark({super.key, this.size = 40, this.style = MarkStyle.onViolet});

  @override
  Widget build(BuildContext context) {
    final file = switch (style) {
      MarkStyle.onViolet => 'mark-color-on-violet',
      MarkStyle.onLight => 'mark-color-on-light',
      MarkStyle.onDark => 'mark-color-on-dark',
      MarkStyle.monoWhite => 'mark-mono-white',
    };
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SvgPicture.asset(
        'assets/design/logo/$file.svg',
        width: size,
        height: size,
        semanticsLabel: 'مسیر',
      ),
    );
  }
}

/// Simple small mark (under 32px): three steps, no trail, in [color].
class MasirSmallMark extends StatelessWidget {
  final double size;
  final Color color;
  const MasirSmallMark({super.key, this.size = 18, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SvgPicture.string(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="16 16 96 96"><circle cx="34" cy="94" r="16" fill="$hex"/>'
        '<circle cx="64" cy="64" r="13" fill="none" stroke="$hex" stroke-width="12"/>'
        '<circle cx="94" cy="34" r="15" fill="$hex" fill-opacity="0.38"/></svg>',
        width: size,
        height: size,
      ),
    );
  }
}

class TabItem {
  final MI icon;
  final String label;
  const TabItem(this.icon, this.label);
}

const masirTabs = [
  TabItem(MI.store, 'ویترین'),
  TabItem(MI.building, 'مؤسسات من'),
  TabItem(MI.user, 'پروفایل'),
];

const instituteTabs = [
  TabItem(MI.home, 'خانه'),
  TabItem(MI.book, 'دوره‌ها'),
  TabItem(MI.teachers, 'اساتید'),
  TabItem(MI.user, 'من'),
];

/// An independent teacher's space has no «اساتید» tab.
const soloTabs = [
  TabItem(MI.home, 'خانه'),
  TabItem(MI.book, 'دوره‌ها'),
  TabItem(MI.user, 'من'),
];

/// Bottom tab bar of a space: white, 2px sand top border, the active tab sits
/// in a soft pill of the space colour.
class SpaceTabBar extends StatelessWidget {
  final List<TabItem> items;
  final int index;
  final ValueChanged<int> onTap;

  const SpaceTabBar({
    super.key,
    required this.items,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final active = pal.ink == C.violetDark ? C.violet : pal.ink;
    final pillWidth = items.length == 3 ? 60.0 : 56.0;
    return Container(
      decoration: const BoxDecoration(
        color: C.surface,
        border: Border(top: BorderSide(color: C.border, width: 2)),
      ),
      padding: EdgeInsets.fromLTRB(
        8,
        items.length == 3 ? 10 : 8,
        8,
        8 + MediaQuery.paddingOf(context).bottom.clamp(10, 34),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == index,
                label: items[i].label,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: MasirMotion.back,
                        curve: MasirMotion.standard,
                        width: pillWidth,
                        height: 32,
                        decoration: BoxDecoration(
                          color: i == index ? pal.soft : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: MIcon(
                          items[i].icon,
                          size: 22,
                          color: i == index ? active : C.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].label,
                        style: T.of(
                          12,
                          i == index ? FontWeight.w800 : FontWeight.w700,
                          i == index ? active : C.muted,
                          1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Coloured institute header: logo + page title, and the «مسیر» pill that
/// exits back to the Masir space.
class InstituteBar extends StatelessWidget {
  final String title;
  final VoidCallback onExit;
  final VoidCallback? onSwitch;
  final Widget? trailing;

  const InstituteBar({
    super.key,
    required this.title,
    required this.onExit,
    this.onSwitch,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final pal = brand.palette;
    return Container(
      decoration: BoxDecoration(color: pal.p, boxShadow: [lip(pal.e)]),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.paddingOf(context).top + 10,
        16,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSwitch,
              behavior: HitTestBehavior.opaque,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Row(
                  children: [
                    InstituteLogo(
                      brand: brand,
                      size: 38,
                      inverted: true,
                      fontSize: 18,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: T.of(17, FontWeight.w800, pal.on),
                      ),
                    ),
                    if (onSwitch != null) ...[
                      const SizedBox(width: 4),
                      MIcon(
                        MI.chevronDown,
                        size: 18,
                        color: pal.on,
                        strokeWidth: 2.4,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          ?trailing,
          const SizedBox(width: 8),
          ExitPill(onTap: onExit),
        ],
      ),
    );
  }
}

/// «مسیر» pill: translucent white on the institute colour, white mark.
class ExitPill extends StatelessWidget {
  final VoidCallback onTap;
  const ExitPill({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final on = context.pal.on;
    return Semantics(
      button: true,
      label: 'خروج به مسیر',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: on.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MasirSmallMark(size: 18, color: on),
              const SizedBox(width: 6),
              Text('مسیر', style: T.of(14, FontWeight.w800, on)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Page header on paper: back square + title (+ subtitle) + actions.
class PaperHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final bool showBack;

  const PaperHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.onBack,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      MediaQuery.paddingOf(context).top + 10,
      16,
      10,
    ),
    child: Row(
      children: [
        if (showBack) ...[BackSquare(onTap: onBack), const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: T.of(20, FontWeight.w800),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: T.of(13, FontWeight.w600, C.muted),
                ),
            ],
          ),
        ),
        ...actions,
      ],
    ),
  );
}

/// Sand segmented control ("همه • ۳ | دوره‌های من • ۱").
class Segments extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  const Segments({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: C.sand,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Semantics(
              selected: i == index,
              button: true,
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 44,
                  decoration: BoxDecoration(
                    color: i == index ? C.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: i == index ? [lip(C.lip, 2)] : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: T.of(
                      15,
                      i == index ? FontWeight.w800 : FontWeight.w700,
                      i == index ? C.ink : C.muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

/// Horizontal chips (topics, filters).
class ChipRow extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  /// Flat tabs (announcements, answer review): soft fill and a coloured
  /// border when selected, no lip.
  final bool soft;

  const ChipRow({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.soft = false,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            if (soft)
              Semantics(
                selected: i == index,
                button: true,
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: i == index ? pal.soft : C.surface,
                      border: Border.all(
                        color: i == index ? pal.p : C.border,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        labels[i],
                        style: T.of(
                          14,
                          i == index ? FontWeight.w800 : FontWeight.w700,
                          i == index ? pal.ink : C.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Lip(
                onTap: () => onChanged(i),
                selected: i == index,
                fill: i == index ? pal.p : C.surface,
                border: i == index ? pal.p : C.border,
                lipColor: i == index ? pal.e : C.lip,
                lipHeight: 3,
                radius: 999,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  labels[i],
                  style: T.of(14, FontWeight.w800, i == index ? pal.on : C.ink),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
