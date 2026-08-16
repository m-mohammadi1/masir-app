# AGENTS.md

## Repository overview

Flutter mobile client for the **Masir** education platform (student app). It talks to the production app API and is a **separate git repo** from the Masir monorepo packages (`backend/`, `dashboard/`, `student-demo/` live under the parent `masir/` folder).

| Item | Value |
|------|--------|
| **Stack** | Flutter 3 / Dart SDK ^3.12 |
| **Package name** (`pubspec`) | `mohammad` (UI title: **Masir**) |
| **Entry** | `lib/main.dart` |
| **Routing** | `lib/routes.dart` (`GoRouter`) |
| **API base** | `https://api.getmasir.com/v1/app/` (`lib/core/services/service_locator.dart`) |
| **Local path package** | `packages/easy_helper` — HTTP, navigation, failures, shared UI helpers |

For backend contracts, domain language, and MVP flows, see sibling docs when available: `../product/product.md`, `../product/domain/entities.md`, `../product/flows/`. For server architecture and local API dev, see `../AGENTS.md` (backend on port 9393 uses `/v1`, not `/v1/app/` — do not point the app at localhost without matching route prefixes).

## Commands

```bash
cd masir-app
flutter pub get
flutter analyze
flutter test

# Run (device / emulator required)
flutter run

# Code generation (injectable, freezed, hive adapters)
dart run build_runner build --delete-conflicting-outputs

# Watch mode while editing annotated classes
dart run build_runner watch --delete-conflicting-outputs
```

There is no Makefile in this repo; use the Flutter/Dart CLI directly.

**Firebase:** `lib/firebase_options.dart`, `android/app/google-services.json`, and iOS Firebase config must be present for FCM. Background handler is registered in `lib/main.dart`.

## Directory layout

```
lib/
  main.dart, routes.dart, splash_screen.dart, fcm.dart
  core/
    helper/          # colors, themes, assets, extensions, styles
    services/        # HiveService, service_locator (+ generated .config.dart)
  features/          # one folder per capability (see below)
  widgets/           # app-wide reusable widgets (buttons, inputs, base_screen, …)
packages/easy_helper/  # shared networking & UI utilities (path dependency)
assets/              # png, svg, fonts (Pinar, IRANSans)
android/, ios/       # platform projects
```

### Feature modules

| Feature | Role |
|---------|------|
| `auth`, `register`, `otp` | Login, signup, phone verification |
| `intro` | Onboarding |
| `main` | Institutes, subscriptions, course outline, units list, quiz submit API |
| `home` | Tab content: courses, detail, route map |
| `quiz` | Unit player (HTML, audio, video, multi-choice, true/false, practice) |
| `profile`, `edit_profile` | Profile and account settings |
| `about_us` | Static / CMS-style about content |

**Note:** `home/` and `profile/` sit beside feature slices that use full clean-architecture folders; they still depend on the same DI, routing, and API patterns.

## Architecture — feature slice

Each major feature follows **clean architecture** with **BLoC** on the presentation layer:

```
presentation/   page, widgets, bloc (+ event/state, often freezed)
domain/         entities, repository interfaces, use cases
data/           models, remote data sources, repository implementations
```

**Data flow**

1. **UI** dispatches events to a **Bloc** (`inject<SomeBloc>()` or `BlocProvider` where used).
2. **Bloc** calls a **UseCase** (`UseCase` / `UseCaseList` from `easy_helper`).
3. **UseCase** delegates to **Repository** (domain interface).
4. **Repository impl** calls **RemoteDataSource**, maps `DioException` → `Failure`, returns `Either<Failure, T>` (`dartz`).
5. **Models** parse JSON (`fromJson` / `toResult` on `BaseResult`); **entities** live in domain.

Repositories follow a consistent try/catch pattern: `ServerFailure().fromJson` when `e.response` exists, else `DefaultFailure`.

## Dependency injection

- **get_it** + **injectable** — registration in `lib/core/services/service_locator.dart`, generated `service_locator.config.dart`.
- Global accessor: `inject<T>()` in `service_locator.dart`.
- Annotate implementations:
  - `@Injectable(as: SomeRepository)` on repository impls
  - `@Injectable(as: SomeRemoteDataSource)` on data sources (often `sealed class` + `@factoryMethod` on the abstract API)
  - `@injectable` on use cases and blocs
- **`AppModule`** provides singleton `WebService` and `IRestfulApi` (`DioRestfulApi`).

After adding or changing `@injectable` / `@Injectable` classes, rerun **build_runner**.

## Networking

