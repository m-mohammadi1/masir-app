
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/app/router.dart';
import '/app/routes.dart';
import '/design/design.dart';

/// Keeps the app usable when something throws: a page that fails to build
/// shows a way out instead of a blank screen, and an error outside a build
/// (layout, async, a broken transition) raises a bar with «دوباره» and «خانه».
class AppErrors {
  AppErrors._();

  /// The latest error the student should be offered a way out of.
  static final current = ValueNotifier<Object?>(null);

  static DateTime? _lastShown;

  static void install() {
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      if (previous != null) {
        previous(details);
      } else {
        FlutterError.presentError(details);
      }
      if (!_ignorable(details)) report(details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught: $error\n$stack');
      report(error, stack);
      return true;
    };
    ErrorWidget.builder = (details) => BrokenView(details: details);
  }

  /// Noise that doesn't leave the student stuck: images that fail to load
  /// (cover placeholders take over) and small layout overflows.
  static bool _ignorable(FlutterErrorDetails details) {
    final text = details.exceptionAsString();
    if (details.library == 'image resource service') return true;
    if (text.contains('overflowed by')) return true;
    if (text.contains('HTTP request failed') ||
        text.contains('NetworkImageLoadException')) {
      return true;
    }
    return false;
  }

  static void report(Object error, [StackTrace? stack]) {
    // One bar per burst: a broken frame can throw many times in a row.
    final now = DateTime.now();
    if (_lastShown != null &&
        now.difference(_lastShown!) < const Duration(seconds: 2)) {
      return;
    }
    _lastShown = now;
    WidgetsBinding.instance.addPostFrameCallback((_) => current.value = error);
    WidgetsBinding.instance.scheduleFrame();
  }

  /// Rebuilds the page the student is on.
  static void retry() {
    current.value = null;
    final location = appRouter.routerDelegate.currentConfiguration.uri
        .toString();
    appRouter.go(location.isEmpty ? Routes.vitrine : location);
    appRouter.refresh();
  }

  /// Leaves for the Vitrine, which is always safe.
  static void home() {
    current.value = null;
    appRouter.go(Routes.vitrine);
  }
}

/// Shown in place of a widget that failed to build (Flutter's default is a
/// red box in debug and an empty grey area in release).
class BrokenView extends StatelessWidget {
  final FlutterErrorDetails details;
  const BrokenView({super.key, required this.details});

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Material(
      color: C.paper,
      child: LayoutBuilder(
        builder: (context, box) {
          // A small broken piece (a card, a row) gets a quiet placeholder;
          // a broken page gets the full way out.
          final small = box.maxHeight < 260 || box.maxWidth < 220;
          if (small) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: C.sand,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'این بخش نمایش داده نشد',
                textAlign: TextAlign.center,
                style: T.of(12, FontWeight.w700, C.muted),
              ),
            );
          }
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: C.coralSoft,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const MIcon(
                        MI.alert,
                        size: 44,
                        color: C.coralDark,
                        strokeWidth: 2.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'این صفحه درست باز نشد',
                      textAlign: TextAlign.center,
                      style: T.of(22, FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'پیشرفتت سر جاشه. یه بار دیگه امتحان کن یا برگرد به ویترین.',
                      textAlign: TextAlign.center,
                      style: T.of(15, FontWeight.w500, C.body, 1.9),
                    ),
                    if (kDebugMode) ...[
                      const SizedBox(height: 12),
                      Text(
                        details.exceptionAsString(),
                        textDirection: TextDirection.ltr,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: T.of(11, FontWeight.w500, C.muted, 1.4),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Btn(
                      'دوباره امتحان کن',
                      height: 52,
                      fontSize: 16,
                      onPressed: AppErrors.retry,
                    ),
                    const SizedBox(height: 8),
                    Btn(
                      'برگشت به ویترین',
                      kind: BtnKind.ghost,
                      height: 44,
                      fontSize: 15,
                      onPressed: AppErrors.home,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

/// Bar raised over the current page after an error outside a build, so a
/// half-drawn or blank screen is never a dead end.
class RecoveryBar extends StatelessWidget {
  final Widget child;
  const RecoveryBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: child),
      ValueListenableBuilder<Object?>(
        valueListenable: AppErrors.current,
        builder: (context, error, _) {
          if (error == null) return const SizedBox.shrink();
          return Positioned(
            left: 12,
            right: 12,
            bottom: 12 + MediaQuery.paddingOf(context).bottom,
            child: Material(
              color: Colors.transparent,
              child: Semantics(
                liveRegion: true,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: C.toast,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: C.darkLip, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: C.coral,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const MIcon(
                          MI.alert,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'یه چیزی درست کار نکرد',
                              style: T.of(15, FontWeight.w800, Colors.white),
                            ),
                            Text(
                              'اگه صفحه خالی موند، دوباره بزن.',
                              style: T.of(12, FontWeight.w500, C.toastMuted),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: AppErrors.retry,
                        child: Text(
                          'دوباره',
                          style: T.of(14, FontWeight.w800, Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: AppErrors.home,
                        child: Text(
                          'خانه',
                          style: T.of(14, FontWeight.w800, C.toastMuted),
                        ),
                      ),
                      IconButton(
                        tooltip: 'بستن',
                        onPressed: () => AppErrors.current.value = null,
                        icon: const MIcon(
                          MI.close,
                          size: 16,
                          color: C.toastMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
