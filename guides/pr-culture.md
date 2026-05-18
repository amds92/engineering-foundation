# PR Culture

What makes a pull request great. Based on real practices from GitHub, 37signals, and Thoughtbot.

## The one rule

**One PR = one concern.**

Not "one feature". One concern. If you're fixing a bug and notice a refactor opportunity, that's two PRs.

Why: small PRs get reviewed faster, merged faster, and are easier to revert if something goes wrong. GitHub's data on 986 million code pushes confirms this — PR size is the #1 lever for cycle time.

## Anatomy of a great PR

### Title
Follows Conventional Commits: `feat(scope): description`

```
feat(users): add cursor-based pagination
fix(auth): prevent token replay after rotation
chore: upgrade Node.js to 22.x
```

### Description
Not a changelog. Not a summary of the diff. An explanation of **why** this exists and **what** changed.

```markdown
## What
Replaces offset pagination with cursor-based pagination for the users endpoint.

## Why
Offset pagination breaks with large datasets and high-frequency inserts.
Users were experiencing inconsistent results on page 2+.
Closes #312

## How
Added a `cursor` parameter that encodes the last seen record ID.
Uses an opaque Base64 token to hide implementation details from clients.
Backwards compatible — offset still works if `cursor` is not provided.

## Testing
1. GET /users — returns first page with next_cursor
2. GET /users?cursor=<token> — returns next page
3. GET /users?cursor=invalid — returns 400 with clear error message
```

### Size

| Lines changed | Status |
|--------------|--------|
| < 200 | Ideal |
| 200-400 | Acceptable |
| 400-800 | Consider splitting |
| > 800 | Split it |

Exceptions: auto-generated files, migrations, lockfiles.

## PR lifecycle

```
draft      →     ready for review     →     approved     →     merged
  │                    │                        │                 │
work in           at least 1 reviewer       all comments      squash +
progress          linter green              resolved          --no-ff
                  tests pass
```

## What reviewers owe authors

- A review within 1 working day (or a note that it'll take longer)
- Specific, actionable feedback (not "this is bad")
- Acknowledgement of what's good
- A clear verdict: approved, needs changes, or asking for more context

## What authors owe reviewers

- A PR small enough to review in < 30 minutes
- A description that removes the need to read every line
- Tests that prove the change works
- Responses to every comment

## Feature flags

For large features that can't ship in one PR: ship behind a feature flag. The flag lives in config, the code ships incrementally, the flag is enabled when ready.

This is how GitHub, Shopify, and Linear ship large features. Long-lived feature branches accumulate conflicts and become a liability. Incremental shipping behind flags avoids this entirely.
