import 'package:flutter/material.dart';

class KeyboardResponsiveWidget extends StatefulWidget {
  final Widget child;

  const KeyboardResponsiveWidget({super.key, required this.child});

  @override
  State<KeyboardResponsiveWidget> createState() => _KeyboardState();
}

class _KeyboardState extends State<KeyboardResponsiveWidget>
    with WidgetsBindingObserver {
  double bottomInset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = View.of(context).viewInsets.bottom;
    setState(() {
      bottomInset = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: widget.child,
    );
  }
}
