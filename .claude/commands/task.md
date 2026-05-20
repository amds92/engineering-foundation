---
description: Full development cycle for a task. Use for any feature, fix, or chore. Reads CLAUDE.md, plans, creates branch, implements, runs verification, commits, self-reviews, and opens PR. Only stops for human decisions.
disable-model-invocation: true
---

# Task

Full development cycle. Reads context → plans → branches → implements → verifies → commits → reviews → opens PR.

A senior engineer doesn't stop for problems they can solve. This command follows that principle: investigate, fix, continue. Only stop when a **human decision** is genuinely required.

## Usage

```
/task Add deployment frequency endpoint
/task Fix JWT token expiry bug
/task Setup RSpec and testing infrastructure
```

---

## When to solve autonomously vs. when to stop

**Solve without asking:**
- Environment issues (wrong language version, conflicting version managers, missing deps)
- Dependency conflicts
- Linter errors — fix them
- Test failures from setup or config issues
- Missing directories

**Stop and ask:**
- Ambiguous requirements ("what should happen when X?")
- Architecture choices with real tradeoffs
- Changes that could break existing users

---

## Steps

### 1. Load context

Read `CLAUDE.md`. If missing: stop — "No CLAUDE.md found. Run /init first."

Also read `CLAUDE.local.md` and relevant `.claude/rules/` files.

### 2. Understand

Restate in one sentence. If genuinely ambiguous, ask one question. If clear, proceed.

### 3. Plan

Before writing anything, check:
- What needs to be created or changed
- Whether similar code already exists — never duplicate
- The right abstraction for the stack
- What tests will verify the work is correct

Present the plan:

```
## Plan: [task name]

**What:** [one sentence]

**Files to create:**
- [file]

**Files to change:**
- [file]

**Verification:**
- Tests: [what specs will pass]
- Linter: clean
- Manual check: [curl command or behaviour to verify]

Proceed?
```

Wait for confirmation, then execute completely.

### 4. Create branch

```sh
git checkout main && git pull origin main
git checkout -b [type]/[short-description]
```

Types: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`, `perf/`

### 5. Fix environment first

Before writing feature code, ensure the environment works. **Read the full error. Identify root cause. Fix. Retry.**

**Ruby:**
- rbenv/rvm conflict → `rvm implode --force` to remove rvm
- OpenSSL errors → `gem pristine openssl` or `gem install openssl -- --with-openssl-dir=$(brew --prefix openssl@3)`
- Wrong version → `rbenv local [version]`
- `bundle install` fails → read error, fix specific conflict

**Node/JS:**
- nvm/n conflict → pick one, remove other from PATH
- Wrong version → `nvm use [version]` or check `.nvmrc`
- `npm install` fails → read error, fix lockfile or version

**Python:**
- Wrong version → `pyenv local [version]`
- Virtualenv issues → `python -m venv .venv && source .venv/bin/activate`

**Go:** `go mod tidy` for module issues

**PHP:** `composer install` — read error, fix version constraint

### 6. Implement

Follow the plan. Follow all rules in `CLAUDE.md` and `.claude/rules/`.

- Core logic first, then interface, then tests
- Run tests incrementally: `[test command] [specific file]`
- The `PostToolUse` hook runs linter after every edit — fix offenses as they appear

### 7. Verify

Full suite before committing. If it fails: read the error, fix it, retry. Never skip.

```sh
[linter]    # must be clean
[test suite] # must pass
```

Define the verification upfront in the plan so there's no ambiguity about what "done" means.

### 8. Commit

Before staging: verify no sensitive files are about to be committed.

```sh
git diff --cached --name-only  # review what's staged
git status                      # review untracked files
```

**Never commit:** `master.key`, `.env`, `credentials.yml.enc`, `*.pem`, `*.key`, private keys, tokens, passwords.

If a sensitive file appears — `git rm --cached <file>`, add to `.gitignore`, continue.

```sh
git add [specific files — never git add -A without reviewing]
git commit -m "[type(scope): description]"
```

Conventional Commits: `feat(metrics): add deployment frequency endpoint`

### 9. Self-review

Before opening a PR, review your own changes:

- Right abstraction? Logic in the right layer?
- Duplication? Does similar code already exist?
- Tests cover success, failure, and edge cases?
- Security: unvalidated input? exposed sensitive data?
- Performance: N+1 queries? unbounded results?

```
--- CRITICAL (fix before PR) ---
--- CONCERN (should fix) ---
--- NITPICK (optional) ---
--- VERDICT ---
```

Fix any CRITICAL before continuing.

### 10. Open PR

```sh
gh pr create --title "[type]: [description]" --body "$(cat <<'EOF'
## What
[what was built]

## Why
[why it was needed]

## How
[key decisions]

## Testing
[how to verify — specific commands or steps]

## Checklist
- [ ] Tests pass
- [ ] Linter clean
- [ ] No secrets committed
EOF
)"
```

### 11. Report

```
✅ Branch: feat/deployment-frequency
✅ Commits: 1
✅ Tests: 12 examples, 0 failures
✅ Linter: clean
✅ PR: https://github.com/org/repo/pull/1

Next: /ship when CI is green.
```
