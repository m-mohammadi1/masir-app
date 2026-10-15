import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Stroke icons drawn in the boards (24x24, round caps). Back arrows point
/// right (RTL). Body is the inner SVG; [filled] icons use fill instead of stroke.
class MI {
  final String body;
  final bool filled;
  const MI(this.body, {this.filled = false});

  static const back = MI('<path d="M5 12h14M13 6l6 6-6 6"/>');
  static const forward = MI('<path d="M15 6l-6 6 6 6"/>');
  static const chevronDown = MI('<path d="M6 9l6 6 6-6"/>');
  static const close = MI('<path d="M6 6l12 12M18 6L6 18"/>');
  static const plus = MI('<path d="M12 5v14M5 12h14"/>');
  static const check = MI('<path d="M5 12.5l4.5 4.5L19 7.5"/>');
  static const trophy = MI('<path d="M8 4h8v5a4 4 0 0 1-8 0z"/><path d="M8 6H5a3 3 0 0 0 3 4M16 6h3a3 3 0 0 1-3 4M12 13v4M8 20h8"/>');
  static const cup = MI('<path d="M8 4h8v5a4 4 0 0 1-8 0z"/><path d="M12 13v4M8 20h8"/>');
  static const lock = MI('<rect x="5" y="11" width="14" height="10" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/>');
  static const unlock = MI('<rect x="5" y="11" width="14" height="10" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 7.6-1.7"/>');
  static const info = MI('<circle cx="12" cy="12" r="9"/><path d="M12 11v6M12 7.5v.5"/>');
  static const alert = MI('<path d="M12 7v6M12 16.5v.5"/><circle cx="12" cy="12" r="9"/>');
  static const warning = MI('<path d="M12 3l9 16H3z"/><path d="M12 10v4M12 17v.5"/>');
  static const share = MI('<circle cx="18" cy="5" r="2.5"/><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="19" r="2.5"/><path d="M8.2 10.8l7.6-4.4M8.2 13.2l7.6 4.4"/>');
  static const play = MI('<path d="M8 5v14l11-7z"/>', filled: true);
  static const pause = MI('<rect x="6" y="5" width="4" height="14" rx="1.5"/><rect x="14" y="5" width="4" height="14" rx="1.5"/>', filled: true);
  static const fullscreen = MI('<path d="M4 9V4h5M20 9V4h-5M4 15v5h5M20 15v5h-5"/>');
  static const level = MI('<rect x="3" y="14" width="4" height="7" rx="1"/><rect x="10" y="9" width="4" height="12" rx="1"/><rect x="17" y="4" width="4" height="17" rx="1"/>', filled: true);
  static const list = MI('<path d="M9 6h11M9 12h11M9 18h11M4.5 6h.01M4.5 12h.01M4.5 18h.01"/>');
  static const listDots = MI('<path d="M9 6h11M9 12h11M9 18h11"/><circle cx="4.5" cy="6" r="1.3" fill="currentColor" stroke="none"/><circle cx="4.5" cy="12" r="1.3" fill="currentColor" stroke="none"/><circle cx="4.5" cy="18" r="1.3" fill="currentColor" stroke="none"/>');
  static const clock = MI('<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>');
  static const flag = MI('<path d="M5 21V4M5 4h12l-2.5 4L17 12H5"/>');
  static const megaphone = MI('<path d="M3 11v2a1 1 0 0 0 1 1h2l6 4V6L6 10H4a1 1 0 0 0-1 1z"/><path d="M16 9a3 3 0 0 1 0 6"/>');
  static const phone = MI('<rect x="7" y="2" width="10" height="20" rx="3"/><path d="M11 18h2"/>');
  static const book = MI('<path d="M3 5.5C5.5 4 9 4 12 6c3-2 6.5-2 9-.5V19c-2.5-1.5-6-1.5-9 .5-3-2-6.5-2-9-.5z"/><path d="M12 6v13.5"/>');
  static const pencil = MI('<path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M13.5 6.5l4 4"/>');
  static const image = MI('<rect x="3" y="4" width="18" height="16" rx="3"/><path d="M3 16l5-5 4 4 3-3 6 6"/>');
  static const camera = MI('<rect x="3" y="6" width="13" height="12" rx="2.5"/><path d="M16 10l5-3v10l-5-3"/>');
  static const shuffle = MI('<path d="M3 7h3.5c3 0 4.5 2 6 5s3 5 6 5H21M3 17h3.5c1.4 0 2.5-.5 3.4-1.3M14 8.3c.9-.8 2-1.3 3.5-1.3H21M18 4l3 3-3 3M18 14l3 3-3 3"/>');
  static const user = MI('<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>');
  static const search = MI('<circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/>');
  static const bell = MI('<path d="M6 16V11a6 6 0 0 1 12 0v5l2 2H4z"/><path d="M10 20a2 2 0 0 0 4 0"/>');
  static const flame = MI('<path d="M12 2.5c1 3.6 5.5 5.8 5.5 10.8a5.5 5.5 0 0 1-11 0c0-2.4 1.1-4 2.2-5 .3 1.7 1.3 2.8 2.4 2.8C10.6 8.6 11 5.6 12 2.5z"/>', filled: true);
  static const home = MI('<path d="M4 11l8-7 8 7v9h-5v-6H9v6H4z"/>');
  static const teachers = MI('<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20a6.5 6.5 0 0 1 13 0"/><path d="M16 4.5a3.5 3.5 0 0 1 0 7M18 14.5a6.5 6.5 0 0 1 3.5 5.5"/>');
  static const swap = MI('<path d="M7 4L3 8l4 4M3 8h14M17 20l4-4-4-4M21 16H7"/>');
  static const globe = MI('<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.5 3 2.5 15 0 18M12 3c-2.5 3-2.5 15 0 18"/>');
  static const telegram = MI('<path d="M21 4L3 11l6 2 2 6 3-4 5 4z"/>');
  static const eye = MI('<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>');
  static const video = MI('<rect x="3" y="5" width="18" height="14" rx="3"/><path d="M10 9.5v5l4.5-2.5z" fill="currentColor"/>');
  static const headphones = MI('<path d="M4 15v-3a8 8 0 0 1 16 0v3"/><rect x="3" y="14" width="5" height="7" rx="2"/><rect x="16" y="14" width="5" height="7" rx="2"/>');
  static const quiz = MI('<circle cx="12" cy="12" r="9"/><path d="M9.5 9.5a2.5 2.5 0 1 1 3.5 2.3c-.7.3-1 .9-1 1.7"/><circle cx="12" cy="17" r=".8" fill="currentColor"/>');
  static const store = MI('<path d="M4 9l1.5-5h13L20 9v1a3 3 0 0 1-5.3 2 3 3 0 0 1-5.4 0A3 3 0 0 1 4 10z"/><path d="M5 12v8h14v-8"/>');
  static const building = MI('<path d="M3 21h18M5 21V9l7-5 7 5v12M9 21v-5h6v5"/>');
  static const wifi = MI('<path d="M2 9a15 15 0 0 1 6-3.4M22 9a15 15 0 0 0-9-3.9M5 12.5a10 10 0 0 1 4-2.3M19 12.5a10 10 0 0 0-3-2M8.5 16a5 5 0 0 1 7 0"/><circle cx="12" cy="19.5" r="1" fill="currentColor"/><path d="M3 3l18 18"/>');
  static const undo = MI('<path d="M3 12a9 9 0 1 0 3-6.7L3 8"/><path d="M3 3v5h5"/>');
  static const card = MI('<rect x="3" y="5" width="18" height="14" rx="3"/><path d="M3 10h18M7 15h4"/>');
  static const moon = MI('<path d="M20 14.5A8 8 0 0 1 9.5 4a8 8 0 1 0 10.5 10.5z"/>');
  static const retry = MI('<path d="M20 12a8 8 0 1 1-2.3-5.6M20 4v5h-5"/>');
  static const bulb = MI('<path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-3.5 10.9c.6.5 1 1.2 1 2.1h5c0-.9.4-1.6 1-2.1A6 6 0 0 0 12 3z"/>');
  static const download = MI('<path d="M12 4v11M7 10l5 5 5-5M5 20h14"/>');
  static const sparkle = MI('<path d="M12 2l2.2 6.8L21 11l-6.8 2.2L12 20l-2.2-6.8L3 11l6.8-2.2z"/>', filled: true);
  static const logout = MI('<path d="M15 4h3a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-3M10 8l-4 4 4 4M6 12h10"/>');
  static const wallet = MI('<path d="M3 7h15a3 3 0 0 1 3 3v7a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3zM3 7l2.5-3h11L18 7M16.5 13.5h.01"/>');
  static const chat = MI('<path d="M4 5h16v11H8l-4 4z"/>');
  static const doc = MI('<path d="M7 3h7l5 5v13H7z"/><path d="M14 3v5h5"/>');
}

/// Draws an [MI] icon in [color].
class MIcon extends StatelessWidget {
  final MI icon;
  final double size;
  final Color? color;
  final double strokeWidth;

  const MIcon(this.icon, {super.key, this.size = 22, this.color, this.strokeWidth = 2.2});

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? const Color(0xFF2B2633);
    final hex = '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    final opacity = (c.a).toStringAsFixed(3);
    final attrs = icon.filled
        ? 'fill="$hex" fill-opacity="$opacity" stroke="none"'
        : 'fill="none" stroke="$hex" stroke-opacity="$opacity" stroke-width="$strokeWidth" stroke-linecap="round" stroke-linejoin="round"';
    final body = icon.body.replaceAll('currentColor', hex);
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" $attrs>$body</svg>',
      width: size,
      height: size,
    );
  }
}
