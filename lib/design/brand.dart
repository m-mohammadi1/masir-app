import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'palettes.dart';
import 'tokens.dart';

/// An institute's identity: one palette, one pattern, one logo frame, plus
/// its logo (or the first letter of its name) and photos.
@immutable
class Brand {
  final InstitutePalette palette;
  final String pattern;
  final String frame;
  final String name;
  final String logoUrl;
  final String coverUrl;

  /// An independent teacher's space: the copy speaks about one person and
  /// the logo frame shows [teacherPhotoUrl].
  final bool solo;
  final String teacherPhotoUrl;

  const Brand({
    required this.palette,
    this.pattern = 'dots',
    this.frame = 'squircle',
    this.name = '',
    this.logoUrl = '',
    this.coverUrl = '',
    this.solo = false,
    this.teacherPhotoUrl = '',
  });

  /// What fills the logo frame: the teacher's photo in a solo space, else
  /// the logo (empty = the first letter).
  String get frameImageUrl =>
      solo && teacherPhotoUrl.isNotEmpty ? teacherPhotoUrl : logoUrl;

  /// «شاگرد» for a person's space, «عضو» for an institute: «شاگرد نگار شو»,
  /// «عضو Acme شو».
  String get memberWord => solo ? 'شاگرد' : 'عضو';

  /// The other learners: «۴۰ شاگرد» / «۵۵ هم‌کلاسی».
  String get peersWord => solo ? 'شاگرد' : 'هم‌کلاسی';

  /// The join button: «شروع کن» / «عضو شو».
  String get joinLabel => solo ? 'شروع کن' : 'عضو شو';

  static const masir = Brand(palette: masirPalette, name: 'مسیر');

  factory Brand.fromJson(Map<String, dynamic>? j) {
    if (j == null) return masir;
    return Brand(
      palette: paletteFor(j['palette'] as String?),
      pattern: (j['pattern'] as String?) ?? 'dots',
      frame: (j['logo_frame'] as String?) ?? 'squircle',
      name: (j['name'] as String?) ?? '',
      logoUrl: (j['logo_url'] as String?) ?? '',
      coverUrl: (j['cover_url'] as String?) ?? '',
      solo: j['solo'] == true || j['type'] == 'one_teacher',
      teacherPhotoUrl: (j['teacher_photo_url'] as String?) ?? '',
    );
  }

  String get letter {
    final t = name.trim();
    return t.isEmpty ? '' : String.fromCharCode(t.runes.first);
  }

  bool get isMasir => palette.key == 'masir';

  @override
  bool operator ==(Object other) =>
      other is Brand &&
      other.palette == palette &&
      other.pattern == pattern &&
      other.frame == frame &&
      other.name == name &&
      other.logoUrl == logoUrl &&
      other.coverUrl == coverUrl &&
      other.solo == solo &&
      other.teacherPhotoUrl == teacherPhotoUrl;

  @override
  int get hashCode => Object.hash(
    palette,
    pattern,
    frame,
    name,
    logoUrl,
    coverUrl,
    solo,
    teacherPhotoUrl,
  );
}

/// Provides the active space's brand: Masir violet outside institutes, the
/// institute's colours inside one. Detail screens keep the space's brand.
class BrandScope extends InheritedWidget {
  final Brand brand;

  const BrandScope({super.key, required this.brand, required super.child});

  static Brand of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BrandScope>()?.brand ??
      Brand.masir;

  static InstitutePalette paletteOf(BuildContext context) =>
      of(context).palette;

  @override
  bool updateShouldNotify(BrandScope oldWidget) => oldWidget.brand != brand;
}

extension BrandContext on BuildContext {
  Brand get brand => BrandScope.of(this);
  InstitutePalette get pal => BrandScope.of(this).palette;
}

// ---------------------------------------------------------------- patterns

class _PatternSpec {
  final double w;
  final double h;
  final bool cover;
  const _PatternSpec(this.w, this.h, {this.cover = false});
}

const _patternSpecs = {
  'dots': _PatternSpec(20, 20),
  'stripes': _PatternSpec(20, 20),
  'checker': _PatternSpec(24, 24),
  'grid': _PatternSpec(24, 24),
  'waves': _PatternSpec(40, 16),
  'zigzag': _PatternSpec(24, 12),
  'rings': _PatternSpec(32, 32),
  'sunburst': _PatternSpec(0, 0, cover: true),
  'kilim': _PatternSpec(24, 24),
  'girih': _PatternSpec(40, 40),
  'topo': _PatternSpec(120, 120),
  'confetti': _PatternSpec(60, 60),
};

const patternNamesFa = {
  'dots': 'نقطه',
  'stripes': 'راه‌راه',
  'checker': 'شطرنجی',
  'grid': 'شبکه',
  'waves': 'موج',
  'zigzag': 'زیگزاگ',
  'rings': 'حلقه',
  'sunburst': 'پرتو',
  'kilim': 'گلیم',
  'girih': 'گره',
  'topo': 'خطوط تراز',
  'confetti': 'کاغذرنگی',
};

