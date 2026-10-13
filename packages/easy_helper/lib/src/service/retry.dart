import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

class RetryPage extends StatefulWidget {
  final Widget retryWidget, backWidget, body, background;
  final Color? backgroundColor;
  final bool backAccess;
  final String? message;

  const RetryPage({
    super.key,
    required this.backAccess,
    this.message,
    required this.retryWidget,
    required this.backWidget,
    required this.body,
    required this.background,
    this.backgroundColor,
  });

  @override
  State<RetryPage> createState() => _RetryPageState();
}

class _RetryPageState extends State<RetryPage> {
  /// Whether the device has a network to retry on. When the check itself
  /// fails, assume it does: the retried request reports a real failure.
  Future<bool> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } catch (_) {
      return true;
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    // The on-screen back button always leaves this page, so the system back
    // (Android back button / gesture) does the same, dropping the queue.
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) GEasyHelper.retries = [];
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: widget.backgroundColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // widget.background,
            SizedBox(
              width: _size.width,
              child: Column(
                children: [
                  Expanded(child: widget.body),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: OnClick(
                            onTap: () async {
                              final connected = await _initConnectivity();
                              if (!mounted || !connected) return;
                              // Take the queue before running it: a retry that
                              // fails again re-queues itself for the next visit.
                              final retries = GEasyHelper.retries;
                              GEasyHelper.retries = [];
                              Navigator.pop(context);
                              for (final retry in retries) {
                                retry();
                              }
                            },
                            child: widget.retryWidget,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OnClick(
                            onTap: () {
                              // Leaving without retrying drops the queued
                              // requests; their pages may already be closed.
                              GEasyHelper.retries = [];
                              Navigator.pop(context);
                            },
                            child: widget.backWidget,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
