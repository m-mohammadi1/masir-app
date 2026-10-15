import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/app/router.dart';
import '/app/routes.dart';
import '/app/state/offline_queue.dart';
import '/app/state/session.dart';
import '/design/design.dart';

ThemeData masirTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: kFont,
    scaffoldBackgroundColor: C.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.violet,
      surface: C.paper,
      primary: C.violet,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: kFont,
      bodyColor: C.ink,
      displayColor: C.ink,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: C.violet,
      selectionColor: C.violetBorder,
      selectionHandleColor: C.violet,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: C.violet),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

/// The redesigned app (masir-design/). Persian, right-to-left.
class MasirApp extends StatefulWidget {
  const MasirApp({super.key});

  @override
  State<MasirApp> createState() => _MasirAppState();
}

class _MasirAppState extends State<MasirApp> {
  StreamSubscription<Uri>? _links;

  @override
  void initState() {
    super.initState();
    OfflineQueue.flush();
    if (!kIsWeb) {
      // masir://payment?payment_id=…&status=… brings the student back from the bank.
      _links = AppLinks().uriLinkStream.listen((uri) {
        if (uri.scheme == 'masir' && uri.host == 'payment') {
          appRouter.go(
            Uri(
              path: Routes.payment,
              queryParameters: uri.queryParameters,
            ).toString(),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _links?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    maxScaleFactor: 1.3,
    child: MaterialApp.router(
      title: 'مسیر',
      debugShowCheckedModeBanner: false,
      theme: masirTheme(),
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        // Pages outside a space shell (course, unit, teacher) keep the colour
        // of the space they were opened from.
        child: ValueListenableBuilder<Brand>(
          valueListenable: Session.space,
          builder: (_, brand, _) =>
              BrandScope(brand: brand, child: child ?? const SizedBox()),
        ),
      ),
    ),
  );
}
