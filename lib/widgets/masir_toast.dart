import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '/widgets/masir_notice.dart';

/// Shows a [MasirNotice] sliding down from the top. One at a time: a new
/// notice replaces the one still on screen.
class MasirToast {
  const MasirToast._();

  static const Duration normal = Duration(milliseconds: 3200);
  static const Duration celebration = Duration(milliseconds: 4500);

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    NoticeTone tone = NoticeTone.info,
    IconData? icon,
    Duration duration = normal,
    VoidCallback? onTap,
  }) {
    if (title.isEmpty) return;
    if (tone == NoticeTone.error) debugPrint('Error Toast log is: $title');

    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    // The overlay sits above the page, so carry the caller's theme (and with
    // it the institute colours) into the notice.
    final theme = Theme.of(context);

    toastification.dismissAll(delayForAnimation: false);
    toastification.showCustom(
      context: context,
      autoCloseDuration: duration,
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
        return Theme(
          data: theme,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GestureDetector(
              onTap: () {
                onTap?.call();
                toastification.dismissById(holder.id);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: MasirNotice(
                  title: title,
                  message: message,
                  tone: tone,
                  icon: icon,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
