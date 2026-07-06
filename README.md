# Locora

Locora is a location-based, AI-assisted discovery and planning app.

This repository is organized as a monorepo:
- `mobile/`: Flutter client app
- `supabase/`: Postgres migrations and Edge Functions
- `docs/`: architecture and setup documents

## Phase 0 Status

Phase 0 establishes:
- Flutter + Supabase project skeleton
- Feature-first Clean Architecture folders
- Riverpod DI and state management foundations
- Material 3 + dark mode toggle
- TR/EN localization base with Flutter official `gen_l10n`
- GoRouter-based navigation
- Environment-based secret handling

Note:
- `places` wiring in mobile is a Phase 0 placeholder only, not Phase 2 behavior.

## Quick Setup

1. Install Flutter stable and Dart.
2. Configure `mobile/.env` from `mobile/.env.example`.
3. Configure `supabase/.env` from `supabase/.env.example`.
4. Run Flutter app from `mobile/`.

See `docs/SETUP.md` for details.