final Map<String, Future<String>> _svgCache = {};
final Map<String, ui.Image> _tileCache = {};

Future<ui.Image?> _tile(String pattern, Color color, double dpr) async {
  final spec = _patternSpecs[pattern];
  if (spec == null || spec.cover) return null;
  final key = '$pattern-${color.toARGB32()}-$dpr';
  final cached = _tileCache[key];
  if (cached != null) return cached;
  final raw = await (_svgCache[pattern] ??= rootBundle.loadString(
    'assets/design/patterns/$pattern.svg',
  ));
  final hex =
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  final svg = raw.replaceAll('#000', hex);
  final info = await vg.loadPicture(SvgStringLoader(svg), null);
  final w = (spec.w * dpr).round(), h = (spec.h * dpr).round();
  final rec = ui.PictureRecorder();
  final canvas = Canvas(rec);
  canvas.scale(w / info.size.width, h / info.size.height);
  canvas.drawPicture(info.picture);
  final img = await rec.endRecording().toImage(w, h);
  info.picture.dispose();
  return _tileCache[key] = img;
}

/// A subtle same-colour texture (one of 12) laid over a coloured surface.
/// Boards draw it with the edge colour at 50% opacity.
class PatternFill extends StatefulWidget {
  final String pattern;
  final Color color;
  final double opacity;

  const PatternFill({
    super.key,
    required this.pattern,
    required this.color,
    this.opacity = 0.5,
  });

  @override
  State<PatternFill> createState() => _PatternFillState();
}

class _PatternFillState extends State<PatternFill> {
  ui.Image? _image;
  String? _sunburst;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  @override
  void didUpdateWidget(PatternFill old) {
    super.didUpdateWidget(old);
    if (old.pattern != widget.pattern || old.color != widget.color) _load();
  }

  Future<void> _load() async {
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2;
    if (_patternSpecs[widget.pattern]?.cover == true) {
      final raw = await (_svgCache[widget.pattern] ??= rootBundle.loadString(
        'assets/design/patterns/${widget.pattern}.svg',
      ));
      if (mounted) setState(() => _sunburst = raw);
      return;
    }
    final img = await _tile(widget.pattern, widget.color, dpr);
    if (mounted) setState(() => _image = img);
  }

  @override
  Widget build(BuildContext context) {
    if (_sunburst != null && _patternSpecs[widget.pattern]?.cover == true) {
      return IgnorePointer(
        child: Opacity(
          opacity: widget.opacity,
          child: SvgPicture.string(
            _sunburst!,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
          ),
        ),
      );
    }
    final img = _image;
    if (img == null) return const SizedBox.expand();
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2;
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _TilePainter(img, widget.opacity, dpr),
      ),
    );
  }
}

class _TilePainter extends CustomPainter {
  final ui.Image image;
  final double opacity;
  final double dpr;
  _TilePainter(this.image, this.opacity, this.dpr);

  @override
  void paint(Canvas canvas, Size size) {
    final m = Matrix4.diagonal3Values(1 / dpr, 1 / dpr, 1).storage;
    final paint = Paint()
      ..shader = ImageShader(image, TileMode.repeated, TileMode.repeated, m)
      ..color = Color.fromRGBO(0, 0, 0, opacity);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_TilePainter old) =>
      old.image != image || old.opacity != opacity;
}

// ---------------------------------------------------------------- logo frames

const frameNamesFa = {
  'circle': 'دایره',
  'squircle': 'مربع گرد',
  'arch': 'طاق',
  'hex': 'شش‌ضلعی',
  'shield': 'سپر',
  'flower': 'گل',
};

