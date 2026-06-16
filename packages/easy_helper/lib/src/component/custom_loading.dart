import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  final Color? color;
  final double? height;

  const CustomLoading({super.key, this.color, this.height = 55});

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {
  late final Timer? _timer;
  double _seconds = 0;

  @override
  void initState() {
    if (kDebugMode) {
      _timer = Timer.periodic(const Duration(milliseconds: 250), (time) {
        _seconds += .25;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("Loading time is: $_seconds seconds.");
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: widget.color,
        strokeWidth: 2.5,
      ),
    );
  }
}
