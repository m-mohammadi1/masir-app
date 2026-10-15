import 'dart:async';

import 'package:flutter/material.dart';

import 'brand.dart';
import 'components.dart';
import 'icons.dart';
import 'tokens.dart';

enum ToastTone { success, info, error }

/// One toast at a time, top of the screen, 3 seconds (errors stay until
/// closed). A newer toast replaces the previous one.
class Toast {
  Toast._();

  static OverlayEntry? _current;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String title,
    String? body,
    ToastTone tone = ToastTone.success,
    String? action,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    hide();
    final entry = OverlayEntry(
      builder: (ctx) => _ToastView(
        title: title,
        body: body,
        tone: tone,
        action: action,
        onAction: () {
          hide();
          onAction?.call();
        },
        onClose: hide,
      ),
    );
    _current = entry;
    overlay.insert(entry);
    if (tone != ToastTone.error || action == null) {
      _timer = Timer(duration, hide);
    }
  }

  static void hide() {
    _timer?.cancel();
    _timer = null;
    _current?.remove();
    _current = null;
  }
}

class _ToastView extends StatefulWidget {
  final String title;
  final String? body;
  final ToastTone tone;
  final String? action;
  final VoidCallback onAction;
  final VoidCallback onClose;

  const _ToastView({required this.title, this.body, required this.tone, this.action, required this.onAction, required this.onClose});

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 260))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (Color badge, Widget mark) = switch (widget.tone) {
      ToastTone.success => (C.green, const MIcon(MI.check, size: 18, color: Colors.white, strokeWidth: 3.4)),
      ToastTone.info => (C.violet, Text('i', style: T.of(16, FontWeight.w900, Colors.white))),
      ToastTone.error => (C.coral, Text('!', style: T.of(16, FontWeight.w900, Colors.white))),
    };
    final reduced = Motion.reduced(context);
    final anim = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 12,
      left: 16,
      right: 16,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: Offset(0, reduced ? 0 : -0.4), end: Offset.zero).animate(anim),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: widget.action == null ? widget.onClose : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: C.toast,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [lip(C.darkLip)],
                  ),
                  child: Row(children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: badge, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: mark,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Semantics(
                        liveRegion: true,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                          Text(widget.title, style: T.of(15, FontWeight.w800, Colors.white, 1.5)),
                          if (widget.body != null) Text(widget.body!, style: T.of(13, FontWeight.w500, C.toastMuted, 1.5)),
                        ]),
                      ),
                    ),
                    if (widget.action != null)
                      TextButton(
                        onPressed: widget.onAction,
                        style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                        child: Text(widget.action!, style: T.of(14, FontWeight.w800, Colors.white)),
                      ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A section that failed to load: only that section shows the error.
class InlineError extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onRetry;

  const InlineError({
    super.key,
    this.title = 'بارگذاری نشد',
    this.body = 'بقیه‌ی صفحه سالمه؛ فقط این بخش رو دوباره بگیر.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: C.surface,
      border: Border.all(color: C.coralBorder, width: 2),
      borderRadius: BorderRadius.circular(R.card),
    ),
    child: Semantics(
      liveRegion: true,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: const Color(0xFFFFE9EA), borderRadius: BorderRadius.circular(16)),
          alignment: Alignment.center,
          child: Text('!', style: T.of(22, FontWeight.w900, C.coralDark)),
        ),
        const SizedBox(height: 10),
        Text(title, textAlign: TextAlign.center, style: T.of(16, FontWeight.w800)),
        const SizedBox(height: 4),
        Text(body, textAlign: TextAlign.center, style: T.of(14, FontWeight.w500, C.muted)),
        if (onRetry != null) ...[
          const SizedBox(height: 12),
          Btn.secondary('دوباره امتحان کن', onPressed: onRetry, expand: false, height: 49, fontSize: 15),
        ],
      ]),
    ),
  );
}

/// Yellow notice row ("فیلترشکن روشنه؛ ...") with an optional close.
class NoticeBar extends StatelessWidget {
  final String text;
  final MI icon;
  final VoidCallback? onClose;
  final Widget? trailing;
  final Color bg;
  final Color border;
  final Color fg;

  const NoticeBar(this.text, {super.key, this.icon = MI.warning, this.onClose, this.trailing,
      this.bg = C.sunSoft, this.border = C.sunBorder, this.fg = C.sunText});

  const NoticeBar.error(this.text, {super.key, this.icon = MI.alert, this.onClose, this.trailing})
      : bg = C.coralSoft, border = C.coralBorder, fg = C.coralText;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(color: bg, border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(16)),
    child: Row(children: [
      MIcon(icon, color: fg, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: T.of(14, FontWeight.w700, fg, 1.6))),
      ?trailing,
      if (onClose != null)
        IconButton(
          onPressed: onClose,
          tooltip: 'بستن',
          icon: MIcon(MI.close, size: 18, color: fg),
        ),
    ]),
  );
}

/// Confirm sheet ("می‌خوای خارج شی؟"): a primary keep button and an outlined
/// destructive one. Returns true when the destructive action is chosen.
Future<bool> confirmSheet(
  BuildContext context, {
  required String title,
  required String body,
  required String keep,
  required String leave,
  bool danger = true,
}) async {
  final result = await showMasirSheet<bool>(
    context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title, style: T.of(19, FontWeight.w800)),
        const SizedBox(height: 10),
        Text(body, style: T.of(15, FontWeight.w500, C.body, 1.9)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Btn(keep, height: 54, fontSize: 16, onPressed: () => Navigator.pop(ctx, false))),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedDanger(leave, danger: danger, onPressed: () => Navigator.pop(ctx, true)),
          ),
        ]),
      ]),
    ),
  );
  return result == true;
}

class OutlinedDanger extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool danger;
  const OutlinedDanger(this.label, {super.key, required this.onPressed, this.danger = true});

  @override
  Widget build(BuildContext context) => Lip(
    onTap: onPressed,
    border: danger ? C.coralBorder : C.border,
    lipColor: null,
    radius: 14,
    child: SizedBox(
      height: 50,
      child: Center(child: Text(label, style: T.of(16, FontWeight.w800, danger ? C.coralText : C.ink))),
    ),
  );
}

/// Centered empty state with an illustration tile, title, text and an action.
class EmptyState extends StatelessWidget {
  final MI icon;
  final String title;
  final String body;
  final String? action;
  final VoidCallback? onAction;

  const EmptyState({super.key, required this.icon, required this.title, required this.body, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(color: context.pal.soft, borderRadius: BorderRadius.circular(36)),
        alignment: Alignment.center,
        child: MIcon(icon, size: 56, color: context.pal.p, strokeWidth: 1.8),
      ),
      const SizedBox(height: 18),
      Text(title, textAlign: TextAlign.center, style: T.of(20, FontWeight.w800)),
      const SizedBox(height: 8),
      Text(body, textAlign: TextAlign.center, style: T.of(15, FontWeight.w500, C.body, 1.9)),
      if (action != null) ...[
        const SizedBox(height: 18),
        Btn(action!, onPressed: onAction),
      ],
    ]),
  );
}
