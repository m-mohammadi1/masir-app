# Releasing the Android app

How to build a new version of the Masir app and what to check before handing it out.

## Once per machine

1. Install Flutter (stable) and the Android SDK.
2. Restore the upload keystore from your backup into `~/.masir-release/`:
   - `masir-upload.jks`: the keystore
   - `key.properties`: its path and passwords
3. Copy `~/.masir-release/key.properties` to `android/key.properties`. That file is git-ignored; the template is `android/key.properties.example`.

Every version must be signed with this same keystore. A build signed with another key can't be installed over the old one, and the stores reject it. Without `android/key.properties`, Gradle signs with the debug key and `scripts/build-release.sh` refuses to run.

Upload key SHA-256: `2D:2B:75:E0:8F:16:86:60:F3:86:B4:9A:7C:F5:D8:A6:94:26:EC:9A:AB:A2:84:CF:FD:8D:F5:1F:8B:8C:8B:B1`

## Every new version

1. **Backend first.** If the release needs API changes, deploy the backend before handing out the app. Older app versions stay installed for months, so don't remove or rename fields in `/v1/app/...` that they still read.
2. **Pull and check:**
   ```bash
   git pull
   flutter analyze && flutter test
   ```
3. **Bump the version** in `pubspec.yaml`: `version: <name>+<build>`, e.g. `1.0.0+1` → `1.0.1+2`.
   - `<build>` (versionCode) must be **higher than every build already handed out**, in every store.
   - `<name>` is what users see: patch for fixes, minor for features.
4. **Build:**
   ```bash
   scripts/build-release.sh        # APK: Cafe Bazaar, Myket, direct install
   scripts/build-release.sh aab    # App Bundle: Google Play
   ```
   Output: `build/release/masir-<version>.apk|aab`, plus `symbols-<version>/`.
5. **Verify the file:**
   ```bash
   BT=~/Library/Android/sdk/build-tools/36.0.0
   $BT/apksigner verify --print-certs build/release/masir-<version>.apk   # SHA-256 matches the upload key above
   $BT/aapt2 dump badging build/release/masir-<version>.apk | grep -E "^package|label"  # app.masir, new versionCode, «مسیر»
   ```
6. **Install over the previous version** (don't uninstall it first) on a real phone:
   ```bash
   adb install -r build/release/masir-<version>.apk
   ```
   Check that you're still signed in and your progress is still there, then run a quick smoke test against production: login, Vitrine, open a course, finish a unit, a quiz.
7. **Archive** the APK/AAB **and** `symbols-<version>/` somewhere outside the repo (e.g. `~/.masir-release/builds/`). You need the symbols to read crash stack traces for that version.
8. **Tag** the release commit and push the tag:
   ```bash
   git tag v<name>+<build> && git push origin v<name>+<build>
   ```
9. **Publish:** upload to each store with a short Persian «تغییرات این نسخه» note.

## Reading an obfuscated crash

Release builds are obfuscated. Turn a stack trace back into readable Dart with the symbols for the device's CPU (usually arm64):

```bash
flutter symbolize -i crash.txt -d ~/.masir-release/builds/symbols-<version>/app.android-arm64.symbols
```

## Changing things

- **Icon:** replace the PNGs in `assets/launcher/` (rendered from `masir-design/logo/`), then run `dart run flutter_launcher_icons`. The background colour is in `pubspec.yaml` (`#7E42C5`).
- **Splash colour:** `android/app/src/main/res/values/colors.xml` (`ic_launcher_background`) for the native screen; `lib/app/onboarding/splash_page.dart` for the Flutter one. Keep them the same.
- **API URL:** the script uses `https://api.getmasir.com/v1/app/`. Override it for a staging build with `API_BASE_URL=https://…/v1/app/ scripts/build-release.sh`.
- **Minimum Android version:** `minSdk` in `android/app/build.gradle.kts` (24 = Android 7.0).

## Troubleshooting

- **`IconTreeShakerException: Font subsetting failed with exit code -9`:** the subsetting tool was killed (usually memory). Re-run the script.
- **"App not installed" / `INSTALL_FAILED_UPDATE_INCOMPATIBLE`:** the phone has a build signed with a different key, e.g. a debug build from `flutter run`. Uninstall it first (this deletes its local data).
- **Large APK (~60 MB):** it contains all CPU types. For direct sharing you can build smaller per-CPU files with `flutter build apk --split-per-abi` (same flags as the script); stores take the single APK or the AAB.
