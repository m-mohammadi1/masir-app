import 'package:flutter/material.dart';

import 'brand.dart';
import 'tokens.dart';

/// A photo (cover-fit). Until it exists or loads, the institute colour and
/// pattern hold its place, so nothing jumps on slow internet.
class CoverImage extends StatelessWidget {
  final String url;
  final Brand? brand;
  final BoxFit fit;
  final double patternOpacity;

  const CoverImage({
    super.key,
    required this.url,
    this.brand,
    this.fit = BoxFit.cover,
    this.patternOpacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final b = brand ?? BrandScope.of(context);
    final placeholder = Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: b.palette.p),
        PatternFill(
          pattern: b.pattern,
          color: b.palette.e,
          opacity: patternOpacity,
        ),
      ],
    );
    if (url.isEmpty) return placeholder;
    return Stack(
      fit: StackFit.expand,
      children: [
        placeholder,
        Image.network(
          url,
          fit: fit,
          frameBuilder: (context, child, frame, sync) => sync
              ? child
              : AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 250),
                  child: child,
                ),
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Round avatar: photo or the first letter on a soft background.
class Avatar extends StatelessWidget {
  final String name;
  final String url;
  final double size;
  final Color? bg;
  final Color? fg;

  const Avatar({
    super.key,
    required this.name,
    this.url = '',
    this.size = 44,
    this.bg,
    this.fg,
  });

  @override
  Widget build(BuildContext context) {
    final pal = BrandScope.paletteOf(context);
    final letter = name.trim().isEmpty
        ? ''
        : String.fromCharCode(name.trim().runes.first);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg ?? pal.soft, shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: url.isNotEmpty
          ? Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Text(
                letter,
                style: T.of(size * .42, FontWeight.w900, fg ?? pal.ink),
              ),
            )
          : Text(
              letter,
              style: T.of(size * .42, FontWeight.w900, fg ?? pal.ink, 1.1),
            ),
    );
  }
}
