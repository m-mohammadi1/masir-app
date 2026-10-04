import '/widgets/masir_motion.dart';
import 'dart:math' as math;

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/helper/go_back.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/back_button.dart';
import '/widgets/custom_text.dart';
import '/widgets/progress_pill.dart';

/// Tells a [MasirPage] that it is embedded in a parent that already covers
/// the status bar and the bottom inset (the institute shell's header and
/// tab bar), so the page must not add safe-area padding of its own.
class MasirPageScope extends InheritedWidget {
  final bool embedded;

  const MasirPageScope({
    super.key,
    required this.embedded,
    required super.child,
  });

  static bool embeddedOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MasirPageScope>()?.embedded ??
      false;

  @override
  bool updateShouldNotify(MasirPageScope old) => old.embedded != embedded;
}

enum _PageKind { tab, detail, focus, plain }

/// The one page skeleton of the app. Every route uses one of three kinds:
///
/// * [MasirPage.tab]: large title (collapses on scroll), subtitle, trailing.
/// * [MasirPage.detail]: round back button, compact title, trailing.
/// * [MasirPage.focus]: close button and a progress pill (units, quiz, OTP).
///
/// Give it either [children] (rendered in a scroll view with the 20px gutter
/// and optional pull-to-refresh) or a [body] that fills the remaining space
/// and manages its own scrolling.
class MasirPage extends StatelessWidget {
  final _PageKind _kind;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget>? children;
  final Widget? body;
  final Future<void> Function()? onRefresh;

  /// Pinned above the safe area at the very bottom (e.g. a bottom bar).
  final Widget? bottomBar;

  /// Pinned, padded action area above [bottomBar] (CTA, quiz buttons).
  final Widget? stickyBottom;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final num? progress;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final ScrollController? controller;

  /// Extra bottom padding for [children].
  final double bottomPadding;

  /// When true, [children] get no horizontal padding, so full-bleed rows
  /// (carousels) can scroll edge to edge. They must then use
  /// [MasirSpace.gutter] themselves.
  final bool bleed;

  const MasirPage._(
    this._kind, {
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.children,
    this.body,
    this.onRefresh,
    this.bottomBar,
    this.stickyBottom,
    this.onBack,
    this.onClose,
    this.progress,
    this.backgroundColor,
    this.floatingActionButton,
    this.controller,
    this.bottomPadding = MasirSpace.xl,
    this.bleed = false,
  }) : assert(children != null || body != null);

  const MasirPage.tab({
    Key? key,
    required String title,
    String? subtitle,
    Widget? trailing,
    List<Widget>? children,
    Widget? body,
    Future<void> Function()? onRefresh,
    Widget? stickyBottom,
    Color? backgroundColor,
    ScrollController? controller,
    bool bleed = false,
  }) : this._(
         _PageKind.tab,
         key: key,
         title: title,
         subtitle: subtitle,
         trailing: trailing,
         children: children,
         body: body,
         onRefresh: onRefresh,
         stickyBottom: stickyBottom,
         backgroundColor: backgroundColor,
         controller: controller,
         bleed: bleed,
       );

  const MasirPage.detail({
    Key? key,
    required String title,
    Widget? trailing,
    List<Widget>? children,
    Widget? body,
    Future<void> Function()? onRefresh,
    VoidCallback? onBack,
    Widget? bottomBar,
    Widget? stickyBottom,
    Color? backgroundColor,
    Widget? floatingActionButton,
    ScrollController? controller,
    double bottomPadding = MasirSpace.xl,
    bool bleed = false,
  }) : this._(
         _PageKind.detail,
         key: key,
         title: title,
         trailing: trailing,
         children: children,
         body: body,
         onRefresh: onRefresh,
         onBack: onBack,
         bottomBar: bottomBar,
         stickyBottom: stickyBottom,
         backgroundColor: backgroundColor,
         floatingActionButton: floatingActionButton,
         controller: controller,
         bottomPadding: bottomPadding,
         bleed: bleed,
       );

