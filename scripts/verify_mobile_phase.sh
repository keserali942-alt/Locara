#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: flutter is not installed or not in PATH"
  exit 1
fi

cd "$MOBILE_DIR"

if [[ ! -f .env ]]; then
  if [[ -f .env.example ]]; then
    cp .env.example .env
    echo "INFO: .env was missing, copied from .env.example"
  else
    echo "ERROR: .env and .env.example are both missing"
    exit 1
  fi
fi

echo "==> flutter pub get"
flutter pub get

echo "==> flutter gen-l10n"
flutter gen-l10n

if [[ ! -f android/app/build.gradle && ! -f android/app/build.gradle.kts ]]; then
  echo "INFO: Android scaffold missing, generating with flutter create"
  flutter create --platforms=android --project-name locora_mobile .
fi

echo "==> flutter analyze"
flutter analyze

echo "==> flutter test"
flutter test

echo "==> flutter build apk --debug"
flutter build apk --debug

echo "SUCCESS: Mobile phase verification completed"
