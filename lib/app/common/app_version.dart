import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/design/design.dart';

final Future<PackageInfo> _info = PackageInfo.fromPlatform();

/// «نسخه‌ی ۱٫۰٫۰» from the installed build (pubspec version), not a fixed
/// string. [prefix] goes before it, e.g. «مسیر • ».
class AppVersionText extends StatelessWidget {
  final String prefix;
  final TextStyle style;
  final TextAlign? textAlign;
  const AppVersionText({
    super.key,
    this.prefix = '',
    required this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
    future: _info,
    builder: (_, snap) {
      final v = snap.data?.version ?? '';
      return Text(
        v.isEmpty ? prefix.replaceAll(' • ', '') : '$prefixنسخه‌ی ${fa(v)}',
        textAlign: textAlign,
        style: style,
      );
    },
  );
}
