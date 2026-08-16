import 'package:flutter/material.dart';
import 'masir_colors.dart';

extension MasirThemeX on BuildContext {
  MasirColors get colors => Theme.of(this).extension<MasirColors>()!;
}
