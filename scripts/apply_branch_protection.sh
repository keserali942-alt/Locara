#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
	echo "ERROR: gh CLI is required"
	exit 1
fi

REPO_SLUG="${GITHUB_REPOSITORY:-}"
if [[ -z "$REPO_SLUG" ]]; then
	REPO_SLUG="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
fi

if [[ -z "$REPO_SLUG" ]]; then
	echo "ERROR: Could not determine repository slug"
	echo "Set GITHUB_REPOSITORY=owner/repo or run inside a git repo with gh auth"
	exit 1
fi

OWNER="${REPO_SLUG%%/*}"
REPO="${REPO_SLUG##*/}"
BRANCH="${1:-main}"
REQUIRED_CONTEXT="verify-mobile"

echo "Applying branch protection for ${OWNER}/${REPO}:${BRANCH}"

gh api \
	--method PUT \
	-H "Accept: application/vnd.github+json" \
	"repos/${OWNER}/${REPO}/branches/${BRANCH}/protection" \
	--input - <<JSON
{
	"required_status_checks": {
		"strict": true,
		"contexts": [
			"${REQUIRED_CONTEXT}"
		]
	},
	"enforce_admins": true,
	"required_pull_request_reviews": {
		"required_approving_review_count": 1,
		"dismiss_stale_reviews": true,
		"require_code_owner_reviews": false,
		"require_last_push_approval": false
	},
	"restrictions": null,
	"required_conversation_resolution": true,
	"allow_force_pushes": false,
	"allow_deletions": false,
	"block_creations": false
}
JSON

echo "Branch protection applied. Verifying required checks..."
gh api \
	-H "Accept: application/vnd.github+json" \
	"repos/${OWNER}/${REPO}/branches/${BRANCH}/protection" \
	--jq '.required_status_checks.contexts'

echo "SUCCESS: ${BRANCH} now requires status check '${REQUIRED_CONTEXT}'"
