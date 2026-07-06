# Setup

## Mandatory Phase Gate

Every phase must pass these checks before moving to the next phase:

1. Local verification:

```bash
./scripts/verify_mobile_phase.sh
```

2. Remote verification:
- Push branch to GitHub
- Wait for GitHub Actions workflow `Mobile Phase Gate` to pass
- Do not start next phase until the workflow is green

3. Protect `main` branch with required check:

```bash
export GITHUB_TOKEN=<PAT_with_repo_scope>
./scripts/apply_branch_protection.sh
```

Note: The default Codespaces integration token may return `403 Resource not accessible by integration` for branch protection API. In that case, use a personal access token once.

If local environment does not have Flutter, CI result becomes the mandatory source of truth.

## Prerequisites

- Flutter stable
- Dart SDK (bundled with Flutter)
- Supabase CLI (optional for local backend workflow)

## Mobile

1. Copy `mobile/.env.example` to `mobile/.env`
2. Fill values:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
3. Run:

```bash
cd mobile
flutter pub get
flutter run
```

## Phase 0 Verification Checklist

Run from `mobile/`:

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

Expected:
- `flutter analyze` returns no errors
- Widget smoke test passes
- App opens and shows empty home screen with theme/language actions

## Supabase

1. Copy `supabase/.env.example` to `supabase/.env`
2. Add required secrets
3. Deploy functions with Supabase CLI when ready
4. Configure OAuth providers in Supabase Dashboard:
   - Enable Google and Apple providers
   - Add client IDs/secrets
   - Set redirect URLs for the app and local development
5. Configure mobile deep-link / redirect schemes in the platform projects:
   - Android intent filter for the OAuth redirect scheme
   - iOS URL types / associated domains as required by the provider

## Phase 1 Verification Checklist

1. Run database migration that creates `users` and `discovery_profile` tables.
2. Start app and register with email/password or Google/Apple.
3. Complete onboarding survey and submit.
4. Verify records in SQL editor:

```sql
select id, email, created_at from public.users order by created_at desc limit 5;
select user_id, budget_tier, activities, companions, priorities, walking_preference, trip_pace
from public.discovery_profile
order by created_at desc
limit 5;
```

Expected:
- Signed-in user row exists in `public.users`
- Onboarding answers are saved in `public.discovery_profile`
