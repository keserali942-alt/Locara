# Architecture

Locora follows:
- Feature-first organization
- Clean Architecture layers inside each feature
- Riverpod for DI and state management
- Repository Pattern between presentation and data layers

## Example Feature Layout

```
features/places/
  presentation/
  domain/
  data/
```

## Secret Handling

- Mobile app reads only public Supabase URL/anon key from env.
- External API keys are never shipped to client.
- Third-party APIs are proxied through Supabase Edge Functions.
