#!/bin/bash
# .claude/hooks/pre-push.sh
#
# Runs before Claude Code pushes to remote.
# Blocks the push if lint or tests fail.
#
# To enable: reference this in your .claude/settings.json hooks config.

set -e

echo "🔍 Running pre-push checks..."

# ── Detect stack and run appropriate checks ──────────────────────────────────

if [ -f "Gemfile" ]; then
  echo "→ Ruby project detected"

  echo "→ Running RuboCop..."
  bundle exec rubocop --fail-level error

  echo "→ Running tests..."
  bundle exec rspec --format progress

elif [ -f "package.json" ]; then
  echo "→ Node project detected"

  if grep -q '"lint"' package.json; then
    echo "→ Running lint..."
    npm run lint
  fi

  if grep -q '"test"' package.json; then
    echo "→ Running tests..."
    npm test
  fi

elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
  echo "→ Python project detected"

  if command -v ruff &> /dev/null; then
    echo "→ Running ruff..."
    ruff check .
  fi

  if command -v pytest &> /dev/null; then
    echo "→ Running pytest..."
    pytest
  fi

elif [ -f "go.mod" ]; then
  echo "→ Go project detected"
  echo "→ Running go vet..."
  go vet ./...
  echo "→ Running tests..."
  go test ./...

elif [ -f "composer.json" ]; then
  echo "→ PHP project detected"

  if [ -f "vendor/bin/phpcs" ]; then
    echo "→ Running PHPCS..."
    vendor/bin/phpcs
  fi

  if [ -f "vendor/bin/phpunit" ]; then
    echo "→ Running PHPUnit..."
    vendor/bin/phpunit
  fi
fi

echo "✅ Pre-push checks passed — pushing."
