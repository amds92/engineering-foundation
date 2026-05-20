# Getting Started with Engineering Foundation

You have an idea. You want to build it. You want the code to be well-structured, secure, and maintainable — not just "works on my machine."

This guide walks you from zero to a working project, step by step.

---

## What is this?

Engineering Foundation gives Claude Code the behaviour of a senior software engineer. Not just "write this function" — but the full cycle:

- Understands your project before touching anything
- Plans before coding
- Tests before committing
- Reviews for security and architecture flaws before opening a PR
- Merges cleanly, deletes branches, keeps history linear

You describe what you want. Claude figures out how to build it correctly.

---

## What you need

Before starting, install these (one time only):

**1. Claude Code**
```sh
npm install -g @anthropic/claude-code
```
Then open a terminal, run `claude`, and follow the login steps.

**2. GitHub CLI**
```sh
# macOS
brew install gh

# Linux
sudo apt install gh   # or: https://cli.github.com/

# Then authenticate
gh auth login
```
Follow the prompts — it'll open a browser and log you into GitHub.

**3. Git** (almost certainly already installed)
```sh
git --version   # should print git version 2.x
```

That's it. No other tools required.

---

## Installation (5 minutes)

```sh
# 1. Clone the foundation into your home directory
git clone git@github.com:amds92/engineering-foundation.git ~/engineering-foundation

# 2. That's it. You'll copy commands into each project — see below.
```

---

## Starting a brand new project

### Step 1 — Create your project

Create a folder, initialise Git, and push to GitHub.

```sh
mkdir my-app
cd my-app
git init
git branch -M main

# Create the repo on GitHub (will prompt for name and visibility)
gh repo create my-app --public --source=. --remote=origin --push
```

### Step 2 — Add the foundation

```sh
mkdir -p .claude
cp -r ~/engineering-foundation/.claude/commands .claude/commands
```

Your project now has the `/init`, `/task`, `/ship`, and `/review` commands available inside Claude Code.

### Step 3 — Open Claude Code and run `/init`

```sh
claude
```

Inside Claude Code:

```
/init
```

