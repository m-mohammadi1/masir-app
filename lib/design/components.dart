import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'brand.dart';
import 'icons.dart';
import 'motion.dart';
import 'palettes.dart';
import 'tokens.dart';

/// Makes [child] sit on a solid lip that it presses down into: the element
/// moves down by the lip height and the lip disappears (90ms).
class Lip extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color fill;
  final Color? lipColor;
  final Color? border;
  final double radius;
  final double lipHeight;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;
  final bool selected;

  const Lip({
    super.key,
    required this.child,
    this.onTap,
    this.fill = C.surface,
    this.lipColor = C.lip,
    this.border = C.border,
    this.radius = R.card,
    this.lipHeight = 4,
    this.borderRadius,
    this.padding,
    this.semanticLabel,
    this.selected = false,
  });

  @override
  State<Lip> createState() => _LipState();
}

class _LipState extends State<Lip> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null) return;
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(widget.radius);
    final h = widget.lipColor == null ? 0.0 : widget.lipHeight;
    final pressed = _down && h > 0;
    // §8: sink onto the lip (90ms) and spring back on release (120ms).
    // Reduced motion: no movement, the lip just disappears while pressed.
    final reduced = MasirMotion.reduced(context);
    final box = AnimatedContainer(
      duration: _down ? MasirMotion.instant : MasirMotion.release,
      curve: _down ? MasirMotion.standard : MasirMotion.spring,
      transform: Matrix4.translationValues(0, pressed && !reduced ? h : 0, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.fill,
        borderRadius: br,
        border: widget.border == null
            ? null
            : Border.all(color: widget.border!, width: 2),
        boxShadow: h > 0 && !pressed ? [lip(widget.lipColor!, h)] : null,
      ),
      child: widget.child,
    );
    if (widget.onTap == null) {
      return Padding(
        padding: EdgeInsets.only(bottom: h),
        child: box,
      );
    }
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.semanticLabel,
      child: Padding(
        padding: EdgeInsets.only(bottom: h),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(true),
          onTapUp: (_) => _set(false),
          onTapCancel: () => _set(false),
          onTap: () {
            HapticFeedback.selectionClick();
            widget.onTap!();
          },
          child: box,
        ),
      ),
    );
  }
}

enum BtnKind { primary, secondary, ghost, danger, success, sun, onColor }

/// The design's buttons. Primary takes the space colour (Masir violet or the
/// institute's), secondary is white with a sand lip, ghost is text only.
class Btn extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BtnKind kind;
  final MI? icon;
  final bool loading;
  final double? height;
  final bool expand;
  final double fontSize;
  final InstitutePalette? palette;

  const Btn(
    this.label, {
    super.key,
    this.onPressed,
    this.kind = BtnKind.primary,
    this.icon,
    this.loading = false,
    this.height,
    this.expand = true,
    this.fontSize = 17,
    this.palette,
  });

  const Btn.secondary(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.height,
    this.expand = true,
    this.fontSize = 16,
    this.palette,
  }) : kind = BtnKind.secondary;

  const Btn.ghost(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.height,
    this.expand = true,
    this.fontSize = 15,
    this.palette,
  }) : kind = BtnKind.ghost;

  @override
  Widget build(BuildContext context) {
    final pal = palette ?? context.pal;
    final disabled = onPressed == null && !loading;
    Color fill, fg;
    Color? lipC, border;
    switch (kind) {
      case BtnKind.primary:
        fill = pal.p;
        fg = pal.on;
        lipC = pal.e;
      case BtnKind.secondary:
        fill = C.surface;
        fg = C.ink;
        lipC = C.lip;
        border = C.border;
      case BtnKind.ghost:
        fill = Colors.transparent;
        fg = pal.ink == masirPalette.ink ? C.violet : pal.ink;
        lipC = null;
      case BtnKind.danger:
        fill = C.coral;
        fg = Colors.white;
        lipC = C.coralDark;
      case BtnKind.success:
        fill = C.green;
        fg = Colors.white;
        lipC = C.greenDark;
      case BtnKind.sun:
        fill = C.sun;
        fg = C.sunInk;
        lipC = C.sunDark;
      case BtnKind.onColor:
        fill = Colors.white;
        fg = pal.ink;
        lipC = const Color(0x33000000);
    }
    if (disabled && kind != BtnKind.ghost) {
      fill = C.border;
      fg = C.muted;
      lipC = null;
      border = null;
    }
    final h =
        height ??
        (kind == BtnKind.secondary ? Gap.secondaryHeight : Gap.buttonHeight);
    final content = loading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.6, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                MIcon(icon!, color: fg, size: 20, strokeWidth: 2.4),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: T.of(fontSize, FontWeight.w800, fg, 1.2),
                ),
              ),
            ],
          );
    final body = SizedBox(
      height: h - (lipC == null ? 0 : 4) - (border != null ? 0 : 0),
      width: expand ? double.infinity : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Center(widthFactor: 1, child: content),
      ),
    );
    return Opacity(
      opacity: 1,
      child: Lip(
        onTap: disabled || loading ? null : onPressed,
        fill: fill,
        lipColor: lipC,
        border: border,
        radius: R.button,
        semanticLabel: label,
        child: body,
      ),
    );
  }
}

