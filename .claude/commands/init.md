---
description: Initialize a project's Claude Code environment. Use when starting a new project or onboarding Claude onto an existing one. Generates CLAUDE.md, rules, hooks, settings, and output style — then commits and pushes.
disable-model-invocation: true
---

# Init

Investigate the project, generate the full Claude Code environment, and push to GitHub. Run once per project.

## 1. Explore

Read in parallel:
- Root directory listing
- `README.md`, `docs/` if present
- Dependency manifest: `Gemfile`, `package.json`, `requirements.txt`, `go.mod`, `composer.json`, `Cargo.toml`
- `Dockerfile`, `docker-compose.yml` if present
- CI config: `.github/workflows/`, `.circleci/`, `Jenkinsfile`
- `.env.example` if present
- `git log --oneline -20`

Scan the codebase:
- List `app/`, `src/`, `lib/` directories
- Read 2–3 representative files per major directory
- Find base classes, naming conventions, test patterns

## 2. Hunt for gotchas

While reading, look for:
- Memoized methods that go stale after writes
- Test setup requirements not in README (local services, seeds, env vars)
- `# TODO`, `# FIXME`, `# HACK`, `# WARNING` comments
- `raise NotImplementedError` or `raise "do not use"` markers
- Methods named `legacy_`, `old_`, `deprecated_`
- Divergence from framework conventions

These become the "Things that will bite you" section.

## 3. Security audit

Before touching anything, scan for sensitive files that must never be committed:

```sh
# Check what's already tracked
git ls-files | grep -E "(master\.key|credentials\.yml\.enc|\.env$|\.env\.|id_rsa|id_ed25519|\.pem$|\.p12$|secrets\.(yml|json))"
```

If any appear: remove from tracking immediately.

```sh
git rm --cached <file>
```

Ensure these are in `.gitignore` — add any that are missing:

```sh
for entry in "config/master.key" "config/credentials.yml.enc" ".env" ".env.local" ".env*.local" "*.pem" "*.key" "*.p12" "CLAUDE.local.md" ".claude/settings.local.json" ".claude/mcp-calls.log"; do
  grep -qF "$entry" .gitignore || echo "$entry" >> .gitignore
done
```

## 4. Ask targeted questions

Ask only what the code can't answer. Examples:
- "I see `app/services/` and `app/use_cases/` — which should new business logic go in?"
- "What's the branch naming convention? I see `feature/` and `feat/` in history."
- "Any areas Claude should avoid touching?"

Do not ask what you can read from the code.

## 5. Generate CLAUDE.md

Rules:
- Under 100 lines — every line must answer: "would removing this cause Claude to make mistakes?"
- Specific, not vague: `bundle exec rspec` not "run the tests"
- No standard conventions — don't explain what Rails, REST, or JWT are
- Always include "Things that will bite you"

```markdown
# [Project Name]

[One sentence: what it does.]

## Stack
- Language: [e.g. Ruby 3.3]
- Framework: [e.g. Rails 8.1 API-only]
- Database: [e.g. PostgreSQL]
- Jobs: [e.g. Sidekiq / SolidQueue / none]
- Auth: [e.g. JWT]
- Tests: [e.g. RSpec]
- Lint: [e.g. RuboCop]
- Deploy: [e.g. Kamal]

## Structure
[Only non-obvious things. Skip if it's standard.]
- `app/services/` — business logic only
- `app/clients/` — all external API calls

## Commands
\`\`\`sh
bundle install          # install
bundle exec rspec       # test
bundle exec rubocop     # lint
bin/rails db:create db:migrate
\`\`\`

## Git flow
- Branches: `feat/`, `fix/`, `chore/`, `refactor/`
- Commits: Conventional Commits
- Never push to main directly — PRs only

## Rules
- [Non-obvious rule 1]
- [Non-obvious rule 2]

## IMPORTANT
- [Critical constraint — e.g. "Do NOT touch LegacyPaymentService"]

## Things that will bite you
- [Gotcha 1 found in the code]
- [Gotcha 2 found in the code]
```

## 6. Generate .claude/ files

**`.claude/rules/testing.md`** — scoped to `spec/**/*` or `test/**/*`:
```markdown
---
paths:
  - "spec/**/*"
---
# Testing rules
- [project-specific testing conventions]
```

**`.claude/rules/api.md`** — scoped to controllers/routes:
```markdown
---
paths:
  - "app/controllers/**/*"
  - "config/routes.rb"
---
# API rules
- [project-specific API conventions]
```

**`.claude/output-styles/writing.md`**:
```markdown
# Writing style
- Direct and technical — no filler phrases
- Code first, explanation after only if needed
- Never explain language/framework basics
- Never end with "Let me know if you need anything else"
```

**`.claude/settings.json`** — with hooks for security and linting:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{"type": "command", "command": ".claude/hooks/pre-bash.sh", "timeout": 10}]
    }],
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{"type": "command", "command": ".claude/hooks/post-edit.sh", "timeout": 30}]
    }]
  },
  "permissions": {
    "allow": ["Bash(git *)", "Bash(gh *)", "Bash(ls*)", "Bash(find*)", "Bash(grep*)"]
  }
}
```

Add project-specific permissions (e.g. `"Bash(bundle exec*)"` for Ruby).

**`.claude/hooks/pre-bash.sh`** — blocks commits if sensitive files are staged:
Generate from the template. Make executable: `chmod +x .claude/hooks/pre-bash.sh`

**`.claude/hooks/post-edit.sh`** — runs linter after every file edit:
Generate from the template. Make executable: `chmod +x .claude/hooks/post-edit.sh`

**`CLAUDE.local.md`** stub (gitignored):
```markdown
# Local overrides — DO NOT COMMIT
## My preferences
-
## Local environment notes
-
```

**`specs/feature.md.template`** — feature contract before coding:
```markdown
# Feature: [Name]
## Problem
## Behaviour
- [ ]
## API Contract
## Tests
## Definition of done
- [ ] Tests pass
- [ ] Linter clean
- [ ] PR reviewed
```

## 7. Present for review

Show everything that will be created and ask:
> "Does this look accurate? Anything to add or remove?"

Only write files after confirmation.

## 8. Write files and push

Write all files. Then:

```sh
chmod +x .claude/hooks/pre-bash.sh .claude/hooks/post-edit.sh

git add CLAUDE.md .claude/ specs/ .gitignore
git commit -m "chore: add Claude Code engineering environment"
git push
```

If no remote is configured:
```
⚠️  No remote configured. Add one:
    git remote add origin <url>
    git push -u origin main
```

End with:
```
✅ CLAUDE.md
✅ .claude/rules/testing.md
✅ .claude/rules/api.md
✅ .claude/settings.json  (with PreToolUse security hook + PostToolUse lint hook)
✅ .claude/hooks/pre-bash.sh
✅ .claude/hooks/post-edit.sh
✅ .claude/output-styles/writing.md
✅ CLAUDE.local.md  (gitignored)
✅ specs/feature.md.template
✅ .gitignore updated
✅ Committed and pushed

Run /task to start your first task.
```
