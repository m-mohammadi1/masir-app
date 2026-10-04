import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';

/// Rich text (lessons, intros, bios) styled with the Masir body role, so
/// every HTML block in the app reads the same.
class MasirHtml extends StatelessWidget {
  final String data;

  const MasirHtml(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Html(
      data: data,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(MasirText.bodySize + 1),
          fontFamily: kMasirFont,
          color: c.ink,
          textAlign: TextAlign.right,
          direction: TextDirection.rtl,
          lineHeight: LineHeight.number(1.7),
        ),
        'h1': Style(
          color: c.ink,
          fontSize: FontSize(MasirText.displaySize),
          fontWeight: MasirText.heavy,
        ),
        'h2': Style(
          color: c.ink,
          fontSize: FontSize(MasirText.titleSize),
          fontWeight: MasirText.heavy,
        ),
        'h3': Style(
          color: c.ink,
          fontSize: FontSize(MasirText.headlineSize),
          fontWeight: MasirText.heavy,
        ),
        'a': Style(color: c.primary),
      },
    );
  }
}
