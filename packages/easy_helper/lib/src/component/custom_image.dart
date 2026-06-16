import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomImage extends StatelessWidget {
  static bool isCashed = false;
  static String defaultImage = "assets/png/avatar.png";
  static String baseImageUrl = "";
  final String? url;
  final String? assets;
  final double? width, height;
  final double? radius;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? blendMode;

  const CustomImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.assets,
    this.radius,
    this.fit,
    this.color,
    this.blendMode,
  });

  String get _url => "$baseImageUrl$url".trim();


  @override
  Widget build(BuildContext context) {
    bool isValidUrl = true;
    if (url != null  && url!.startsWith("assets")) {
      isValidUrl = false;
    }
    if (url != null && url!.isNotEmpty && isValidUrl) {
      bool isSvg = _url.split('.').last.toLowerCase() == 'svg';
      if (isSvg) {
        return ClipRRect(
          borderRadius: radius != null
              ? BorderRadius.circular(radius!)
              : BorderRadius.zero,
          child: SvgPicture.network(
            _url,
            width: width,
            height: height,
            fit: fit ?? BoxFit.fill,
            colorFilter: color != null
                ? ColorFilter.mode(
              color ?? Colors.transparent,
              blendMode ?? BlendMode.srcIn,
            )
                : null,
            placeholderBuilder: (context) => ClipRRect(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : BorderRadius.zero,
              child: _AssetImage(
                asset: assets,
                width: width,
                height: height,
                blendMode: blendMode,
                fit: fit,
                radius: radius,
                color: color,
              ),
            ),
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: radius != null
              ? BorderRadius.circular(radius!)
              : BorderRadius.zero,
          child: isCashed
              ? SizedBox(
            width: width,
            height: height,
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(),
              imageUrl: _url,
              width: width,
              height: height,
              fit: fit ?? BoxFit.fill,
              color: color,
              colorBlendMode: blendMode,
              errorWidget: (_, __, ___) => ClipRRect(
                borderRadius: radius != null
                    ? BorderRadius.circular(radius!)
                    : BorderRadius.zero,
                child: _AssetImage(
                  asset: assets,
                  width: width,
                  height: height,
                  blendMode: blendMode,
                  fit: fit,
                  radius: radius,
                  color: color,
                ),
              ),
            ),
          )
              : Image.network(
            _url,
            width: width,
            height: height,
            fit: fit ?? BoxFit.fill,
            color: color,
            colorBlendMode: blendMode,
            errorBuilder: (_, __, ___) => ClipRRect(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : BorderRadius.zero,
              child: _AssetImage(
                asset: assets,
                width: width,
                height: height,
                blendMode: blendMode,
                fit: fit,
                radius: radius,
                color: color,
              ),
            ),
          ),
        );
      }
    }
    return _AssetImage(
      asset: assets,
      width: width,
      height: height,
      blendMode: blendMode,
      fit: fit,
      radius: radius,
      color: color,
    );
  }
}

class _AssetImage extends StatelessWidget {
  final String? asset;
  final double? width, height;
  final double? radius;
  final BoxFit? fit;
  final BlendMode? blendMode;
  final Color? color;

  const _AssetImage({
    required this.asset,
    required this.width,
    required this.height,
    this.radius,
    this.fit,
    this.color,
    this.blendMode,
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = asset?.split('.').last.toLowerCase() == 'svg';
    if (asset != null && asset!.isEmpty) {
      return Container();
    }
    if (isSvg) {
      return ClipRRect(
        borderRadius:
        radius != null ? BorderRadius.circular(radius!) : BorderRadius.zero,
        child: SvgPicture.asset(
          "$asset",
          width: width,
          height: height,
          fit: fit ?? BoxFit.fill,
          colorFilter: color != null
              ? ColorFilter.mode(
            color ?? Colors.transparent,
            blendMode ?? BlendMode.srcIn,
          )
              : null,
          placeholderBuilder: (context) => _EmptyWidget(
            height: height ?? 20,
            width: width ?? 20,
            color: color ?? Colors.transparent,
            radius: radius ?? 4,
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius:
        radius != null ? BorderRadius.circular(radius!) : BorderRadius.zero,
        child: Image.asset(
          asset ?? CustomImage.defaultImage,
          width: width,
          height: height,
          fit: fit ?? BoxFit.fill,
          color: color,
          colorBlendMode: blendMode,
          errorBuilder: (_, __, ___) => _EmptyWidget(
            height: height ?? 20,
            width: width ?? 20,
            color: color ?? Colors.transparent,
            radius: radius ?? 4,
          ),
        ),
      );
    }
  }
}

class _EmptyWidget extends StatelessWidget {
  final double width, height;
  final double radius;
  final Color color;

  const _EmptyWidget({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
