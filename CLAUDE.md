# Engineering Foundation

A language-agnostic engineering operating system for Claude Code.

## What this repo is

A collection of:
- **Slash commands** (`.claude/commands/`) — 9 workflow commands for Claude Code
- **Templates** (`templates/`) — CLAUDE.md, hooks, settings, output-styles, specs, rules
- **Guides** (`guides/`) — engineering principles based on Thoughtbot, 37signals, Shopify, and Anthropic

## Commands

No install needed. No build step.

```sh
# Check structure
ls .claude/commands/
ls templates/

# Push (uses amds92 SSH alias)
git push
```

## Structure

```
.claude/commands/     ← 9 slash commands: init, task, plan, branch, commit, review, pr, ci, ship
templates/            ← copy these into target projects
  CLAUDE.md.template
  CLAUDE.local.md.template
  settings.json.template
  settings.local.json.template
  hooks/pre-push.sh
  hooks/on-mcp-call.sh
  output-styles/writing.md
  specs/feature.md.template
  rules-examples/
guides/               ← git-flow, architecture, code-review, pr-culture
```

## Rules

- All commands are language-agnostic — no Rails/Ruby assumptions unless in examples
- Templates use placeholder syntax `[like this]` — never real values
- `/init` is the entry point — it generates the full environment, not just CLAUDE.md

## Git flow

- Branch: `feat/`, `fix/`, `chore/`, `docs/`
- Commits: Conventional Commits
- Remote: `git@github-amds92:amds92/engineering-foundation.git`
- Never push directly to main without testing the commands first

## Requirements

- Claude Code
- GitHub CLI (`gh auth login`)
- Git