/// White card on a sand lip; tappable when [onTap] is set.
class PaperCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color fill;
  final Color border;
  final Color? lipColor;

  const PaperCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.radius = R.card,
    this.fill = C.surface,
    this.border = C.border,
    this.lipColor = C.lip,
  });

  @override
  Widget build(BuildContext context) => Lip(
    onTap: onTap,
    fill: fill,
    border: border,
    lipColor: lipColor,
    radius: radius,
    padding: padding,
    child: child,
  );
}

/// Small rounded label ("رایگان", "اشتراک فعال · ۴۵٪").
class Tag extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final Color? border;
  final double fontSize;
  final MI? icon;
  final EdgeInsetsGeometry padding;

  const Tag(
    this.text, {
    super.key,
    this.bg = C.sand,
    this.fg = C.body,
    this.border,
    this.fontSize = 12,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  });

  factory Tag.free([String text = 'رایگان']) =>
      Tag(text, bg: C.sun, fg: C.sunInk, fontSize: 11);
  factory Tag.success(String text) =>
      Tag(text, bg: C.greenSoft, fg: C.greenText);
  factory Tag.warn(String text) => Tag(text, bg: C.sunSoft, fg: C.sunText);
  factory Tag.error(String text) => Tag(text, bg: C.coralSoft, fg: C.coralText);

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      border: border == null ? null : Border.all(color: border!, width: 2),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          MIcon(icon!, size: fontSize + 3, color: fg, strokeWidth: 2.6),
          const SizedBox(width: 4),
        ],
        Text(text, style: T.of(fontSize, FontWeight.w800, fg, 1.5)),
      ],
    ),
  );
}

/// Rounded progress track.
class Track extends StatelessWidget {
  final double value;
  final Color color;
  final Color background;
  final double height;

  const Track({
    super.key,
    required this.value,
    this.color = C.green,
    this.background = C.border,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(999),
    child: SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(child: ColoredBox(color: background)),
          // Moves when the value changes (a unit done), never on first paint.
          MasirProgress(
            value: value.clamp(0, 1).toDouble(),
            from: value.clamp(0, 1).toDouble(),
            builder: (_, v) => FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: v.clamp(0, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// 44px square back button (white, border, 3px lip); the arrow points right.
class BackSquare extends StatelessWidget {
  final VoidCallback? onTap;
  final MI icon;
  final String label;
  final Color? lipColor;

  const BackSquare({
    super.key,
    this.onTap,
    this.icon = MI.back,
    this.label = 'برگشت',
    this.lipColor,
  });

  @override
  Widget build(BuildContext context) => Lip(
    onTap: onTap ?? () => Navigator.of(context).maybePop(),
    radius: R.tile,
    lipHeight: 3,
    lipColor: lipColor,
    semanticLabel: label,
    child: SizedBox.square(
      dimension: 40,
      child: Center(child: MIcon(icon, size: 22, strokeWidth: 2.4)),
    ),
  );
}

/// Round 44px icon button (close, share, more).
class RoundIcon extends StatelessWidget {
  final MI icon;
  final VoidCallback? onTap;
  final String label;
  final Color bg;
  final Color fg;
  final double size;

  const RoundIcon(
    this.icon, {
    super.key,
    this.onTap,
    required this.label,
    this.bg = C.sand,
    this.fg = C.ink,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: MIcon(icon, size: size * 0.46, color: fg, strokeWidth: 2.6),
      ),
    ),
  );
}

/// Section title with an optional «همه» link.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final String? subtitle;

  const SectionTitle(
    this.title, {
    super.key,
    this.action,
    this.onAction,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: T.of(19, FontWeight.w800)),
            if (subtitle != null) Text(subtitle!, style: T.caption()),
          ],
        ),
      ),
      if (action != null)
        GestureDetector(
          onTap: onAction,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              action!,
              style: T.of(
                14,
                FontWeight.w800,
                context.pal == masirPalette ? C.violet : context.pal.ink,
              ),
            ),
          ),
        ),
    ],
  );
}

