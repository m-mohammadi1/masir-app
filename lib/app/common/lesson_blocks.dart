import 'dart:ui' show ImageFilter;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/design/design.dart';

/// A lesson written in the dashboard's block editor, drawn natively (no
/// WebView) so fonts, colours and RTL are the app's own (UnitHtml board).
/// [payload] is `{blocks: [...], images: {id: {url, preview_url, ...}}}`.
class LessonBlocks extends StatelessWidget {
  final Map<String, dynamic> payload;
  const LessonBlocks({super.key, required this.payload});

  static bool has(Map<String, dynamic> payload) =>
      payload['blocks'] is List && (payload['blocks'] as List).isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final blocks = (payload['blocks'] as List? ?? const [])
        .whereType<Map>()
        .map((m) => m.cast<String, dynamic>())
        .toList();
    final images = (payload['images'] as Map?)?.cast<String, dynamic>() ?? {};
    final children = <Widget>[];
    for (final b in blocks) {
      final w = _block(context, b, images);
      if (w == null) continue;
      if (children.isNotEmpty) children.add(const SizedBox(height: 18));
      children.add(w);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget? _block(
    BuildContext context,
    Map<String, dynamic> b,
    Map<String, dynamic> images,
  ) {
    final pal = context.pal;
    final ltr = b['ltr'] == true;
    switch (b['type']) {
      case 'p':
        return _Text(
          spans: _spans(b['text']),
          style: T.of(16, FontWeight.w500, C.ink, 2.05),
          ltr: ltr,
          align: _align(b['align'], ltr),
        );
      case 'h':
        final level = (b['level'] as num?)?.toInt() ?? 2;
        return Semantics(
          header: true,
          child: _Text(
            spans: _spans(b['text']),
            style: T.of(
              const [22.0, 18.0, 16.0][(level - 1).clamp(0, 2)],
              level == 1 ? FontWeight.w900 : FontWeight.w800,
              C.ink,
              1.6,
            ),
            ltr: ltr,
            align: _align(b['align'], ltr),
          ),
        );
      case 'quote':
        return Container(
          padding: const EdgeInsetsDirectional.only(start: 14),
          decoration: BoxDecoration(
            border: BorderDirectional(
              start: BorderSide(color: pal.p, width: 4),
            ),
          ),
          child: _Text(
            spans: _spans(b['text']),
            style: T.of(16, FontWeight.w500, C.body, 2.05),
            ltr: ltr,
          ),
        );
      case 'list':
        final style = '${b['style']}';
        final items = _lines(b['items']);
        final checked = (b['checked'] as List?) ?? const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ListMark(
                    style: style,
                    n: i + 1,
                    checked: i < checked.length && checked[i] == true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Text(
                      spans: items[i].spans,
                      style: T.of(15, FontWeight.w500, C.ink, 1.9),
                      ltr: items[i].ltr,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      case 'callout':
        return _Callout(style: '${b['style']}', lines: _lines(b['items']));
      case 'image':
        final img = images['${b['image_id']}'];
        if (img is! Map) return null;
        return _LessonImage(
          image: img.cast<String, dynamic>(),
          size: '${b['size'] ?? 'full'}',
          caption: '${b['caption'] ?? ''}',
        );
      case 'table':
        return _Table(
          rows: (b['rows'] as List? ?? const [])
              .map((r) => (r as List).map(_spans).toList())
              .toList(),
          header: b['header'] == true,
        );
      case 'divider':
        return Container(height: 2, color: C.border);
      case 'code':
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: C.ink,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${b['code'] ?? ''}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.7,
                  color: C.sand,
                ),
              ),
            ),
          ),
        );
    }
    return null;
  }
}

TextAlign? _align(Object? a, bool ltr) => switch (a) {
  'center' => TextAlign.center,
  'justify' => TextAlign.justify,
  'end' => ltr ? TextAlign.right : TextAlign.left,
  _ => ltr ? TextAlign.left : null,
};

class _Span {
  final String t;
  final bool b, i, u, s;
  final String? c, h, href;
  const _Span(
    this.t, {
    this.b = false,
    this.i = false,
    this.u = false,
    this.s = false,
    this.c,
    this.h,
    this.href,
  });
}

