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

Three commands. That's it.

```
/init → /task → /ship
```

| Command | When | What happens |
|---------|------|-------------|
| `/init` | Once, when starting a project | Investigates the codebase, generates the full Claude Code environment, commits and pushes |
| `/task` | For every feature or fix | Plans → branches → implements → commits → reviews → opens PR |
| `/ship` | When CI is green | Reviews + CI check + merges to main + deletes branch |

**You only need to know three commands.** The rest happens automatically.

---

## Quick Start

### New project

```sh
# 1. Clone this foundation
git clone git@github.com:amds92/engineering-foundation.git ~/engineering-foundation

# 2. Copy the commands into your project
mkdir -p your-project/.claude
cp -r ~/engineering-foundation/.claude/commands your-project/.claude/commands

# 3. Open Claude Code and run /init
cd your-project
claude
/init
```

### Existing project

```sh
cp -r ~/engineering-foundation/.claude/commands your-project/.claude/commands
cd your-project
claude
/init
```

---

## What each command does

### `/init`
**Run once.** Investigates the project, generates the full environment, commits and pushes.

What it creates:
```
CLAUDE.md                        ← project rules, auto-generated
CLAUDE.local.md                  ← your personal overrides (gitignored)
.claude/
├── settings.json                ← shared permissions for the team
├── output-styles/writing.md     ← Claude's tone, permanently
├── hooks/pre-push.sh            ← lint + tests before every push
└── rules/                       ← path-scoped rules (spec/, controllers/, etc.)
specs/feature.md.template        ← contract template before coding
```

---

### `/task [description]`
**The main command.** Does the full development cycle without you having to manage each step.

```
/task Add deployment frequency endpoint
/task Fix JWT token expiry bug
/task Setup RSpec and testing infrastructure
```

What it does automatically:
1. Reads `CLAUDE.md` for project context
2. Plans the implementation — shows you what will change and waits for confirmation
3. Creates the right branch (`feat/`, `fix/`, `chore/`, etc.)
4. Implements the code following project conventions
5. Runs tests and linter — fixes issues before committing
6. Commits with a semantic message
7. Reviews the code (CRITICAL / CONCERN / NITPICK)
8. Opens the PR with a real description

You only intervene to **confirm the plan** and **review the PR**.

---

### `/ship`
**Merge when ready.** Runs the full gate before touching main.

1. Code review — aborts if CRITICAL issues found
2. CI check — aborts if tests are red
3. Merges with `--no-ff`, deletes branch (remote + local)

```
=== REVIEW ===   ✅ No critical issues
=== CI ===       ✅ All jobs green
=== RESULT ===   ✅ Merged feat/deployment-frequency → main
```

---

## Advanced commands

For when you want manual control over individual steps:

| Command | What it does |
|---------|-------------|
| `/plan` | Architecture planning only — no code |
| `/branch` | Create branch only |
| `/commit` | Semantic commit only |
| `/review` | Code review only |
| `/pr` | Open PR only |
| `/ci` | Check CI status only |

These are the building blocks `/task` uses internally. Use them when you need to intervene mid-flow.

---

## The "Quiet Files" — what most people miss

Everyone talks about `CLAUDE.md`. Few people use the files that make Claude behave correctly *automatically*:

| File | Purpose |
|------|---------|
| `CLAUDE.local.md` | Personal overrides — gitignored, never affects the team |
| `.claude/settings.json` | Shared permissions committed to the repo |
| `.claude/settings.local.json` | Your personal permissions — gitignored |
| `.claude/output-styles/writing.md` | Claude's tone permanently — no more "be shorter" |
| `.claude/hooks/pre-push.sh` | Runs every time before a push — deterministic |
| `.claude/rules/` | Path-scoped rules — loads only when editing matching files |

---

## CLAUDE.md

What turns Claude from a generic assistant into a senior engineer who knows your project. Generated by `/init`, refined by you.

**Key principles:**
- Under 150 lines — every line must answer "would removing this cause Claude to make mistakes?"
- Specific over vague — `bundle exec rspec` not "run the tests"
- No standard conventions — don't explain what Rails is
- Always include a **"Things that will bite you"** section

See [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template) for the full template.

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
│   └── commands/
│       ├── init.md       ← setup: generates full environment + commits + pushes
│       ├── task.md       ← main: plan → branch → code → commit → review → PR
│       ├── ship.md       ← merge: review gate + CI gate + merge
│       ├── plan.md       ← advanced: planning only
│       ├── branch.md     ← advanced: branch only
│       ├── commit.md     ← advanced: commit only
│       ├── review.md     ← advanced: review only
│       ├── pr.md         ← advanced: PR only
│       └── ci.md         ← advanced: CI check only
├── guides/
│   ├── architecture.md
│   ├── code-review.md
│   ├── git-flow.md
│   └── pr-culture.md
├── templates/
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
└── CLAUDE.md
```

---

## Contributing

This foundation improves when it's used. If something doesn't work, open a PR.

- Follow the same workflow this repo documents
- Update the relevant guide if behaviour changes
- Add real gotchas to the template when you discover them in the wild

---

Built by [André Silva](https://github.com/amds92) · Inspired by Thoughtbot, 37signals, Shopify, Addy Osmani, and Anthropic's own engineering practices.
