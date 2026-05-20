---
description: Merge to main. Use when CI is green and the PR is approved. Runs review gate + CI check + rebase + fast-forward merge + branch cleanup.
disable-model-invocation: true
---

# Ship

Full gate before merging. Review must pass. CI must be green. Nothing broken ever lands on main.

## Steps

### Gate 1: Self-review

Read all changes since branching:

```sh
git diff main...HEAD
```

Check:
- Architecture — right abstraction? logic in the right layer?
- Duplication — does similar code already exist?
- Tests — success, failure, and edge cases covered?
- Security — unvalidated input? exposed data? secrets in code?
- Performance — N+1 queries? unbounded results?

```
--- CRITICAL (must fix before merge) ---
--- CONCERN (should fix) ---
--- NITPICK (optional) ---
--- VERDICT: APPROVED / NEEDS CHANGES ---
```

If CRITICAL issues found: fix them, commit, re-run `/ship`. Do not proceed.

### Gate 2: CI

```sh
gh run list --branch $(git branch --show-current) --limit 1
```

- ✅ All jobs green → continue
- ❌ Any job failing → show the failing job and log, abort
- ⏳ Still running → wait or abort and re-run when done

### Gate 3: Merge

Rebase onto main for a clean linear history, then fast-forward merge:

```sh
BRANCH=$(git branch --show-current)

git fetch origin main
git rebase origin/main

git checkout main
git pull origin main
git merge --ff-only $BRANCH

git push origin main

# Clean up
git push origin --delete $BRANCH
git branch -d $BRANCH
```

If rebase has conflicts: resolve them, `git rebase --continue`, then retry.

Verify:

```sh
git log --oneline -5
```

## Output

```
=== REVIEW ===   ✅ No critical issues
=== CI ===       ✅ All jobs green
=== RESULT ===   ✅ Merged feat/deployment-frequency → main (fast-forward)
                 ✅ Branch deleted (remote + local)
```

Or if blocked:

```
=== RESULT ===   ❌ Aborted — [reason]
Fix the issues above and run /ship again.
```

## Rules

- Never merge if CI is red
- Never merge if there are CRITICAL review issues
- Always rebase before merge — no merge commits, no diverged history
- Always `--ff-only` — if it can't fast-forward, the rebase didn't work
- Always delete the branch after merge (remote + local)
- Never force push to main
