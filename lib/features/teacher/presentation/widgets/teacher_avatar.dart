import 'package:flutter/material.dart';

import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';

class TeacherAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double size;

  const TeacherAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.size = 48,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    if (parts.isEmpty) return '?';
    final first = parts.first;
    if (parts.length == 1) return first.characters.first;
    return '${parts.first.characters.first}${parts.elementAt(1).characters.first}';
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: hasPhoto
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initialsBox(context),
              )
            : _initialsBox(context),
      ),
    );
  }

  Widget _initialsBox(BuildContext context) {
    return ColoredBox(
      color: context.colors.primarySoft,
      child: Center(
        child: CustomText(
          _initials,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