  const MasirPage.focus({
    Key? key,
    String title = '',
    Widget? trailing,
    List<Widget>? children,
    Widget? body,
    VoidCallback? onClose,
    num? progress,
    Widget? stickyBottom,
    Color? backgroundColor,
    ScrollController? controller,
    double bottomPadding = MasirSpace.xl,
    bool bleed = false,
  }) : this._(
         _PageKind.focus,
         key: key,
         title: title,
         trailing: trailing,
         children: children,
         body: body,
         onClose: onClose,
         progress: progress,
         stickyBottom: stickyBottom,
         backgroundColor: backgroundColor,
         controller: controller,
         bottomPadding: bottomPadding,
         bleed: bleed,
       );

  /// Header-less page that still gets the safe area, gutter and keyboard
  /// handling. Used by [BaseScreen] for screens that draw their own header.
  const MasirPage.plain({
    Key? key,
    required Widget body,
    Color? backgroundColor,
    Widget? floatingActionButton,
    Widget? stickyBottom,
  }) : this._(
         _PageKind.plain,
         key: key,
         body: body,
         backgroundColor: backgroundColor,
         floatingActionButton: floatingActionButton,
         stickyBottom: stickyBottom,
       );

  bool get _isTab => _kind == _PageKind.tab;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final embedded = MasirPageScope.embeddedOf(context);

    Widget content;
    switch (_kind) {
      case _PageKind.tab:
        content = _buildTab(context);
      case _PageKind.detail:
        content = _withFixedHeader(
          context,
          MasirDetailBar(
            title: title ?? '',
            trailing: trailing,
            onBack: onBack,
          ),
        );
      case _PageKind.focus:
        content = _withFixedHeader(
          context,
          MasirFocusBar(
            title: title ?? '',
            progress: progress,
            trailing: trailing,
            onClose: onClose ?? () => goBack(context),
          ),
        );
      case _PageKind.plain:
        content = Padding(padding: MasirSpace.pageH, child: body);
    }

    final page = Scaffold(
      backgroundColor: backgroundColor ?? c.background,
      drawerScrimColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        top: !embedded,
        bottom:
            !embedded && !_isTab && bottomBar == null && stickyBottom == null,
        child: Column(
          children: [
            Expanded(child: content),
            if (stickyBottom != null) MasirStickyBar(child: stickyBottom!),
            if (bottomBar != null) bottomBar!,
            if (!_isTab && !embedded) const HandleOpenKeyBoard(),
          ],
        ),
      ),
    );
    return _isTab ? page : ClosableKeyBoard(child: page);
  }

  Widget _withFixedHeader(BuildContext context, Widget header) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            MasirSpace.gutter,
            MasirSpace.sm,
            MasirSpace.gutter,
            MasirSpace.sm,
          ),
          child: header,
        ),
        Expanded(child: _scrollBody(context)),
      ],
    );
  }

  /// Scrollable [children] (with gutter + refresh) or the raw [body].
  Widget _scrollBody(BuildContext context) {
    if (children == null) {
      return Padding(
        padding: bleed ? EdgeInsets.zero : MasirSpace.pageH,
        child: body,
      );
    }
    return _refreshable(
      context,
      ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          bleed ? 0 : MasirSpace.gutter,
          MasirSpace.sm,
          bleed ? 0 : MasirSpace.gutter,
          bottomPadding,
        ),
        children: masirStaggered(children!),
      ),
    );
  }

  Widget _refreshable(BuildContext context, Widget scrollView) {
    if (onRefresh == null) return scrollView;
    final c = context.colors;
    return RefreshIndicator(
      color: c.primary,
      backgroundColor: c.surface,
      onRefresh: onRefresh!,
      child: scrollView,
    );
  }

  Widget _buildTab(BuildContext context) {
    final c = context.colors;
    if (children == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              MasirSpace.gutter,
              MasirSpace.lg,
              MasirSpace.gutter,
              MasirSpace.lg,
            ),
            child: _TabTitle(
              title: title!,
              subtitle: subtitle,
              trailing: trailing,
              t: 0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: bleed ? EdgeInsets.zero : MasirSpace.pageH,
              child: body!,
            ),
          ),
        ],
      );
    }
    final hasSub = subtitle != null && subtitle!.isNotEmpty;
    final maxExtent = hasSub ? 92.0 : 68.0;
    const minExtent = 56.0;
    return _refreshable(
      context,
      CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabHeaderDelegate(
              title: title!,
              subtitle: subtitle,
              trailing: trailing,
              maxH: maxExtent,
              minH: minExtent,
              background: backgroundColor ?? c.background,
              border: c.border,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              bleed ? 0 : MasirSpace.gutter,
              MasirSpace.sm,
              bleed ? 0 : MasirSpace.gutter,
              bottomPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(masirStaggered(children!)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  /// 0 = large, 1 = collapsed.
  final double t;

  const _TabTitle({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size =
        MasirText.displaySize -
        (MasirText.displaySize - MasirText.titleSize) * t;
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MasirText.display(c.ink).copyWith(fontSize: size),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Opacity(
                  opacity: (1 - t * 2).clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: MasirSpace.xs),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MasirText.caption(c.inkMuted),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: MasirSpace.md),
          trailing!,
        ],
      ],
    );
  }
}