class _Line {
  final List<_Span> spans;
  final bool ltr;
  const _Line(this.spans, this.ltr);
}

List<_Span> _spans(Object? raw) => [
  for (final s in (raw as List? ?? const []).whereType<Map>())
    _Span(
      '${s['t'] ?? ''}',
      b: s['b'] == true,
      i: s['i'] == true,
      u: s['u'] == true,
      s: s['s'] == true,
      c: s['c'] as String?,
      h: s['h'] as String?,
      href: s['href'] as String?,
    ),
];

List<_Line> _lines(Object? raw) => [
  for (final l in (raw as List? ?? const []).whereType<Map>())
    _Line(_spans(l['text']), l['ltr'] == true),
];

/// Formatted text with tappable links (recognizers are disposed).
class _Text extends StatefulWidget {
  final List<_Span> spans;
  final TextStyle style;
  final bool ltr;
  final TextAlign? align;
  const _Text({
    required this.spans,
    required this.style,
    this.ltr = false,
    this.align,
  });

  @override
  State<_Text> createState() => _TextState();
}

class _TextState extends State<_Text> {
  final _taps = <TapGestureRecognizer>[];

  @override
  void dispose() {
    for (final t in _taps) {
      t.dispose();
    }
    super.dispose();
  }

  Color _color(String c, InstitutePalette pal) => switch (c) {
    'brand' => pal.ink,
    'green' => C.greenText,
    'red' => C.coralText,
    'brown' => C.sunText,
    _ => C.ink,
  };

  (Color, Color) _highlight(String h, InstitutePalette pal) => switch (h) {
    'green' => (C.greenSoft, C.greenText),
    'brand' => (pal.soft, pal.ink),
    'pink' => (C.coralSoft, C.coralTextDark),
    _ => (C.sunSoft, C.sunText),
  };

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    for (final t in _taps) {
      t.dispose();
    }
    _taps.clear();
    final spans = <InlineSpan>[];
    for (final s in widget.spans) {
      var style = TextStyle(
        fontWeight: s.b ? FontWeight.w800 : null,
        fontStyle: s.i ? FontStyle.italic : null,
        decoration: TextDecoration.combine([
          if (s.u || s.href != null) TextDecoration.underline,
          if (s.s) TextDecoration.lineThrough,
        ]),
        color: s.href != null
            ? pal.ink
            : (s.c != null ? _color(s.c!, pal) : null),
      );
      if (s.h != null) {
        final (bg, ink) = _highlight(s.h!, pal);
        style = style.copyWith(backgroundColor: bg, color: ink);
      }
      TapGestureRecognizer? tap;
      if (s.href != null) {
        tap = TapGestureRecognizer()
          ..onTap = () => launchUrl(
            Uri.parse(s.href!),
            mode: LaunchMode.externalApplication,
          );
        _taps.add(tap);
      }
      spans.add(TextSpan(text: s.t, style: style, recognizer: tap));
    }
    return Text.rich(
      TextSpan(style: widget.style, children: spans),
      textDirection: widget.ltr ? TextDirection.ltr : null,
      textAlign: widget.align,
    );
  }
}

class _ListMark extends StatelessWidget {
  final String style;
  final int n;
  final bool checked;
  const _ListMark({required this.style, required this.n, this.checked = false});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    switch (style) {
      case 'number':
        return Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(color: pal.p, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(fa(n), style: T.of(14, FontWeight.w800, pal.on, 1)),
        );
      case 'check':
        return Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            color: checked ? C.green : C.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: checked ? C.green : C.lip, width: 2),
          ),
          alignment: Alignment.center,
          child: checked
              ? const MIcon(
                  MI.check,
                  size: 14,
                  color: Colors.white,
                  strokeWidth: 3.2,
                )
              : null,
        );
      default:
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 12, left: 10, right: 10),
          decoration: BoxDecoration(color: pal.p, shape: BoxShape.circle),
        );
    }
  }
}

