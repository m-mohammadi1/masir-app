import 'package:flutter/material.dart';

import '/core/feedback/masir_feedback.dart';

/// A light-weight tap target for text-style actions: it squashes a little
/// while pressed, springs back, and gives a soft haptic tap.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final bool haptic;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.95,
    this.haptic = true,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed == v || widget.onTap == null) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    Widget child = widget.child;
    if (!MediaQuery.disableAnimationsOf(context)) {
      child = AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1,
        duration: Duration(milliseconds: _pressed ? 70 : 200),
        curve: _pressed ? Curves.easeOut : Curves.easeOutBack,
        child: child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: () {
        if (widget.haptic) MasirFeedback.tap();
        widget.onTap!();
      },
      child: child,
    );
  }
}
