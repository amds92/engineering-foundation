# Engineering Foundation

> A language-agnostic engineering operating system for serious developers.

Stop reinventing your workflow on every project. This foundation gives you a proven, opinionated development system that works whether you're building a Rails API, a Python service, a PHP backend, or an Ember frontend.

---

## Philosophy

Inspired by how the best engineering teams work:

- **Shopify** — rebase daily, squash before merge, staging is mandatory
- **Thoughtbot** — linters own style, humans own logic, rebase-only history
- **37signals** — PRs are culture transmission, nitpicking is rigor not pedantry
- **GitHub** — small PRs, single-purpose, CI on every push
- **Addy Osmani** — AI as a workflow enforcer, not just a code generator

**The core belief:** Claude without context is a junior. Claude with context is a senior. This foundation gives Claude everything it needs to think and act like a senior engineer on your project.

---

## The Workflow

Every task follows the same flow, regardless of language or stack:

```
/task    →    /plan    →    /branch    →    develop    →    /commit    →    /review    →    /pr    →    /ci    →    /ship
```

| Phase | Command | What happens |
|-------|---------|-------------|
| **Define** | `/task` | Receive task, load project context, clarify scope, prepare to work |
| **Plan** | `/plan` | Architecture decisions before writing a single line |
| **Build** | `/branch` | Create correctly named branch |
| **Build** | `/commit` | Semantic commit with verification |
| **Review** | `/review` | Senior-level code review before PR |
| **Ship** | `/pr` | Create PR with real description |
| **Ship** | `/ci` | Verify CI is green |
| **Ship** | `/ship` | Full merge flow when everything passes |

---

## Quick Start

### 1. Copy to your project

```sh
# Copy CLAUDE.md template to your project root
cp templates/CLAUDE.md.template /path/to/your-project/CLAUDE.md

# Copy slash commands
cp -r .claude/commands /path/to/your-project/.claude/commands
```

### 2. Fill in your project context

Edit `CLAUDE.md` in your project root. This is the most important step — it gives Claude the context it needs to behave like a senior engineer on your specific project.

### 3. Start working

Open Claude Code in your project directory and use the commands:

```sh
cd your-project
claude

# Start a task
/task Fix the authentication bug where tokens expire too early

# Plan before coding
/plan

# Create your branch
/branch

# After writing code, review it
/review

# Create a PR
/pr

# Full ship when ready
/ship
```

---

## Installation

### Requirements

- [Claude Code](https://claude.ai/code) — the Claude CLI
- [GitHub CLI](https://cli.github.com/) — for CI and PR commands (`gh auth login`)
- Git

### Per-project setup

```sh
# 1. Clone this repo somewhere on your machine
git clone git@github.com:amds92/engineering-foundation.git ~/engineering-foundation

# 2. In any new project, copy the foundation
cp ~/engineering-foundation/templates/CLAUDE.md.template ./CLAUDE.md
cp -r ~/engineering-foundation/.claude ./claude

# 3. Edit CLAUDE.md with your project specifics
# (See templates/CLAUDE.md.template for what to fill in)

# 4. Done. Open Claude Code and start working.
claude
```

---

## Slash Commands Reference

### `/task [description]`
Start a new task. Loads project context, clarifies scope, and prepares Claude to work as a senior engineer on this specific task.

```
/task Implement pagination for the users endpoint
/task Fix memory leak in the background job processor
/task Add Elasticsearch integration for product search
```

### `/plan`
Before writing code — define the architecture. What files change, what patterns to follow, what to avoid. Prevents the most expensive mistakes.

### `/branch`
Create a correctly named branch based on the current task.
- `feat/` — new functionality
- `fix/` — bug fixes
- `chore/` — maintenance, deps, config
- `refactor/` — code improvements without behaviour change
- `docs/` — documentation only

### `/commit`
Create a semantic commit. Verifies no code duplication, checks conventions, writes a meaningful message.

### `/review`
Senior-level code review of all changes since branching. Checks architecture, patterns, duplication, test coverage, edge cases. Groups findings by severity.

### `/pr`
Create a PR with a real description — what changed, why, how to test, screenshots if relevant.

### `/ci`
Check GitHub Actions CI status for the current branch. Shows pass/fail per job and exact error lines if failing.

### `/ship`
Full ship flow: review → CI check → merge to main → delete branch. Only executes if everything passes.

---

## Guides

- [Git Flow](guides/git-flow.md) — branches, commits, rebasing, merging
- [Architecture Principles](guides/architecture.md) — language-agnostic design decisions
- [Code Review](guides/code-review.md) — how to give and receive reviews
- [PR Culture](guides/pr-culture.md) — what makes a great PR

---

## Adapting to your stack

This foundation is language-agnostic. When you fill in `CLAUDE.md` for your project, you define:

- The language and framework
- The testing tool (`rspec`, `pytest`, `jest`, `phpunit`, etc.)
- The linter (`rubocop`, `eslint`, `phpcs`, etc.)
- The CI tool
- Architecture patterns to follow
- What services exist and how they connect

Claude adapts its behaviour automatically based on this context.

---

## Contributing

This foundation improves when it's used. If you find something that doesn't work, open a PR.

- Branch naming: `feat/`, `fix/`, `docs/`
- Follow the same workflow this repo documents
- Update the relevant guide if behaviour changes

---

Built by [André Silva](https://github.com/amds92) · Inspired by Thoughtbot, 37signals, Shopify, and Addy Osmani's agent-skills.
