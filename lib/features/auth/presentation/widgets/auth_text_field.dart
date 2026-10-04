import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text_field.dart';

/// Text field with the focus-tinted look used across auth, OTP and register.
class AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final TextInputType? type;
  final TextDirection? textDirection;
  final int? maxLength;
  final TextInputAction action;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.isPassword = false,
    this.type,
    this.textDirection,
    this.maxLength,
    this.action = TextInputAction.next,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isFocused = focusNode.hasFocus;

    return CustomTextField(
      controller: controller,
      currentFocus: focusNode,
      labelText: label,
      isPassword: isPassword,
      type: type,
      textDirection: textDirection,
      maxLength: maxLength,
      action: action,
      onChanged: onChanged,
      textFieldRadius: MasirRadius.row,
      borderColor: isFocused ? c.primary : c.border,
      backgroundColor: isFocused ? c.primary100 : c.surface,
      labelStyle: MasirText.caption(c.ink, weight: MasirText.strong),
    );
  }
}
