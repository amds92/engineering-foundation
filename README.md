# Engineering Foundation

> A language-agnostic engineering operating system for serious developers.

Stop reinventing your workflow on every project. This foundation gives you a proven, opinionated development system that works whether you're building a Rails API, a Python service, a PHP backend, or an Ember frontend — with Claude Code as a senior engineer on every project.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## Philosophy

Inspired by how the best engineering teams work:

- **Shopify** — rebase daily, squash before merge, staging is mandatory
- **Thoughtbot** — linters own style, humans own logic, rebase-only history
- **37signals** — PRs are culture transmission, nitpicking is rigor not pedantry
- **GitHub** — small PRs, single-purpose, CI on every push
- **Addy Osmani** — AI as a workflow enforcer, not just a code generator
- **Anthropic** — CLAUDE.md under 200 lines, specific over vague, gotchas documented

**The core belief:** Claude without context is a junior. Claude with context is a senior. This foundation gives Claude everything it needs to think and act like a senior engineer on your specific project.

---

## The Workflow

Every task follows the same flow, regardless of language or stack:

```
/init → /task → /plan → /branch → develop → /commit → /review → /pr → /ci → /ship
```

| Phase | Command | What happens |
|-------|---------|-------------|
| **Setup** | `/init` | Investigate project, generate full Claude Code environment |
| **Define** | `/task` | Load context, clarify scope, prepare to work |
| **Plan** | `/plan` | Architecture decisions before writing a single line |
| **Build** | `/branch` | Create correctly named branch |
| **Build** | `/commit` | Semantic commit with verification |
| **Review** | `/review` | Senior-level code review before PR |
| **Ship** | `/pr` | Create PR with real description |
| **Ship** | `/ci` | Verify CI is green |
| **Ship** | `/ship` | Full gate: review + CI + merge |

---

## Quick Start

### New project

```sh
# 1. Clone this foundation
git clone git@github.com:amds92/engineering-foundation.git ~/engineering-foundation

# 2. In your new project, copy the commands
mkdir -p your-project/.claude
cp -r ~/engineering-foundation/.claude/commands your-project/.claude/commands

# 3. Open Claude Code and let /init do the work
cd your-project
claude
/init
```

### Existing project

```sh
# 1. Copy the commands into your project
cp -r ~/engineering-foundation/.claude/commands your-project/.claude/commands

# 2. Open Claude Code and run /init — it investigates your codebase
cd your-project
claude
/init
```

`/init` reads your project, detects the stack, hunts for gotchas, and generates a complete Claude Code environment in under a minute. No manual configuration.

---

## What `/init` generates

```
your-project/
├── CLAUDE.md                        ← project rules, auto-generated
├── CLAUDE.local.md                  ← your personal overrides (gitignored)
├── .gitignore                       ← updated with Claude-specific entries
└── .claude/
    ├── settings.json                ← shared permissions for the team
    ├── settings.local.json          ← your personal permissions (gitignored)
    ├── output-styles/
    │   └── writing.md               ← Claude's tone and format, permanently
    ├── hooks/
    │   ├── pre-push.sh              ← lint + tests before every push
    │   └── on-mcp-call.sh           ← audit/gate MCP tool calls
    └── rules/
        ├── testing.md               ← loads when editing spec files
        ├── api.md                   ← loads when editing controllers
        └── security.md              ← loads when editing auth/payment code
```

Plus `specs/feature.md.template` — a contract template for every feature.

---

## The "Quiet Files" — what most people miss

Everyone talks about CLAUDE.md. Few people use the files that make Claude behave correctly *automatically*:

| File | Purpose |
|------|---------|
| `CLAUDE.local.md` | Personal overrides — gitignored, never affects the team |
| `.claude/settings.json` | Shared permissions committed to the repo |
| `.claude/settings.local.json` | Your personal permissions — gitignored |
| `.claude/output-styles/writing.md` | Defines Claude's tone permanently — no more "be shorter" |
| `.claude/hooks/pre-push.sh` | Deterministic: runs every time before a push |
| `.claude/hooks/on-mcp-call.sh` | Fires on every MCP tool call — log, audit, or block |
| `.claude/rules/` | Path-scoped rules — loads only when editing matching files |

---

## Slash Commands Reference

### `/init`
**Start here.** Investigates your project and generates a complete Claude Code environment automatically.

- Detects stack, framework, database, CI, deployment
- Reads existing patterns and conventions from the code
- Hunts for non-obvious gotchas (stale memoization, test setup requirements, deprecated code paths)
- Generates `CLAUDE.md`, `.claude/rules/`, `settings.json`, `output-styles/writing.md`, hooks, and `CLAUDE.local.md`
- Presents everything for review before writing

```
/init
```

---

### `/task [description]`
Entry point for any piece of work. Loads project context, clarifies scope, and prepares Claude to work as a senior engineer on this specific task. Never start coding without running this first.

```
/task Implement pagination for the users endpoint
/task Fix memory leak in the background job processor
/task Add Elasticsearch integration for product search
```

---

### `/plan`
Architecture before code. Identifies the right abstraction (service, job, cron, client, concern), checks for existing code to avoid duplication, defines what will change and what tests will be written. Presents a plan for confirmation before writing anything.

```
/plan
```

---

### `/branch`
Creates a correctly named branch from an up-to-date `main`.

| Type | When |
|------|------|
| `feat/` | New functionality |
| `fix/` | Bug fixes |
| `chore/` | Maintenance, deps, config |
| `refactor/` | Code improvement, no behaviour change |
| `docs/` | Documentation only |
| `perf/` | Performance improvements |

