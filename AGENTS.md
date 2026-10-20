# AGENTS.md

## Repository overview

Flutter student app for the **Masir** learning-path platform. It is its own git repository inside the `masir/` workspace, next to `backend/`, `dashboard/` and `product/`.

| Item | Value |
|------|--------|
| **Stack** | Flutter 3 / Dart SDK ^3.12 |
| **Package name** (`pubspec`) | `mohammad` (UI title: **مسیر**) |
| **Entry** | `lib/main.dart` → `MasirApp` (`lib/app/app.dart`) |
| **Routing** | `lib/app/router.dart` (`appRouter`, go_router), paths in `lib/app/routes.dart` |
| **API base** | `--dart-define=API_BASE_URL=…` (e.g. `https://api.getmasir.com/v1/app/`). Without it the app uses the local backend: `10.0.2.2:9393` on the Android emulator, `127.0.0.1:9393` elsewhere (`lib/core/services/service_locator.dart`) |
| **Design spec** | `../masir-design/` (README, `screens.md`, `rules/product-rules.md`, `tokens/`, `boards/*.dc.html`). Board inline styles are exact values and their Persian copy is exact |
| **Local path package** | `packages/easy_helper`: Dio `WebService` used by `MasirApi` |

## Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
# web (the backend's local CORS allows port 5174 only)
flutter run -d chrome --web-port 5174 --web-hostname 127.0.0.1

# after changing @injectable / hive annotations
dart run build_runner build --delete-conflicting-outputs
```

**Release (Android):** `scripts/build-release.sh` (APK) or `scripts/build-release.sh aab` (Play bundle) builds a signed, obfuscated build against `https://api.getmasir.com/v1/app/` into `build/release/`. It needs `android/key.properties` (git-ignored; template in `android/key.properties.example`); without it Gradle signs release builds with the debug key and the script refuses to run. Bump `version:` in `pubspec.yaml` before every upload. The full per-version checklist is in `RELEASING.md`. Launcher icons come from `assets/launcher/` (rendered from `masir-design/logo/`): `dart run flutter_launcher_icons`.

**Firebase:** `lib/firebase_options.dart`, `android/app/google-services.json` and the iOS config must exist for push. The background handler is registered in `lib/main.dart`; `lib/fcm.dart` opens the institute from a tapped notification.

## Directory layout

```
lib/
  main.dart, fcm.dart
  design/            # the design system: tokens, palettes, brand, icons, components (barrel: design.dart)
  core/
    api/             # MasirApi (Dio wrapper), models, endpoints (extension methods)
    services/        # HiveService, service_locator (+ generated .config.dart)
  app/
    app.dart, router.dart, routes.dart, screens.dart
    state/           # LoadCubit/LoadView, Session, nav helpers, OfflineQueue
    common/          # widgets shared by several spaces (course tile, video, rich HTML)
    onboarding/      # splash, intro, register, welcome, login
    masir/           # Masir space: vitrine, my institutes, profile (+ explore, inbox, subscriptions)
    institute/       # institute space: shell, home, courses, teachers, me, announcements, teacher page
    course/          # course detail, roadmap, plan sheet, payment result
    unit/            # unit page (lesson/video/audio/practice), quiz, review
assets/design/       # pattern and logo SVGs copied from masir-design
```

## How screens are built

- **Two spaces.** The Masir space is violet and has three tabs (`StatefulShellRoute`). The institute space takes the institute's palette and has four tabs (`ShellRoute` at `/i/:id/...`; only one institute shell lives on the stack). Detail pages (course, roadmap, unit) keep the colour of the space they were opened from.
- **Colours come from `BrandScope`.** Use `context.pal` (`p`, `e`, `on`, `soft`, `ink`) and `context.brand` (palette, pattern, logo frame). `MasirApp` provides `Session.space`; the institute shell, `InstituteBrand` and `CourseBrand` override it for their pages. Never hard-code an institute colour.
- **Tokens.** Neutral colours are `C.*`, text is `T.of(size, weight, color, height)`, lips are `lip(color, height)`, Persian digits are `fa(...)`. Formatting helpers (Jalali dates, toman, `perMonth`, `clock`, `pct`, `unitMeta`, `plain`) live in `design/format.dart`. All numbers shown to students go through `fa`.
- **Data.** Call the API through `inject<MasirApi>()` and the extension methods in `core/api/endpoints.dart`; every call returns `Either<ApiError, T>`. Show `ApiError.friendly` to students. Page loads use `LoadCubit<D>` + `LoadView<D>` (skeleton first, inline error with retry, data); the page provides the cubit with `BlocProvider` so it is closed with the page. Add new response fields to `core/api/models.dart`.
- **Feedback.** One `Toast` at a time (top, 3 s; errors stay). Section errors use `InlineError`. The full-page `OfflineView` is only for something the student asked for that couldn't reach the server. Confirmations use `confirmSheet`. Empty lists use `EmptyState`. Skeletons use `Bone`, never a full-screen spinner.
- **Offline completions.** A unit completed without a connection goes into `OfflineQueue` and is sent on the next app start or roadmap load.
- **Navigation.** Push detail pages with `context.push(Routes.x(id), extra: {...})`. Read `extra` with `extraOf(state)` (on web it comes back from history as JSON or null). Leave pages with `back(context)`, which falls back to the space's home when there is no history. Enter an institute through `Routes.threshold(id)` (the circle-reveal page), not its tabs directly.
- **Payments.** The plan sheet starts checkout and opens the bank page. The bank returns to `masir://payment?payment_id=…&status=…` on phones (intent filter / `CFBundleURLTypes`) or `${origin}/#/payment` on web; `MasirApp` routes both to `PaymentResultPage`.

## Debugging the web build

Debug web builds accept `?dev_token=<JWT>` on the URL to sign in without the login flow, which screenshot tooling uses. `HiveService` keeps the token, FCM token, theme flag and the offline completion queue.

## Conventions for agents

- **Imports:** use lib-root imports (`import '/design/design.dart';`).
- **Copy:** Persian, informal, exact as in the boards. Ask before inventing copy for a state the boards don't cover, and keep it in the same voice.
- **Generated files:** never hand-edit `*.g.dart`, `*.freezed.dart` or `service_locator.config.dart`.
- **Tests:** `test/` holds unit tests for formatting, palettes and models, plus widget tests for shared views. Add tests for non-trivial logic.
- **Analyze:** run `flutter analyze` and `flutter test` after substantive changes.
