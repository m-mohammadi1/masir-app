import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/foundation.dart';
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
  bool _connection = true;

  Future<bool> _initConnectivity() async {
    if (kIsWeb) {
      final result = await Connectivity().checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    }

    try {
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  StreamSubscription<List<ConnectivityResult>>? _connectionSubscription;

  @override
  void initState() {
    _initConnectivity();

    _connectionSubscription =
        Connectivity().onConnectivityChanged.listen((result) async {
          await _initConnectivity().then((bool isConnected) {
            if (mounted) {
              setState(() {
                _connection = isConnected;
              });
            }
          });
        });
    super.initState();
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.backAccess,
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
                            onTap: () {
                              _initConnectivity();
                              if (_connection) {
                                for (var element in GEasyHelper.retries) {
                                  element();
                                }
                                GEasyHelper.retries = [];
                                Navigator.pop(context);
                              }
                            },
                            child: widget.retryWidget,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OnClick(
                            onTap: () => Navigator.pop(context),
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