```
/branch
```

---

### `/commit`
Semantic commit following [Conventional Commits](https://www.conventionalcommits.org). Checks for debug code, secrets, and unrelated changes before committing.

```
/commit
```

**Output format:**
```
feat(users): add cursor-based pagination

Replaces offset pagination which broke with large datasets.
Closes #312
```

---

### `/review`
Senior-level code review of everything changed since branching. Checks architecture, separation of concerns, duplication, test coverage, security, and performance. Groups findings by severity.

```
/review
```

**Output:**
```
--- CRITICAL (must fix before merge) ---
--- CONCERN (should fix) ---
--- NITPICK (optional) ---
--- VERDICT: APPROVED / NEEDS CHANGES ---
```

---

### `/pr`
Creates a PR with a real description. Runs linter and tests first — never opens a PR with failures.

```
/pr
```

**PR structure:**
```markdown
## What
## Why
## How
## Testing
## Checklist
```

---

### `/ci`
Checks GitHub Actions CI status for the current branch. Shows per-job status and exact error lines if failing.

```
/ci
```

**Output:**
```
Branch: feat/user-pagination
Status: ✅ GREEN

Jobs:
  ✅ test (Ruby 3.2) — 45s
  ✅ lint (RuboCop)  — 12s
```

---

### `/ship`
Full gate before merging. Review + CI must both pass or it aborts with a clear reason.

```
/ship
```

**Output:**
```
=== REVIEW ===   ✅ No critical issues
=== CI ===       ✅ All jobs green
=== RESULT ===   ✅ Merged feat/user-pagination → main
```

---

## CLAUDE.md

The `CLAUDE.md` file is what turns Claude from a generic assistant into a senior engineer who knows your project. Generated by `/init`, refined by you.

**Key principles (from Anthropic's own practices):**
- Under 150 lines — every line must answer "would removing this cause Claude to make mistakes?"
- Specific over vague — `bundle exec rspec` not "run the tests"
- No standard conventions — don't explain what Rails is
- Always include a **"Things that will bite you"** section — the non-obvious gotchas

See [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template) for the full template.

---

## Path-scoped Rules

For larger projects, use `.claude/rules/` to keep CLAUDE.md short. Rule files only load when Claude edits matching files — keeping the context window clean.

```
.claude/
└── rules/
    ├── testing.md      # loads when editing spec/**/*
    ├── api.md          # loads when editing controllers
    └── security.md     # loads when editing auth/payment code
```

See [`templates/rules-examples/`](templates/rules-examples/) for examples.

---

## Hooks

Hooks run deterministically — not by asking Claude, but by the harness itself.

```
.claude/hooks/
├── pre-push.sh       # lint + tests before every push, auto-detects stack
└── on-mcp-call.sh    # fires on every MCP tool call — log, audit, or block
```

See [`templates/hooks/`](templates/hooks/) for ready-to-use scripts.

---

## Output Style

Put this once in `.claude/output-styles/writing.md` and never type "be more concise" again. Defines Claude's tone, response format, and what to skip — permanently, for the whole project.

See [`templates/output-styles/writing.md`](templates/output-styles/writing.md).

---

## Feature Specs

Before writing a single line of code, fill in `specs/feature.md.template`. It's the contract between what you want and what gets built — acceptance criteria, out-of-scope decisions, open questions, definition of done.

See [`templates/specs/feature.md.template`](templates/specs/feature.md.template).

---

## Guides

| Guide | What it covers |
|-------|---------------|
| [Git Flow](guides/git-flow.md) | Branches, commits, rebasing, merging |
| [Architecture](guides/architecture.md) | Language-agnostic design decisions |
| [Code Review](guides/code-review.md) | How to give and receive reviews |
| [PR Culture](guides/pr-culture.md) | What makes a great PR |

---

## Requirements

- [Claude Code](https://claude.ai/code)
- [GitHub CLI](https://cli.github.com/) — `gh auth login` once
- Git

---

## Repository structure

```
engineering-foundation/
├── .claude/
│   └── commands/          ← 9 slash commands
│       ├── init.md
│       ├── task.md
│       ├── plan.md
│       ├── branch.md
│       ├── commit.md
│       ├── review.md
│       ├── pr.md
│       ├── ci.md
│       └── ship.md
├── guides/                ← engineering principles
│   ├── architecture.md
│   ├── code-review.md
│   ├── git-flow.md
│   └── pr-culture.md
├── templates/             ← copy these to your project
│   ├── CLAUDE.md.template
│   ├── CLAUDE.local.md.template
│   ├── PR_TEMPLATE.md
│   ├── settings.json.template
│   ├── settings.local.json.template
│   ├── hooks/
│   │   ├── pre-push.sh
│   │   └── on-mcp-call.sh
│   ├── output-styles/
│   │   └── writing.md
│   ├── specs/
│   │   └── feature.md.template
│   └── rules-examples/
│       ├── testing.md
│       ├── api.md
│       └── security.md
└── CLAUDE.md              ← context for this repo itself
```

---

## Contributing

This foundation improves when it's used. If something doesn't work, open a PR.

- Follow the same workflow this repo documents
- Update the relevant guide if behaviour changes
- Add real gotchas to the template when you discover them in the wild

---

Built by [André Silva](https://github.com/amds92) · Inspired by Thoughtbot, 37signals, Shopify, Addy Osmani, and Anthropic's own engineering practices.
