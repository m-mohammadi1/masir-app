import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  CustomToast._();

  static Color _checkColor(Type t) {
    if (t == Type.success) {
      return Color(0XFF009966);
    } else if (t == Type.error) {
      return Color(0xffEB5757);
    }
    return Color(0xFF2F80ED);
  }

  static void toast(
    BuildContext context,
    String message, {
    Type type = Type.error,
    Duration showOutAnimationDuration = const Duration(milliseconds: 1200),
    Duration hideOutAnimationDuration = const Duration(milliseconds: 550),
    Duration displayDuration = const Duration(milliseconds: 3000),
    double additionalTopPadding = 16.0,
    double height = 100,
    VoidCallback? onTap,
    OverlayState? overlayState,
  }) async {
    if (message.isEmpty) return;
    if (type == Type.error) debugPrint("Error Toast log is: $message");

    toastification.showCustom(
      context: context,
      autoCloseDuration: const Duration(seconds: 5),
      alignment: Alignment.topRight,
      dismissDirection: DismissDirection.none,
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      direction: TextDirection.ltr,
      builder: (context, holder) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .2),
                blurRadius: 40,
                spreadRadius: 15,
              ),
            ],
          ),
          child: GestureDetector(
            onTapDown: (_) => holder.pause(),
            onTapUp: (_) => holder.start(),
            dragStartBehavior: DragStartBehavior.down,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0).copyWith(bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _checkColor(type),
                            width: 1.3,
                          ),
                        ),
                        child: Center(
                          child:
                              type == Type.info
                                  ? Text(
                                    "!",
                                    style: TextStyle(
                                      color: _checkColor(type),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  : Icon(
                                    type == Type.success
                                        ? Icons.done
                                        : Icons.close,
                                    color: _checkColor(type),
                                    size: 16,
                                  ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   type == Type.error
                            //       ? 'اخطار'
                            //       : type == Type.success
                            //       ? 'موفق'
                            //       : "هشدار",
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.w600,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            // SizedBox(height: 4),
                            Text(
                              message,
                              style: TextStyle(
                                color: Color(0xFF252525),
                                fontFamily: "Masir",
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          toastification.dismissById(holder.id);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  AnimatedLinearProgress(color: _checkColor(type)),
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
