#!/usr/bin/env bash
# Signed, obfuscated release build against the production API.
#
#   scripts/build-release.sh          # APK  -> build/release/masir-<version>.apk
#   scripts/build-release.sh aab      # App Bundle (Google Play) -> build/release/masir-<version>.aab
#
# Needs android/key.properties (see android/key.properties.example).
# Bump `version:` in pubspec.yaml before every store upload: the build number
# (after the +) must grow.
set -euo pipefail
cd "$(dirname "$0")/.."

API_BASE_URL="${API_BASE_URL:-https://api.getmasir.com/v1/app/}"
FORMAT="${1:-apk}"

if [[ ! -f android/key.properties ]]; then
  echo "android/key.properties is missing: the build would be signed with the debug key." >&2
  echo "Copy android/key.properties.example and point it at the upload keystore." >&2
  exit 1
fi

VERSION="$(sed -n 's/^version: *//p' pubspec.yaml)"
SYMBOLS="build/release/symbols-$VERSION"
mkdir -p build/release

flutter pub get
dart run build_runner build --delete-conflicting-outputs

case "$FORMAT" in
  apk)
    flutter build apk --release --obfuscate --split-debug-info="$SYMBOLS" \
      --dart-define=API_BASE_URL="$API_BASE_URL"
    OUT="build/release/masir-$VERSION.apk"
    cp build/app/outputs/flutter-apk/app-release.apk "$OUT"
    ;;
  aab)
    flutter build appbundle --release --obfuscate --split-debug-info="$SYMBOLS" \
      --dart-define=API_BASE_URL="$API_BASE_URL"
    OUT="build/release/masir-$VERSION.aab"
    cp build/app/outputs/bundle/release/app-release.aab "$OUT"
    ;;
  *)
    echo "usage: $0 [apk|aab]" >&2
    exit 2
    ;;
esac

echo
echo "Built $OUT (API: $API_BASE_URL)"
echo "Keep $SYMBOLS: it de-obfuscates crash stack traces for this version."
