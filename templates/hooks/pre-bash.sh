#!/bin/bash
# .claude/hooks/pre-bash.sh
#
# PreToolUse hook — runs before every Bash command Claude executes.
# Blocks git commits and git add if sensitive files are staged or present.
#
# Receives JSON on stdin with the command Claude wants to run.
# Exit 0 = allow. Exit 1 + JSON output = block with reason.

set -e

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input', {}).get('command', ''))" 2>/dev/null || echo "")

# Only inspect git commit and git add commands
if ! echo "$COMMAND" | grep -qE "^git (commit|add)"; then
  exit 0
fi

# Files that must never be committed
SENSITIVE_PATTERNS=(
  "config/master.key"
  "config/credentials.yml.enc"
  ".env"
  ".env.local"
  ".env.production"
  "*.pem"
  "*.key"
  "*.p12"
  "*.pfx"
  "id_rsa"
  "id_ed25519"
  "id_dsa"
  ".netrc"
  "secrets.yml"
  "secrets.json"
)

# Check what's tracked or staged
TRACKED=$(git ls-files 2>/dev/null || echo "")
STAGED=$(git diff --cached --name-only 2>/dev/null || echo "")
ALL_FILES="$TRACKED
$STAGED"

BLOCKED=""
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  MATCH=$(echo "$ALL_FILES" | grep -E "^${pattern}$" 2>/dev/null || true)
  if [ -n "$MATCH" ]; then
    BLOCKED="$BLOCKED $MATCH"
  fi
done

if [ -n "$BLOCKED" ]; then
  echo "{\"continue\": false, \"stopReason\": \"Blocked: sensitive files detected — $BLOCKED. Run: git rm --cached <file> and add to .gitignore before committing.\"}"
  exit 1
fi

exit 0
