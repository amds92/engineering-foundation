# Task

Full development cycle for a single task. Reads context, plans, branches, implements, commits, reviews, and opens a PR — stopping only when a human decision is needed.

## Usage

```
/task Implement deployment frequency endpoint
/task Fix JWT token expiry bug
/task Add RSpec and configure testing infrastructure
```

## Steps

### 1. Load context

Read `CLAUDE.md` before anything else. If it doesn't exist, stop and say:
> "No CLAUDE.md found. Run /init first."

Also read `CLAUDE.local.md` and any relevant `.claude/rules/` files.

### 2. Understand the task

Restate what you understood in one sentence. If ambiguous, ask one focused question — not five. If clear, proceed immediately.

### 3. Plan

Before writing a single line of code, check:

- What needs to be created or changed (models, services, controllers, specs)
- Whether similar code already exists — never duplicate
- The right abstraction (service object, query, concern, job, client)

Present the plan and wait for confirmation:

```
## Plan: [task name]

**What:** [one sentence]

**Files to create:**
- app/services/foo_service.rb
- spec/services/foo_service_spec.rb

**Files to change:**
- config/routes.rb
- app/controllers/api/v1/foo_controller.rb

**Tests:**
- FooService: success path, failure path, edge case X
- Request spec: GET /api/v1/foo → 200 with correct shape

Proceed?
```

### 4. Create branch

After confirmation:

```sh
git checkout main && git pull origin main
git checkout -b [type]/[short-description]
```

Types: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`, `perf/`

### 5. Implement

Write the code following the plan and the rules in `CLAUDE.md`.

- Services first, then controllers, then specs
- Run tests as you go: `bundle exec rspec [file]`
- Fix RuboCop offenses inline: `bundle exec rubocop -a`

### 6. Verify

Before committing, full suite must pass:

```sh
bundle exec rubocop
bundle exec rspec
```

Do not commit broken code.

### 7. Commit

```sh
git add [specific files — never blindly add everything]
git commit -m "[type(scope): description]"
```

Conventional Commits format: `feat(metrics): add deployment frequency endpoint`

### 8. Review

Senior-level review of your own changes:

- Right abstraction? Logic in the right layer?
- Duplication? Does similar code already exist?
- Tests cover success, failure, and edge cases?
- Security: unvalidated input? exposed data?
- Performance: N+1 queries? unbounded results?

```
--- CRITICAL (fix before PR) ---
--- CONCERN (should fix) ---
--- NITPICK (optional) ---
--- VERDICT: APPROVED / NEEDS CHANGES ---
```

Fix any CRITICAL before continuing.

### 9. Open PR

```sh
gh pr create --title "[type]: [description]" --body "$(cat <<'EOF'
## What
[what was built]

## Why
[why it was needed]

## How
[key decisions]

## Testing
[how to verify]

## Checklist
- [ ] Tests pass
- [ ] No RuboCop offenses
- [ ] No debug code or secrets
EOF
)"
```

### 10. Report

```
✅ Branch: feat/deployment-frequency
✅ Commits: 1
✅ Tests: 12 examples, 0 failures
✅ RuboCop: no offenses
✅ PR: https://github.com/org/repo/pull/1

Next: /ship when CI is green.
```