class _TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final double maxH;
  final double minH;
  final Color background;
  final Color border;

  _TabHeaderDelegate({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.maxH,
    required this.minH,
    required this.background,
    required this.border,
  });

  @override
  double get maxExtent => maxH;

  @override
  double get minExtent => minH;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final t = (shrinkOffset / math.max(1, maxH - minH)).clamp(0.0, 1.0);
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(horizontal: MasirSpace.gutter),
      decoration: BoxDecoration(
        color: background,
        border: Border(
          bottom: BorderSide(
            color: t >= 1 ? border : Colors.transparent,
            width: Chunky.border,
          ),
        ),
      ),
      child: ClipRect(
        child: _TabTitle(
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          t: t,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_TabHeaderDelegate old) =>
      old.title != title ||
      old.subtitle != subtitle ||
      old.trailing != trailing ||
      old.background != background ||
      old.border != border;
}

/// Compact header of detail pages: round back button, title, trailing slot.
class MasirDetailBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;

  const MasirDetailBar({
    super.key,
    required this.title,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          CustomBackButton(backAction: onBack),
          const SizedBox(width: MasirSpace.md),
          Expanded(child: CustomText.title(title, maxLines: 1)),
          if (trailing != null) ...[
            const SizedBox(width: MasirSpace.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Header of focus pages: close button and a progress pill. Without
/// [progress] it shows the [title] in the same row instead.
class MasirFocusBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final num? progress;
  final Widget? trailing;

  const MasirFocusBar({
    super.key,
    required this.title,
    required this.onClose,
    this.progress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 44,
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.border, width: Chunky.border),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: c.inkMuted,
                    size: MasirIconSize.md,
                  ),
                ),
              ),
              const SizedBox(width: MasirSpace.md),
              Expanded(
                child: progress != null
                    ? ProgressPill(value: progress!, height: 14, color: c.green)
                    : CustomText.title(title, maxLines: 1),
              ),
              if (trailing != null) ...[
                const SizedBox(width: MasirSpace.md),
                trailing!,
              ],
            ],
          ),
        ),
        if (progress != null && title.isNotEmpty) ...[
          const SizedBox(height: MasirSpace.md),
          CustomText.title(title, maxLines: 2),
        ],
      ],
    );
  }
}

/// Pinned action area (CTA, quiz buttons) lifted above content by a top
/// border, with the gutter and safe-area bottom padding built in.
class MasirStickyBar extends StatelessWidget {
  final Widget child;

  const MasirStickyBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        MasirSpace.gutter,
        MasirSpace.md,
        MasirSpace.gutter,
        MasirSpace.md,
      ),
      decoration: BoxDecoration(
        color: c.background,
        border: Border(
          top: BorderSide(color: c.border, width: Chunky.border),
        ),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
