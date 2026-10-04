import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';

/// Empty state that always guides: icon bubble, headline, one line of help
/// and an optional call to action.
class EmptyWidget extends StatelessWidget {
  final String text;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyWidget({
    super.key,
    required this.text,
    required this.description,
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: MasirSpace.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Floating(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryTint,
                ),
                child: Icon(icon, size: 44, color: colors.primary),
              ),
            ),
            MasirSpace.xl.h,
            CustomText.headline(
              text,
              color: colors.ink,
              textAlign: TextAlign.center,
            ),
            MasirSpace.sm.h,
            CustomText.caption(
              description,
              color: colors.inkMuted,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              MasirSpace.xl.h,
              CustomButton(title: actionLabel, onTap: onAction, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bobs its child up and down very gently, so empty screens feel alive.
/// Stays still when animations are reduced.
class _Floating extends StatefulWidget {
  final Widget child;

  const _Floating({required this.child});

  @override
  State<_Floating> createState() => _FloatingState();
}

class _FloatingState extends State<_Floating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -6 * Curves.easeInOut.transform(_controller.value)),
        child: child,
      ),
    );
  }
}
