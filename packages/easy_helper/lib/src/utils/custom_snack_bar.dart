import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  CustomToast._();

  static Color _accent(Type t) {
    if (t == Type.success) return const Color(0XFF009966);
    if (t == Type.error) return const Color(0xffEB5757);
    return const Color(0xFF2F80ED);
  }

  static Color _soft(Type t, bool dark) {
    if (dark) return const Color(0xFF232733);
    if (t == Type.success) return const Color(0xFFE6F7EF);
    if (t == Type.error) return const Color(0xFFFDECEC);
    return const Color(0xFFEAF2FE);
  }

  static IconData _icon(Type t) {
    if (t == Type.success) return Icons.check_rounded;
    if (t == Type.error) return Icons.priority_high_rounded;
    return Icons.info_outline_rounded;
  }

  static void toast(
    BuildContext context,
    String message, {
    Type type = Type.error,
    Duration displayDuration = const Duration(milliseconds: 3200),
    VoidCallback? onTap,
    OverlayState? overlayState,
  }) async {
    if (message.isEmpty) return;
    if (type == Type.error) debugPrint("Error Toast log is: $message");

    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accent(type);

    toastification.showCustom(
      context: context,
      autoCloseDuration: displayDuration,
      alignment: Alignment.topCenter,
      dismissDirection: DismissDirection.up,
      animationDuration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 460),
      animationBuilder: (context, animation, alignment, child) {
        if (reduceMotion) return child;
        final pop = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 0.6, curve: Curves.easeOut),
            reverseCurve: Curves.easeIn,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.6),
              end: Offset.zero,
            ).animate(pop),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.88, end: 1).animate(pop),
              child: child,
            ),
          ),
        );
      },
      direction: TextDirection.ltr,
      builder: (context, holder) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            onTap: () {
              onTap?.call();
              toastification.dismissById(holder.id);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _soft(type, dark),
                borderRadius: BorderRadius.circular(20),
                // A thicker bottom edge gives the same chunky lip as buttons.
                border: Border(
                  top: BorderSide(color: accent, width: 2),
                  left: BorderSide(color: accent, width: 2),
                  right: BorderSide(color: accent, width: 2),
                  bottom: BorderSide(color: accent, width: 5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent,
                    ),
                    child: Icon(_icon(type), color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: dark
                            ? const Color(0xFFF2F3F7)
                            : const Color(0xFF252525),
                        fontFamily: "Masir",
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum Type { error, success, info }

class AnimatedLinearProgress extends StatefulWidget {
  final Color color;

  const AnimatedLinearProgress({super.key, required this.color});

  @override
  State<AnimatedLinearProgress> createState() => _AnimatedLinearProgressState();
}

class _AnimatedLinearProgressState extends State<AnimatedLinearProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return LinearProgressIndicator(
          value: _animation.value, // 0 → 1
          color: widget.color,
        );
      },
    );
  }
}
