import 'package:flutter/material.dart';

import '/core/theme/institute_presets.dart';
import '/core/theme/theme_context.dart';

/// Round institute logo "sticker": white ring, brand fill, initial fallback.
class InstituteLogo extends StatelessWidget {
  final String? logoUrl;
  final String name;
  final InstitutePreset preset;
  final double size;
  final bool ring;

  const InstituteLogo({
    super.key,
    required this.logoUrl,
    required this.name,
    required this.preset,
    this.size = 40,
    this.ring = true,
  });

  @override
  Widget build(BuildContext context) {
    final initial = Center(
      child: Text(
        name.isNotEmpty ? name.characters.first : 'م',
        style: TextStyle(
          fontFamily: 'Masir',
          color: preset.onPrimary,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.42,
        ),
      ),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: preset.primary,
        border: ring
            ? Border.all(color: context.colors.surface, width: size >= 48 ? 4 : 3)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? Image.network(
              logoUrl!,
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorBuilder: (_, _, _) => initial,
            )
          : initial,
    );
  }
}

/// Cover image with a solid brand-colour fallback (never an empty grey box).
class CoverImage extends StatelessWidget {
  final String? url;
  final Color fallback;
  final double? height;
  final double? width;

  const CoverImage({
    super.key,
    required this.url,
    required this.fallback,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final fill = ColoredBox(color: fallback, child: SizedBox(width: width, height: height));
    if (url == null || url!.isEmpty) return fill;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      width: width ?? double.infinity,
      height: height,
      errorBuilder: (_, _, _) => fill,
    );
  }
}
