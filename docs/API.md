# API

## Edge Functions

### place-provider
- Method: `POST`
- Body:
  - `lat` (number)
  - `lng` (number)
  - `radius` (number, optional)
- Purpose: proxy place discovery requests to provider APIs

### ai-tagging
- Method: `POST`
- Purpose: classify/summarize place metadata (Phase 0: placeholder)
