---
description: Senior-level code review using specialized subagents. Use before opening a PR or when you want a thorough review of changes on the current branch. Runs security and architecture reviewers in parallel.
disable-model-invocation: true
---

# Review

Senior-level code review before a PR. Two specialized reviewers run in parallel — one focused on security (OWASP), one on architecture. Neither pulls punches.

## Steps

### 1. Get the scope

```sh
git diff main...HEAD --name-only
git diff main...HEAD --stat
```

Read every changed file completely — not just the diff, but the full file for context.

### 2. Run specialized reviewers in parallel

Spawn two subagents simultaneously:

**Subagent 1 — architecture-reviewer**
Pass: the list of changed files and the full diff. The agent checks separation of concerns, abstractions, duplication, complexity, naming, error handling, N+1 queries, and test coverage.

**Subagent 2 — security-reviewer**
Pass: the list of changed files and the full diff. The agent checks authentication/authorization, injection vectors, input validation, sensitive data exposure, API security, cryptography, and dependencies.

Wait for both to complete.

### 3. Synthesize

Merge both reports into a single review. Rules for synthesis:

- **CRITICAL from either** → CRITICAL in the final report. Must fix before merge.
- **CONCERN from architecture / HIGH from security** → CONCERN. Should fix.
- **NITPICK / MEDIUM or lower** → NITPICK. Optional.
- If both reviewers flag the same issue → group under one finding, note it was flagged twice.

### 4. Output

```
=== CODE REVIEW ===

Branch: [branch name]
Files changed: [count]
Reviewed by: architecture-reviewer + security-reviewer

--- CRITICAL (must fix before merge) ---
[file:line] Issue description
Why: [why this matters]
Fix: [specific change]

--- CONCERN (should fix) ---
[same format]

--- NITPICK (optional) ---
[same format]

--- VERDICT: APPROVED / NEEDS CHANGES ---
[One sentence summary]
```

If nothing critical is found, say so directly. Don't manufacture concerns to look thorough.

## Rules

- Point to the exact file and line — never "the service has issues"
- Explain why something is wrong, not just that it's wrong
- Separate logic problems from style problems — linters handle style
- If the code is well-written, say so