/// Text field in the design's style: 54px, radius 16, 2px border that turns
/// the space colour on focus, coral on error, green when [valid].
class Field extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? error;
  final String? helper;
  final bool valid;
  final bool obscure;
  final TextInputType? keyboard;
  final TextDirection? direction;
  final TextAlign align;
  final double fontSize;
  final FontWeight weight;
  final double letterSpacing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? formatters;
  final int? maxLength;
  final bool autofocus;
  final TextInputAction? action;
  final double height;

  const Field({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.error,
    this.helper,
    this.valid = false,
    this.obscure = false,
    this.keyboard,
    this.direction,
    this.align = TextAlign.start,
    this.fontSize = 17,
    this.weight = FontWeight.w500,
    this.letterSpacing = 0,
    this.onChanged,
    this.onSubmitted,
    this.prefix,
    this.suffix,
    this.formatters,
    this.maxLength,
    this.autofocus = false,
    this.action,
    this.height = 58,
  });

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null && widget.error!.isNotEmpty;
    final borderColor = hasError
        ? C.coral
        : widget.valid
        ? C.green
        : _focus.hasFocus
        ? (context.pal == masirPalette ? C.violet : context.pal.p)
        : C.border;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(widget.label, style: T.of(14, FontWeight.w800)),
          const SizedBox(height: 8),
        ],
        MasirShake(
          error: hasError ? widget.error : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: widget.height,
            decoration: BoxDecoration(
              color: hasError ? C.coralInputBg : C.surface,
              borderRadius: BorderRadius.circular(R.input),
              border: Border.all(color: borderColor, width: 2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                if (widget.prefix != null) ...[
                  widget.prefix!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focus,
                    obscureText: widget.obscure,
                    keyboardType: widget.keyboard,
                    textDirection: widget.direction,
                    textAlign: widget.align,
                    autofocus: widget.autofocus,
                    textInputAction: widget.action,
                    inputFormatters: widget.formatters,
                    maxLength: widget.maxLength,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    cursorColor: context.pal.p,
                    style: T
                        .of(widget.fontSize, widget.weight)
                        .copyWith(letterSpacing: widget.letterSpacing),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      counterText: '',
                      hintText: widget.hint,
                      hintStyle: T.of(
                        widget.fontSize,
                        FontWeight.w500,
                        C.disabledText,
                      ),
                    ),
                  ),
                ),
                if (widget.suffix != null) ...[
                  const SizedBox(width: 8),
                  widget.suffix!,
                ],
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            key: ValueKey(widget.error),
            tween: Tween(begin: 0, end: 1),
            duration: MasirMotion.medium,
            builder: (_, t, child) => Opacity(opacity: t, child: child),
            child: Text(
              widget.error!,
              style: T.of(13, FontWeight.w600, C.coralText),
            ),
          ),
        ] else if (widget.helper != null) ...[
          const SizedBox(height: 6),
          Text(widget.helper!, style: T.of(13, FontWeight.w500, C.muted)),
        ],
      ],
    );
  }
}

/// Bottom sheet frame: top radius 24, handle, paper background.
Future<V?> showMasirSheet<V>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool scrollable = true,
  bool dismissible = true,
}) {
  final brand = BrandScope.of(context);
  return showModalBottomSheet<V>(
    context: context,
    isScrollControlled: scrollable,
    isDismissible: dismissible,
    enableDrag: dismissible,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x802B2633),
    // §6: rises in 380ms (standard), closes in 250ms (exit); no overshoot.
    sheetAnimationStyle: MasirMotion.reduced(context)
        ? const AnimationStyle(
            duration: MasirMotion.quick,
            reverseDuration: MasirMotion.quick,
          )
        : const AnimationStyle(
            duration: Duration(milliseconds: 380),
            reverseDuration: MasirMotion.back,
            curve: MasirMotion.standard,
            reverseCurve: MasirMotion.exit,
          ),
    builder: (ctx) => BrandScope(
      brand: brand,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SheetFrame(child: builder(ctx)),
      ),
    ),
  );
}

