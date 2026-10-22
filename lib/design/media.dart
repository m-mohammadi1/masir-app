import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'brand.dart';
import 'tokens.dart';

/// A network photo kept on disk between launches and decoded only as large
/// as it shows in [box] (logical px) on this screen, never larger than the
/// photo itself. Cover-fit maths, so it still fills the box sharply.
ImageProvider netImage(BuildContext context, String url, Size box) {
  final provider = CachedNetworkImageProvider(url);
  if (!box.width.isFinite || !box.height.isFinite || box.isEmpty) {
    return provider;
  }
  final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2;
  return _CoverResize(
    provider,
    (box.width * dpr).ceil(),
    (box.height * dpr).ceil(),
  );
}

@immutable
class _CoverKey {
  final Object inner;
  final int width;
  final int height;
  const _CoverKey(this.inner, this.width, this.height);

  @override
  bool operator ==(Object other) =>
      other is _CoverKey &&
      other.inner == inner &&
      other.width == width &&
      other.height == height;

  @override
  int get hashCode => Object.hash(inner, width, height);
}

/// Like [ResizeImage], but sized for [BoxFit.cover]: the decoded image is
/// just big enough to cover [width]×[height] physical pixels.
class _CoverResize extends ImageProvider<_CoverKey> {
  final ImageProvider inner;
  final int width;
  final int height;
  const _CoverResize(this.inner, this.width, this.height);

  @override
  Future<_CoverKey> obtainKey(ImageConfiguration configuration) {
    // Stay synchronous when the inner key is, so a photo already in memory
    // shows on the first frame (no fade), as with Image.network.
    Completer<_CoverKey>? completer;
    SynchronousFuture<_CoverKey>? result;
    inner.obtainKey(configuration).then((key) {
      final k = _CoverKey(key, width, height);
      if (completer == null) {
        result = SynchronousFuture<_CoverKey>(k);
      } else {
        completer.complete(k);
      }
    });
    if (result != null) return result!;
    completer = Completer<_CoverKey>();
    return completer.future;
  }

  @override
  ImageStreamCompleter loadImage(_CoverKey key, ImageDecoderCallback decode) {
    Future<ui.Codec> decodeCover(
      ui.ImmutableBuffer buffer, {
      ui.TargetImageSizeCallback? getTargetSize,
    }) => decode(
      buffer,
      getTargetSize: (iw, ih) {
        final scale = math.max(width / iw, height / ih);
        if (scale >= 1) return const ui.TargetImageSize();
        return ui.TargetImageSize(
          width: (iw * scale).ceil(),
          height: (ih * scale).ceil(),
        );
      },
    );
    final completer = inner.loadImage(key.inner, decodeCover);
    // A failed photo is tried again next time it's shown.
    completer.addEphemeralErrorListener((_, _) {
      scheduleMicrotask(() => PaintingBinding.instance.imageCache.evict(key));
    });
    return completer;
  }

  @override
  bool operator ==(Object other) =>
      other is _CoverResize &&
      other.inner == inner &&
      other.width == width &&
      other.height == height;

  @override
  int get hashCode => Object.hash(inner, width, height);
}

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
        LayoutBuilder(
          builder: (context, box) => Image(
            image: netImage(context, url, box.biggest),
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
          ? Image(
              image: netImage(context, url, Size.square(size)),
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
