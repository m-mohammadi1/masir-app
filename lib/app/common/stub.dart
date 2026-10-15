import 'package:flutter/material.dart';

import '/design/design.dart';

/// Temporary page while the redesign is being built.
class StubPage extends StatelessWidget {
  final String name;
  const StubPage(this.name, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.paper,
    body: Center(child: Text(name, style: T.title())),
  );
}
