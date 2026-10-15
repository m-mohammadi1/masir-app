import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '/design/design.dart';

/// HTML written in the dashboard (announcements, lessons, bios) in the
/// app's reading type: 16px, generous line height, links in the space colour.
class RichBody extends StatelessWidget {
  final String html;
  final double fontSize;
  final double lineHeight;
  const RichBody(
    this.html, {
    super.key,
    this.fontSize = 16,
    this.lineHeight = 2.05,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final base = Style(
      fontFamily: 'Vazirmatn',
      direction: TextDirection.rtl,
      fontSize: FontSize(fontSize),
      lineHeight: LineHeight(lineHeight),
      color: C.ink,
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    );
    return Html(
      data: html,
      shrinkWrap: true,
      onLinkTap: (url, _, _) {
        if (url != null) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      },
      style: {
        'body': base,
        'p': Style(margin: Margins.only(bottom: 16)),
        'h1': Style(
          fontSize: FontSize(fontSize + 6),
          fontWeight: FontWeight.w900,
          margin: Margins.only(bottom: 10),
        ),
        'h2': Style(
          fontSize: FontSize(fontSize + 4),
          fontWeight: FontWeight.w800,
          margin: Margins.only(bottom: 8),
        ),
        'h3': Style(
          fontSize: FontSize(fontSize + 2),
          fontWeight: FontWeight.w800,
          margin: Margins.only(bottom: 6),
        ),
        'a': Style(
          color: pal.ink,
          fontWeight: FontWeight.w800,
          textDecoration: TextDecoration.none,
        ),
        'strong': Style(fontWeight: FontWeight.w800),
        'b': Style(fontWeight: FontWeight.w800),
        'li': Style(margin: Margins.only(bottom: 6)),
        'blockquote': Style(
          backgroundColor: C.sand,
          padding: HtmlPaddings.symmetric(horizontal: 14, vertical: 10),
          margin: Margins.only(bottom: 16),
          border: Border(right: BorderSide(color: pal.p, width: 4)),
        ),
        'code': Style(
          backgroundColor: C.sand,
          fontFamily: 'monospace',
          fontSize: FontSize(fontSize - 2),
        ),
        'img': Style(margin: Margins.only(bottom: 16)),
      },
    );
  }
}
