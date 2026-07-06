#!/usr/bin/env bash
set -euo pipefail

OWNER="keserali942-alt"
REPO="Locara"
BRANCH="main"
REQUIRED_CHECK="verify-mobile"

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: gh CLI not found"
  exit 1
fi

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "ERROR: GITHUB_TOKEN is not set"
  echo "Create a classic PAT with 'repo' scope and export it:"
  echo "  export GITHUB_TOKEN=<your_pat>"
  exit 1
fi

echo "Applying branch protection to ${OWNER}/${REPO}:${BRANCH}"

gh api -X PUT "repos/${OWNER}/${REPO}/branches/${BRANCH}/protection" \
  -H "Accept: application/vnd.github+json" \
  --input - <<JSON
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["${REQUIRED_CHECK}"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true,
  "lock_branch": false,
  "allow_fork_syncing": true
}
JSON

echo "Branch protection applied successfully."