Claude will:
1. Read your project (dependencies, structure, existing code)
2. Scan for any sensitive files that must never be committed
3. Ask you a few targeted questions (project-specific things it can't infer)
4. Generate `CLAUDE.md` — your project's permanent memory
5. Set up hooks that block secret commits and run the linter automatically
6. Deploy specialized security and architecture reviewers
7. Commit everything and push

When it's done you'll see:
```
✅ CLAUDE.md
✅ .claude/rules/testing.md
✅ .claude/settings.json  (with security hook + lint hook)
✅ .claude/hooks/pre-bash.sh
✅ .claude/hooks/post-edit.sh
✅ .claude/agents/security-reviewer.md
✅ .claude/agents/architecture-reviewer.md
✅ Committed and pushed

Run /task to start your first task.
```

You're ready.

---

## Adding the foundation to an existing project

Same process — just start from your existing project folder:

```sh
cd your-existing-project
mkdir -p .claude
cp -r ~/engineering-foundation/.claude/commands .claude/commands
claude
/init
```

`/init` will read your existing code, understand the patterns already in use, and generate configuration that fits — not something generic.

---

## Building a feature: `/task`

This is the main command. Use it for every feature, fix, or chore.

### Format

```
/task [describe what you want in plain English]
```

### Examples

```
/task Add user registration with email and password
/task Fix the bug where deleted users still appear in search results
/task Add rate limiting to the public API endpoints
/task Refactor the payment service to use the new Stripe API
/task Write tests for the authentication module
```

### What happens

Claude will:

1. **Read your `CLAUDE.md`** to understand the project
2. **Restate the task** in one sentence to confirm understanding
3. **Show you a plan** before writing a single line of code:

```
## Plan: Add user registration

**What:** Create POST /users endpoint with email/password validation

**Files to create:**
- app/services/register_user.rb
- spec/services/register_user_spec.rb

**Files to change:**
- config/routes.rb
- app/controllers/users_controller.rb

**Verification:**
- Tests: spec/services/register_user_spec.rb passes
- Linter: clean
- Manual: POST /users with valid params returns 201

Proceed?
```

4. You confirm → Claude executes the full plan
5. Runs tests. If they fail, reads the error, fixes it, retries
6. Runs the linter. Fixes any issues
7. Commits with a semantic message (`feat(users): add registration endpoint`)
8. Runs a security + architecture review before opening the PR
9. Opens the PR on GitHub

You get a link to the PR at the end.

### What you decide, what Claude decides

| You decide | Claude decides |
|-----------|---------------|
| What to build | How to structure the code |
| Whether the plan looks right | Which files to create or change |
| Merge the PR or request changes | How to fix failing tests |
| Architecture choices with real tradeoffs | Environment issues (missing gems, wrong version) |

Claude will only stop and ask you when a **human decision** is genuinely needed. Everything else it handles autonomously.

---

## Merging: `/ship`

When CI is green and you're happy with the PR, run:

```
/ship
```

Claude will:

1. **Self-review** the changes one more time
2. **Check CI** — if any job is failing, it stops and shows you the error
3. **Rebase** onto main for clean linear history
4. **Fast-forward merge** — no ugly merge commits
5. **Delete the branch** (remote + local)

If anything fails, it tells you exactly why and stops. Fix it, run `/ship` again.

---

## The review system

Before every PR, two specialized reviewers run in parallel:

**Architecture reviewer** checks:
- Is the business logic in the right place? (not in controllers, not in models)
- Are there N+1 database queries?
- Is anything over-complicated or duplicated?
- Are the tests testing behaviour, not implementation?

**Security reviewer** checks (based on OWASP):
- Can someone inject SQL or run arbitrary commands?
- Are authorization checks correct? (not just "is logged in" but "can this user access THIS resource")
- Is user input validated before being used?
- Are there secrets or tokens in the code?
- Are passwords stored correctly?

Both use Claude's most capable model (opus). Both report:
- **CRITICAL** — must fix before merge
- **CONCERN** — should fix
- **NITPICK** — optional improvement

A CRITICAL from either reviewer blocks the PR from opening.

You can also run `/review` manually at any time.

---

## Real example: building an API from scratch

Let's say you want to build a small API that tracks GitHub deployments.

```sh
# Create and push the project
mkdir shipmetrics && cd shipmetrics
git init && git branch -M main
gh repo create shipmetrics --public --source=. --remote=origin --push

# Install foundation commands
mkdir -p .claude
cp -r ~/engineering-foundation/.claude/commands .claude/commands

# Open Claude Code
claude
```

```
/init
```

Claude investigates, generates everything, pushes. Now start building:

```
/task Setup Rails 8 API with RSpec, JWT authentication, and PostgreSQL
```

Claude plans → you confirm → Claude builds the full base. Tests pass. PR opened.

```
/task Add POST /repositories endpoint to register a GitHub repository
```

Another plan. Another PR. Clean history, tested, reviewed.

When CI passes:

```
/ship
```

Merged. Branch deleted. On to the next task.

---

## The full cycle, visualised

```
You:    /task Add password reset flow
        ↓
Claude: Here's my plan. [shows plan]. Proceed?
        ↓
You:    Yes
        ↓
Claude: [creates branch]
        [writes code]
        [runs tests → fixes if needed]
        [runs linter → fixes if needed]
        [commits]
        [security review + architecture review in parallel]
        [opens PR]
        ↓
You:    [reviews PR on GitHub]
        [CI passes]
        /ship
        ↓
Claude: [rebases onto main]
        [fast-forward merges]
        [deletes branch]
        ✅ Done
```

---

## FAQ

**Do I need to know how to code?**
You need to understand what you want to build. Claude handles the implementation. But you'll need to review PRs and make judgment calls on architecture.

**What languages and frameworks does this support?**
Any. Ruby on Rails, Node.js, Python (FastAPI/Django/Flask), Go, PHP, Elixir — Claude adapts to whatever it finds in your project.

**What if Claude makes a mistake?**
The plan step is your main checkpoint. Review it before saying yes. The review step catches logic and security problems before the PR is opened. CI catches regressions. `/ship` won't merge if CI is red.

**Can I use this on a project that already has a team?**
Yes. `/init` reads existing conventions and respects them. CLAUDE.md becomes the team's shared context for Claude. Add it to the repo and everyone gets the same Claude behaviour.

**What's `CLAUDE.md`?**
It's the project's memory. Claude reads it at the start of every task. It contains your stack, commands, rules, and "things that will bite you" — the non-obvious gotchas specific to your project. `/init` generates it; you maintain it as the project evolves.

**What's `CLAUDE.local.md`?**
Your personal overrides, gitignored. Put your local environment notes, personal preferences, or temporary instructions there. It doesn't affect other team members.

**Something broke during `/init` — what do I do?**
Run it again. It's safe to re-run. Or open Claude Code and describe the problem — Claude will fix it.

---

## Troubleshooting

**`gh: command not found`**
Install GitHub CLI: https://cli.github.com/

**`Permission denied (publickey)` when pushing**
Your SSH key isn't added to GitHub. Follow: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

**`/init` says "No remote configured"**
```sh
git remote add origin git@github.com:your-username/your-repo.git
git push -u origin main
```

**Claude doesn't find `/task`, `/init`, etc.**
Check that you copied the commands:
```sh
ls .claude/commands/
# Should show: init.md  task.md  ship.md  review.md  ...
```
If the folder is empty, re-run:
```sh
cp -r ~/engineering-foundation/.claude/commands .claude/commands
```

**Tests are failing and Claude can't fix them**
Claude will try several times. If it genuinely can't resolve, it stops and explains exactly what it tried and what the error is. You take over, fix the test issue, then continue.

---

## What's next

Once your project is set up and you've run a few `/task` cycles, you'll have a feel for the rhythm. The main things to keep current:

- **Update `CLAUDE.md`** when you discover new gotchas or change conventions
- **Review PRs carefully** — Claude is very good but you're the one who knows the product
- **Run `/ship` only when CI is green** — this is the only hard rule

That's it. Go build something.
