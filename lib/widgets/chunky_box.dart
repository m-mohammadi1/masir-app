import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';

/// The signature tactile surface of the playful design system.
///
/// A coloured [edge] layer sits under a [fill] face. At rest the face floats
/// [Chunky.lip] px above the edge; on press it sinks down onto it. Total
/// height never changes, so nothing around it jumps.
class ChunkyBox extends StatefulWidget {
  final Widget child;
  final Color fill;
  final Color edge;

  /// Optional 2px outline on the face (used by neutral cards).
  final Color? borderColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final bool clip;

  const ChunkyBox({
    super.key,
    required this.child,
    required this.fill,
    required this.edge,
    this.borderColor,
    this.radius = MasirRadius.card,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.width,
    this.height,
    this.alignment,
    this.clip = true,
  });

  @override
  State<ChunkyBox> createState() => _ChunkyBoxState();
}

class _ChunkyBoxState extends State<ChunkyBox> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed == v || widget.onTap == null) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    const lip = Chunky.lip;
    final faceRadius = BorderRadius.circular(widget.radius);
    final face = Container(
      alignment: widget.alignment,
      padding: widget.padding,
      clipBehavior: widget.clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: widget.fill,
        borderRadius: faceRadius,
        border: widget.borderColor == null
            ? null
            : Border.all(color: widget.borderColor!, width: Chunky.border),
      ),
      child: widget.child,
    );

    Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.edge,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          top: _pressed ? lip : 0,
          bottom: _pressed ? 0 : lip,
        ),
        child: face,
      ),
    );

    if (widget.width != null || widget.height != null) {
      box = SizedBox(width: widget.width, height: widget.height, child: box);
    }

    if (widget.onTap == null) return box;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: box,
    );
  }
}