class _Callout extends StatelessWidget {
  final String style;
  final List<_Line> lines;
  const _Callout({required this.style, required this.lines});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final text = [
      for (var i = 0; i < lines.length; i++) ...[
        if (i > 0) const SizedBox(height: 6),
        _Text(
          spans: lines[i].spans,
          style: T.of(
            15,
            FontWeight.w500,
            style == 'example' && !lines[i].ltr ? C.body : C.ink,
            1.9,
          ),
          ltr: lines[i].ltr,
        ),
      ],
    ];
    if (style == 'example') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: C.surface,
          border: Border.all(color: C.border, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('یه نمونه', style: T.of(13, FontWeight.w800, C.muted)),
            const SizedBox(height: 10),
            ...text,
          ],
        ),
      );
    }
    final tip = style == 'tip';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: tip ? pal.soft : C.sunSoft,
        border: tip ? null : Border.all(color: C.sunBorder, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: tip ? pal.p : C.sun,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: MIcon(
              tip ? MI.bulb : MI.alert,
              size: 18,
              color: tip ? pal.on : C.sunInk,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  tip ? 'نکته' : 'هشدار',
                  style: T.of(15, FontWeight.w800, tip ? pal.ink : C.sunText),
                ),
                const SizedBox(height: 4),
                ...text,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dominant colour first, then the blurred preview, then the image.
class _LessonImage extends StatelessWidget {
  final Map<String, dynamic> image;
  final String size;
  final String caption;
  const _LessonImage({
    required this.image,
    required this.size,
    required this.caption,
  });

  static Color _hex(Object? v) {
    final s = '$v'.replaceFirst('#', '');
    final n = int.tryParse(s, radix: 16);
    return n == null || s.length != 6 ? C.sand : Color(0xFF000000 | n);
  }

  @override
  Widget build(BuildContext context) {
    final w = (image['width'] as num?)?.toDouble() ?? 16;
    final h = (image['height'] as num?)?.toDouble() ?? 9;
    final fraction = switch (size) {
      'mid' => .7,
      'small' => .45,
      _ => 1.0,
    };
    final alt = '${image['alt'] ?? ''}';
    final preview = '${image['preview_url'] ?? ''}';
    final pic = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: (w / h).clamp(.6, 2.4),
        child: LayoutBuilder(
          builder: (context, box) => Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: _hex(image['dominant'])),
              if (preview.isNotEmpty)
                ImageFiltered(
                  imageFilter: ColorFilterBlur.blur,
                  child: Image(
                    image: netImage(context, preview, box.biggest),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(),
                  ),
                ),
              Image(
                image: netImage(context, '${image['url']}', box.biggest),
                fit: BoxFit.cover,
                semanticLabel: alt.isEmpty ? null : alt,
                excludeFromSemantics: alt.isEmpty,
                frameBuilder: (_, child, frame, sync) => sync
                    ? child
                    : AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: MasirMotion.short,
                        child: child,
                      ),
                errorBuilder: (_, _, _) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
    return Column(
      children: [
        FractionallySizedBox(widthFactor: fraction, child: pic),
        if (caption.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: T.of(13, FontWeight.w500, C.muted),
          ),
        ],
      ],
    );
  }
}

/// Blur for the tiny preview.
abstract final class ColorFilterBlur {
  static final blur = ImageFilter.blur(sigmaX: 12, sigmaY: 12);
}

class _Table extends StatelessWidget {
  final List<List<List<_Span>>> rows;
  final bool header;
  const _Table({required this.rows, required this.header});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final cols = rows.fold<int>(0, (m, r) => r.length > m ? r.length : m);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: C.border, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: const TableBorder(
              horizontalInside: BorderSide(color: C.border, width: 2),
              verticalInside: BorderSide(color: C.border, width: 2),
            ),
            children: [
              for (var r = 0; r < rows.length; r++)
                TableRow(
                  decoration: header && r == 0
                      ? BoxDecoration(color: pal.soft)
                      : null,
                  children: [
                    for (var c = 0; c < cols; c++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 64,
                            maxWidth: 220,
                          ),
                          child: _Text(
                            spans: c < rows[r].length ? rows[r][c] : const [],
                            style: T.of(
                              14,
                              header && r == 0
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              C.ink,
                              1.8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
