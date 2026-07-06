# Localization

Current locales:
- Turkish (`tr`)
- English (`en`)

System:
- Flutter official `gen_l10n`
- Config: `mobile/l10n.yaml`
- ARB files: `mobile/lib/l10n/app_en.arb`, `mobile/lib/l10n/app_tr.arb`

## Add a New Locale

1. Add `mobile/lib/l10n/app_{code}.arb`
2. Add translated keys matching `app_en.arb`
3. Run `flutter gen-l10n` (or `flutter run`/`flutter test`)
4. Done