class SheetFrame extends StatelessWidget {
  final Widget child;
  final Color color;
  const SheetFrame({super.key, required this.child, this.color = C.surface});

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.92,
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(R.sheet)),
    ),
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: C.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Flexible(child: child),
        ],
      ),
    ),
  );
}

/// Grey block that pulses gently; skeletons replace spinners everywhere.
class Bone extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;
  const Bone({super.key, this.width, this.height = 14, this.radius = 8});

  @override
  State<Bone> createState() => _BoneState();
}

class _BoneState extends State<Bone> with SingleTickerProviderStateMixin {
  // §13: a gentle shimmer sweeping right to left, 1.2s, linear, looping.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = BorderRadius.circular(widget.radius);
    if (MasirMotion.reduced(context)) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(color: C.sand, borderRadius: box),
      );
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) {
        // The light band travels from the right edge to the left.
        final x = 1.6 - 3.2 * _c.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: box,
            gradient: LinearGradient(
              begin: Alignment(x - 1, 0),
              end: Alignment(x + 1, 0),
              colors: const [C.sand, C.sandLight, C.sand],
              stops: const [0.3, 0.5, 0.7],
            ),
          ),
        );
      },
    );
  }
}

/// An empty spacer that respects the RTL page gutter.
const pageGutter = EdgeInsets.symmetric(horizontal: Gap.page);

/// Divider used inside cards (2px sand).
class SandLine extends StatelessWidget {
  const SandLine({super.key});
  @override
  Widget build(BuildContext context) => Container(height: 2, color: C.sand);
}

/// Conic score ring (quiz result, kept progress).
class ScoreRing extends StatelessWidget {
  final int percent;
  final double size;
  final double stroke;
  final Color color;
  final Color track;
  final Color fill;
  final Widget? label;

  /// Fills from empty when it first shows (the quiz result).
  final bool countUp;

  const ScoreRing({
    super.key,
    required this.percent,
    this.size = 120,
    this.stroke = 14,
    this.color = C.green,
    this.track = C.border,
    this.fill = C.surface,
    this.label,
    this.countUp = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: MasirProgress(
      value: percent / 100,
      from: countUp ? 0 : percent / 100,
      builder: (_, v) => CustomPaint(
        painter: _RingPainter(v, stroke, color, track),
        child: Center(
          child: Container(
            width: size - stroke * 2,
            height: size - stroke * 2,
            decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: label,
          ),
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  final double value;
  final double stroke;
  final Color color;
  final Color track;
  _RingPainter(this.value, this.stroke, this.color, this.track);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(rect, 0, 6.2832, false, p..color = track);
    // Conic gradients start at 12 o'clock and run clockwise.
    canvas.drawArc(
      rect,
      -1.5708,
      6.2832 * value.clamp(0, 1),
      false,
      p..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color;
}

/// Like CSS `margin-top: -dy`: paints [child] [dy] higher and takes [dy] less
/// height, so a logo can overlap the photo above without leaving a gap.
class ShiftUp extends SingleChildRenderObjectWidget {
  final double dy;
  const ShiftUp({super.key, required this.dy, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => RenderShiftUp(dy);

  @override
  void updateRenderObject(BuildContext context, RenderShiftUp renderObject) =>
      renderObject.dy = dy;
}

class RenderShiftUp extends RenderProxyBox {
  double _dy;
  RenderShiftUp(this._dy);

  set dy(double v) {
    if (v == _dy) return;
    _dy = v;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    child!.layout(
      constraints.loosen().copyWith(minWidth: constraints.minWidth),
      parentUsesSize: true,
    );
    size = constraints.constrain(
      Size(
        child!.size.width,
        (child!.size.height - _dy).clamp(0, double.infinity),
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      context.paintChild(child!, offset.translate(0, -_dy));

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      result.addWithPaintOffset(
        offset: Offset(0, -_dy),
        position: position,
        hitTest: (r, p) => child!.hitTest(r, position: p),
      );

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) =>
      transform.translateByDouble(0, -_dy, 0, 1);
}

/// 44x26 switch: violet track when on, white thumb (the boards' checkbox switch).
class MSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  const MSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final on = BrandScope.paletteOf(context).p;
    return Semantics(
      toggled: value,
      label: label,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 46,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? on : C.border,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: value
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [lip(const Color(0x22000000), 1)],
            ),
          ),
        ),
      ),
    );
  }
}
