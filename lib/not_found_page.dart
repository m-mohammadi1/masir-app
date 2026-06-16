import 'package:flutter/material.dart';
import '/widgets/custom_text.dart';

class NotFoundPage extends StatefulWidget {
  final String route;
  static const String routeName = "notFoundPage";

  const NotFoundPage({super.key, required this.route});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CustomText("404", fontWeight: FontWeight.w500, fontSize: 25),
      ),
    );
  }
}

class ClosePage extends StatefulWidget {
  const ClosePage({super.key});

  @override
  State<ClosePage> createState() => _ClosePageState();
}

class _ClosePageState extends State<ClosePage> {
  @override
  void initState() {
    Navigator.pop(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
