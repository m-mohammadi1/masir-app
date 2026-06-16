import 'package:flutter/material.dart';

extension SpacerWidgetInt on num {
  Widget get w => SizedBox(width: toDouble());

  Widget get h => SizedBox(height: toDouble());
}

extension SpacerWidget on BuildContext {
  Widget get maxW => SizedBox(width: MediaQuery.sizeOf(this).width);

  Widget get maxH => SizedBox(height: MediaQuery.sizeOf(this).height);

  Size get appSize => MediaQuery.sizeOf(this);
}
