#!/bin/bash
# .claude/hooks/post-edit.sh
#
# PostToolUse hook — runs after every file Edit or Write.
# Auto-runs the linter on the changed file so issues are caught immediately.
#
# Receives JSON on stdin with the file path that was edited.

set -e

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input', {}).get('path', ''))" 2>/dev/null || echo "")

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# ── Ruby ────────────────────────────────────────────────────────────────────
if echo "$FILE_PATH" | grep -qE "\.(rb|rake)$"; then
  if command -v bundle &>/dev/null && [ -f "Gemfile" ]; then
    bundle exec rubocop --format quiet "$FILE_PATH" 2>/dev/null || true
  fi
fi

# ── JavaScript / TypeScript ─────────────────────────────────────────────────
if echo "$FILE_PATH" | grep -qE "\.(js|ts|jsx|tsx|mjs)$"; then
  if command -v npx &>/dev/null; then
    npx eslint --quiet "$FILE_PATH" 2>/dev/null || true
  fi
fi

# ── Python ──────────────────────────────────────────────────────────────────
if echo "$FILE_PATH" | grep -qE "\.py$"; then
  if command -v ruff &>/dev/null; then
    ruff check "$FILE_PATH" 2>/dev/null || true
  fi
fi

# ── PHP ─────────────────────────────────────────────────────────────────────
if echo "$FILE_PATH" | grep -qE "\.php$"; then
  if [ -f "vendor/bin/phpcs" ]; then
    vendor/bin/phpcs "$FILE_PATH" 2>/dev/null || true
  fi
fi

# ── Go ───────────────────────────────────────────────────────────────────────
if echo "$FILE_PATH" | grep -qE "\.go$"; then
  if command -v gofmt &>/dev/null; then
    gofmt -l "$FILE_PATH" 2>/dev/null || true
  fi
fi

exit 0