const _hex = [
  Offset(.25, .04),
  Offset(.75, .04),
  Offset(1, .5),
  Offset(.75, .96),
  Offset(.25, .96),
  Offset(0, .5),
];
const _shield = [
  Offset(.5, 0),
  Offset(1, .13),
  Offset(1, .57),
  Offset(.5, 1),
  Offset(0, .57),
  Offset(0, .13),
];
const _flower = [
  Offset(1.000, 0.500),
  Offset(0.984, 0.532),
  Offset(0.946, 0.559),
  Offset(0.907, 0.581),
  Offset(0.886, 0.604),
  Offset(0.893, 0.633),
  Offset(0.916, 0.672),
  Offset(0.935, 0.715),
  Offset(0.933, 0.750),
  Offset(0.904, 0.770),
  Offset(0.857, 0.774),
  Offset(0.812, 0.773),
  Offset(0.783, 0.783),
  Offset(0.773, 0.812),
  Offset(0.774, 0.857),
  Offset(0.770, 0.904),
  Offset(0.750, 0.933),
  Offset(0.715, 0.935),
  Offset(0.672, 0.916),
  Offset(0.633, 0.893),
  Offset(0.604, 0.886),
  Offset(0.581, 0.907),
  Offset(0.559, 0.946),
  Offset(0.532, 0.984),
  Offset(0.500, 1.000),
  Offset(0.468, 0.984),
  Offset(0.441, 0.946),
  Offset(0.419, 0.907),
  Offset(0.396, 0.886),
  Offset(0.367, 0.893),
  Offset(0.328, 0.916),
  Offset(0.285, 0.935),
  Offset(0.250, 0.933),
  Offset(0.230, 0.904),
  Offset(0.226, 0.857),
  Offset(0.227, 0.812),
  Offset(0.217, 0.783),
  Offset(0.188, 0.773),
  Offset(0.143, 0.774),
  Offset(0.096, 0.770),
  Offset(0.067, 0.750),
  Offset(0.065, 0.715),
  Offset(0.084, 0.672),
  Offset(0.107, 0.633),
  Offset(0.114, 0.604),
  Offset(0.093, 0.581),
  Offset(0.054, 0.559),
  Offset(0.016, 0.532),
  Offset(0.000, 0.500),
  Offset(0.016, 0.468),
  Offset(0.054, 0.441),
  Offset(0.093, 0.419),
  Offset(0.114, 0.396),
  Offset(0.107, 0.367),
  Offset(0.084, 0.328),
  Offset(0.065, 0.285),
  Offset(0.067, 0.250),
  Offset(0.096, 0.230),
  Offset(0.143, 0.226),
  Offset(0.188, 0.227),
  Offset(0.217, 0.217),
  Offset(0.227, 0.188),
  Offset(0.226, 0.143),
  Offset(0.230, 0.096),
  Offset(0.250, 0.067),
  Offset(0.285, 0.065),
  Offset(0.328, 0.084),
  Offset(0.367, 0.107),
  Offset(0.396, 0.114),
  Offset(0.419, 0.093),
  Offset(0.441, 0.054),
  Offset(0.468, 0.016),
  Offset(0.500, 0.000),
  Offset(0.532, 0.016),
  Offset(0.559, 0.054),
  Offset(0.581, 0.093),
  Offset(0.604, 0.114),
  Offset(0.633, 0.107),
  Offset(0.672, 0.084),
  Offset(0.715, 0.065),
  Offset(0.750, 0.067),
  Offset(0.770, 0.096),
  Offset(0.774, 0.143),
  Offset(0.773, 0.188),
  Offset(0.783, 0.217),
  Offset(0.812, 0.227),
  Offset(0.857, 0.226),
  Offset(0.904, 0.230),
  Offset(0.933, 0.250),
  Offset(0.935, 0.285),
  Offset(0.916, 0.328),
  Offset(0.893, 0.367),
  Offset(0.886, 0.396),
  Offset(0.907, 0.419),
  Offset(0.946, 0.441),
  Offset(0.984, 0.468),
];

Path _polygon(List<Offset> pts, Size s) {
  final p = Path()..moveTo(pts.first.dx * s.width, pts.first.dy * s.height);
  for (final o in pts.skip(1)) {
    p.lineTo(o.dx * s.width, o.dy * s.height);
  }
  return p..close();
}

/// The outline of a logo frame at size [s].
Path framePath(String frame, Size s) {
  final r = Offset.zero & s;
  switch (frame) {
    case 'circle':
      return Path()..addOval(r);
    case 'arch':
      return Path()..addRRect(
        RRect.fromRectAndCorners(
          r,
          topLeft: Radius.elliptical(s.width * .5, s.height * .4),
          topRight: Radius.elliptical(s.width * .5, s.height * .4),
          bottomLeft: Radius.elliptical(s.width * .14, s.height * .14),
          bottomRight: Radius.elliptical(s.width * .14, s.height * .14),
        ),
      );
    case 'hex':
      return _polygon(_hex, s);
    case 'shield':
      return _polygon(_shield, s);
    case 'flower':
      return _polygon(_flower, s);
    case 'squircle':
    default:
      return Path()
        ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(s.width * .3)));
  }
}

class FrameClipper extends CustomClipper<Path> {
  final String frame;
  const FrameClipper(this.frame);

  @override
  Path getClip(Size size) => framePath(frame, size);

  @override
  bool shouldReclip(FrameClipper old) => old.frame != frame;
}

/// The institute's logo in its frame: the uploaded logo, or the first letter
/// of the name in the institute colour. [inverted] draws a white frame with
/// the colour letter (on coloured headers).
class InstituteLogo extends StatelessWidget {
  final Brand brand;
  final double size;
  final bool inverted;
  final double? fontSize;

  const InstituteLogo({
    super.key,
    required this.brand,
    this.size = 48,
    this.inverted = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final pal = brand.palette;
    final bg = inverted ? Colors.white : pal.p;
    final fg = inverted ? pal.ink : pal.on;
    Widget inner;
    final image = brand.frameImageUrl;
    if (image.isNotEmpty) {
      inner = Image.network(
        image,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, _, _) => _letter(fg),
      );
    } else {
      inner = _letter(fg);
    }
    return SizedBox.square(
      dimension: size,
      child: ClipPath(
        clipper: FrameClipper(brand.frame),
        child: ColoredBox(
          color: bg,
          child: Center(child: inner),
        ),
      ),
    );
  }

  Widget _letter(Color fg) => Text(
    brand.letter,
    style: T.of(fontSize ?? size * 0.42, FontWeight.w900, fg, 1.1),
  );
}
