# Engineering Foundation

> A language-agnostic engineering operating system for Claude Code.

Three commands. Any language. Any stack. Claude works like a senior engineer who knows your project.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## How it works

```
/init → /task → /ship
```

| Command | When | What happens |
|---------|------|-------------|
| `/init` | Once per project | Investigates codebase, generates environment, commits and pushes |
| `/task [description]` | Every feature or fix | Plans → branches → implements → verifies → commits → reviews → opens PR |
| `/ship` | When CI is green | Review gate + CI gate + rebase + fast-forward merge + branch cleanup |

That's it. You describe what you want. Claude figures out how to build it, verifies the work, and hands you a PR.

---

## Quick start

```sh
# Clone the foundation
git clone git@github.com:amds92/engineering-foundation.git ~/engineering-foundation

# Copy commands into your project
mkdir -p your-project/.claude
cp -r ~/engineering-foundation/.claude/commands your-project/.claude/commands

# Open Claude Code and run /init
cd your-project
claude
/init
```

`/init` investigates your project, generates everything, and pushes. Then:

```
/task Add user authentication
```

Claude plans, asks for confirmation, then writes code, runs tests, commits, reviews, and opens a PR — without you managing each step.

---

## What `/init` generates

```
your-project/
├── CLAUDE.md                          ← project rules (auto-generated, ~100 lines)
├── CLAUDE.local.md                    ← your personal overrides (gitignored)
└── .claude/
    ├── settings.json                  ← permissions + hooks
    ├── hooks/
    │   ├── pre-bash.sh                ← blocks secrets before every git commit
    │   └── post-edit.sh               ← runs linter after every file edit
    ├── output-styles/
    │   └── writing.md                 ← Claude's tone, permanently
    └── rules/
        ├── testing.md                 ← loads when editing spec/ files
        └── api.md                     ← loads when editing controllers
```

Plus `specs/feature.md.template` — a contract to fill in before any feature work.

---

## Hooks — the part most people miss

Hooks are deterministic. They don't rely on Claude remembering to do something — they run automatically, every time, no exceptions.

**`PreToolUse` on Bash** — runs before every bash command Claude executes:
- Scans staged files for `master.key`, `.env`, `credentials.yml.enc`, private keys
- **Blocks the command** with a clear error if secrets are found
- The `master.key` incident can't happen

**`PostToolUse` on Edit/Write** — runs after every file edit:
- Automatically runs the linter on the changed file
- Detects stack: Ruby → RuboCop, JS/TS → ESLint, Python → Ruff, PHP → PHPCS, Go → gofmt
- Issues surface immediately, not at commit time

These are configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{"type": "command", "command": ".claude/hooks/pre-bash.sh"}]
    }],
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{"type": "command", "command": ".claude/hooks/post-edit.sh"}]
    }]
  }
}
```

---

## CLAUDE.md

What turns Claude from a generic assistant into a senior engineer who knows your project.

**Rules (from Anthropic's own practices):**
- Under 100 lines — for each line ask: "would removing this cause Claude to make mistakes?" If not, cut it
- Specific over vague: `bundle exec rspec` not "run the tests"
- No standard conventions — don't explain what Rails or REST are
- Always include **"Things that will bite you"** — the non-obvious gotchas

CLAUDE.md supports imports:
```markdown
See @README.md for project overview.
# Additional Instructions
- Git workflow: @docs/git-workflow.md
```

Use `.claude/rules/` for path-scoped conventions that only load when editing specific files.

---

## Git workflow

Based on Thoughtbot's approach:

1. **Branch** from up-to-date main
2. **Develop** with frequent commits
3. **Rebase** onto main before merge — no merge commits, linear history
4. **Fast-forward merge** (`--ff-only`) — if it can't fast-forward, the rebase didn't work
5. **Delete** branch after merge (remote + local)

`/ship` handles steps 3–5 automatically after review and CI pass.

---

## Specialized reviewers

`/review` and the self-review step in `/task` use two specialized subagents running in parallel — not a generic checklist.

| Subagent | Model | Scope |
|----------|-------|-------|
| `architecture-reviewer` | opus | Separation of concerns, abstractions, duplication, complexity, N+1 queries, test coverage |
| `security-reviewer` | opus | OWASP: auth/authz, injection, input validation, sensitive data, API security, cryptography |

Both run on every PR. Both report CRITICAL / CONCERN / NITPICK. A CRITICAL from either blocks merge.

These are deployed to `.claude/agents/` by `/init` — they work on any stack.

---

## Advanced commands

For when you want manual control over individual steps:

| Command | What it does |
|---------|-------------|
| `/plan` | Architecture planning only |
| `/branch` | Create branch only |
| `/commit` | Semantic commit only |
| `/review` | Full review (architecture + security in parallel) |
| `/pr` | Open PR only |
| `/ci` | Check CI status only |

These are the building blocks `/task` uses internally.

---

## Repository structure

```
engineering-foundation/
├── .claude/
│   └── commands/
│       ├── init.md        ← setup: investigate + generate + push
│       ├── task.md        ← main: plan → branch → code → verify → commit → review → PR
│       ├── ship.md        ← merge: review + CI + rebase + ff-only merge
│       ├── plan.md        ← advanced
│       ├── branch.md      ← advanced
│       ├── commit.md      ← advanced
│       ├── review.md      ← advanced (runs architecture + security subagents)
│       ├── pr.md          ← advanced
│       └── ci.md          ← advanced
├── guides/
│   ├── architecture.md
│   ├── code-review.md
│   ├── git-flow.md
│   └── pr-culture.md
├── templates/
│   ├── CLAUDE.md.template
│   ├── CLAUDE.local.md.template
│   ├── settings.json.template      ← with PreToolUse + PostToolUse hooks
│   ├── settings.local.json.template
│   ├── agents/
│   │   ├── security-reviewer.md    ← OWASP security review (opus)
│   │   └── architecture-reviewer.md ← architecture review (opus)
│   ├── hooks/
│   │   ├── pre-bash.sh             ← security: blocks secrets before commits
│   │   └── post-edit.sh            ← quality: lints after every edit
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

## Requirements

- [Claude Code](https://claude.ai/code)
- [GitHub CLI](https://cli.github.com/) — `gh auth login` once
- Git

---

## Philosophy

Inspired by how the best engineering teams work:

- **Anthropic** — CLAUDE.md under 100 lines, hooks over instructions, verify your own work
- **Thoughtbot** — rebase workflow, linear history, code review culture
- **37signals** — PRs are culture transmission, small and single-purpose
- **GitHub** — CI on every push, nothing broken lands on main

**The core belief:** Claude without context is a junior. Claude with context and good tooling is a senior. This foundation provides the context and tooling.

---

Built by [André Silva](https://github.com/amds92) · Grounded in Anthropic, Thoughtbot, 37signals, and GitHub engineering practices.
