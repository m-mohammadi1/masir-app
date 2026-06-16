import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';

class ServiceDeepLink {
  ServiceDeepLink._i() {
    _initDeepLinks();
  }

  static final ServiceDeepLink _singleton = ServiceDeepLink._i();

  factory ServiceDeepLink() => _singleton;

  late AppLinks _appLinks;

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint("deep link is : $uri");
      },
      onError: (error) {
        debugPrint("error is : $error");
      },
    );
    _appLinks.stringLinkStream.listen((event) {
      debugPrint("string deep link is : $event");
    });

    debugPrint("deep link is end");
  }
}
