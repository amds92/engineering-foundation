# Git Flow

How we work with Git. Language-agnostic, team-size-agnostic.

## Branch strategy

```
main
  └── feat/user-pagination     ← you work here
  └── fix/token-expiry
  └── chore/upgrade-dependencies
```

- `main` is always deployable
- Never commit directly to `main`
- One branch = one concern
- Delete branches after merge

## Branch naming

```
<type>/<short-description>
```

| Type | Use for |
|------|---------|
| `feat/` | New functionality |
| `fix/` | Bug fixes |
| `chore/` | Deps, config, tooling |
| `refactor/` | Code improvement, no behaviour change |
| `docs/` | Documentation |
| `test/` | Tests only |
| `perf/` | Performance |

## Commits

Follow [Conventional Commits](https://www.conventionalcommits.org). Short, imperative, meaningful.

```
feat(auth): add refresh token rotation
fix(jobs): prevent duplicate sends on retry
chore: upgrade Rails to 8.1
refactor(payments): extract charge logic into service
```

**Commit body** — explain WHY:
```
fix(jobs): prevent duplicate sends on retry

Sidekiq retries were sending multiple welcome emails when
SMTP timed out. Added Redis idempotency key to ensure
exactly-once delivery.

Fixes #142
```

## Rebasing

Rebase your branch against `main` regularly — Shopify engineers do this multiple times per day. It prevents conflicts from accumulating.

```sh
git fetch origin
git rebase origin/main
```

Before opening a PR, clean up your commit history:
```sh
git rebase -i origin/main
```

Squash fixup commits, keep logical commits separate.

## Merging

Always `--no-ff` when merging to main to preserve branch history:

```sh
git merge --no-ff feat/user-pagination
```

Never merge with unresolved conflicts. Never force-push to main.

## Golden rules

1. `main` is always green — never push broken code
2. Small commits — easier to review, easier to revert
3. Rebase > merge for keeping history clean
4. Delete branches after merge — no stale branches
5. Never use `--no-verify` to skip hooks
6. Never commit secrets — use environment variables
