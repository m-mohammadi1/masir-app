import 'package:flutter/material.dart';

class CustomSizeBox extends StatefulWidget {
  final Widget child;

  final GlobalKey gKey;

  const CustomSizeBox({
    super.key,
    required this.child,
    required this.gKey,
  });

  @override
  State<CustomSizeBox> createState() => _CustomSizeBoxState();
}

class _CustomSizeBoxState extends State<CustomSizeBox> {
  bool _canSetSize = false;

  void getSize(BuildContext context) {
    if (_canSetSize) return;
    print("Page size: $_size");
    _canSetSize = true;
    var renderBox = widget.gKey.currentContext?.findRenderObject() as RenderBox;

    Size size = renderBox.size;
    print('Widget Size: $size');
    setState(() {
      _size = size;
    });
  }

  Size? _size;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((value) => getSize(context));
    if (_size != null) {
      return SizedBox.fromSize(
        size: _size,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