- **Dio** via `packages/easy_helper`: `WebService`, token refresh hook in `AppModule.webService`.
- **Auth header:** `Authorization: Bearer …` from `HiveService.token`; call `updateHeader()` after token changes.
- **Multipart:** `updateFormDataHeader(true|false)` toggles `Content-Type` before upload flows.
- **Refresh:** POST `auth/refresh`; on failure, `HiveService.logout()` may run.
- **Paths** are relative to base URL (e.g. `auth/username`, `auth/login`) in remote data sources.
- **Errors / offline:** `GEasyHelper` retry UI configured in `MyApp.builder` in `main.dart`; blocs often call `GEasyHelper.retry(message, () => add(event))` on failure.

## Local persistence

**Hive** (`HiveService`):

- Access / refresh tokens, FCM token, locale (`fa` default), theme flag, cached `User` (Hive adapter on auth entity).
- `HiveService.isLogged` gates splash → `MainPage` vs `AuthScreen`.
- `logout()` clears token/user boxes and refreshes HTTP headers.

Init order in `main()`: `HiveService.init()` → `setup()` (DI) → Firebase/FCM as configured.

## State management & codegen

- **flutter_bloc** + **bloc**; many blocs use **freezed** for events/states (`*.freezed.dart`).
- **Login pattern:** emit loading → `useCase` → `fold` → success or error (+ retry).
- Regenerate freezed/injectable/hive after annotation changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Navigation

- **go_router** — `router` in `lib/routes.dart`; `initialLocation` `/splash`.
- Prefer **`CustomNavigator`** from `easy_helper` (`pushNamed`, `go`) so `navigatorKey` and lifecycle observer stay consistent.
- Each screen exposes `static const routeName`; register new routes in `routes.dart`.
- Nested routes under `MainPage.routeName` (`/`) use child paths (e.g. `/courses`, `/outline`).
- Route extras: typed casts from `state.extra` (maps or ids) — match existing OTP / outline / unit patterns.

Global redirect for auth is stubbed (commented) in `routes.dart`; splash currently handles first-route logic.

## UI & localization

- **RTL Persian-first:** default locale `fa`; copy is mostly Persian strings in widgets.
- **Fonts:** Pinar (FD), IRANSans — declared in `pubspec.yaml`.
- **Theming:** `core/helper/custom_colors.dart`, `custom_themes.dart`; `AppColor`, `light` theme in `main.dart`.
- **Shared widgets:** prefer `lib/widgets/` (`CustomButton`, `CustomText`, `BaseScreen`, …) before duplicating.
- **Assets:** `core/helper/assets.dart` for centralized paths.
- **Rich content:** `flutter_html`, custom audio/video players under `features/quiz/presentation/widgets/`.

## Adding a feature — checklist

1. Create `lib/features/<name>/` with `data/`, `domain/`, `presentation/` as needed.
2. **Domain:** entity, `XxxRepository` abstract class, `XxxUseCase` implementing `UseCase<…>`.
3. **Data:** `RequestXxxModel` implements `BaseRequest`; response model extends entity with `fromJson` / `toResult`; sealed `XxxRemoteDataSource` + impl calling `restfulApi.get/post/…`.
4. **Repository impl:** `@Injectable(as: XxxRepository)`, map exceptions to `Either`.
5. **Presentation:** bloc (+ freezed if used), page with `routeName`, widgets.
6. Register route in `routes.dart`.
7. Run **build_runner** so DI picks up new classes.
8. If response shapes are unclear, align with **backend** OpenAPI or handlers under `../backend/` and product docs.

## Conventions for agents

- **Imports:** codebase mixes `import '/…'` (lib-root) and `import 'package:mohammad/…'` — match the file you edit.
- **Minimize scope:** one feature slice per task; do not refactor unrelated blocs or rename package `mohammad` unless asked.
- **Secrets:** do not commit real API keys; Firebase config files are environment-specific.
- **Generated files:** never hand-edit `*.g.dart`, `*.freezed.dart`, `service_locator.config.dart`.
- **Tests:** `flutter_test` is available; add tests only when requested or for non-trivial logic.
- **Analyze:** run `flutter analyze` after substantive Dart changes.

## Related repositories

| Path (sibling) | Purpose |
|----------------|---------|
| `../backend/` | Go API, source of truth for `/v1` REST |
| `../dashboard/` | RTL React admin |
| `../student-demo/` | Web student demo |
| `../product/` | Product specs and task breakdown |

When implementing new student-facing capabilities, confirm the **`/v1/app/`** mobile routes and payloads on the backend before wiring UI.
