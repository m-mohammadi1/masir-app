import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.border,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonText({super.key, this.width = 120, this.height = 14});

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(width: width, height: height, radius: 6);
  }
}

class SkeletonList extends StatelessWidget {
  final int count;
  final double itemHeight;

  const SkeletonList({super.key, this.count = 6, this.itemHeight = 72});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => SkeletonBox(height: itemHeight, radius: 20),
    );
  }
}

class _SkeletonShimmer extends StatefulWidget {
  final Widget child;

  const _SkeletonShimmer({required this.child});

  @override
  State<_SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<_SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colors.border;
    final highlight = context.colors.border100;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: [base, highlight, base],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
