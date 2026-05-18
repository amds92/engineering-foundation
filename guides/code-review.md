# Code Review

How to give and receive code reviews. Inspired by Thoughtbot's guide and 37signals' PR culture.

## Why code review matters

From 37signals: "PRs are how coding standards transmit to new team members. Culture is built through reviews, not documents."

A code review is not a gatekeeping exercise. It's a knowledge transfer, a quality check, and an opportunity to make the codebase better than you found it.

## As a reviewer

### What to look for

**Logic and correctness**
- Does this do what it claims to do?
- Are there edge cases not handled?
- Is error handling present and correct?

**Architecture**
- Is this in the right place?
- Does this follow the patterns of this codebase?
- Is there duplication that could be avoided?

**Naming and clarity**
- Would a new team member understand this in 6 months?
- Are variables, functions, and classes named for what they ARE, not what they DO?

**Tests**
- Do the tests cover the new behaviour?
- Do the tests cover failure cases?
- Are the tests testing behaviour, not implementation?

### How to phrase feedback

Frame as questions, not commands. From Thoughtbot's guide:

> "What do you think about naming this `:user_id`?"

is better than

> "Rename this to `:user_id`"

The difference: one invites a conversation, the other creates friction.

Label your feedback:
- **Blocker:** This must change before merge
- **Suggestion:** I'd do it this way, but it's your call
- **Nitpick:** Minor style thing, feel free to ignore
- **Question:** I don't understand this, help me

**Acknowledge what's good.** If someone wrote something clever or clean, say so. Positive feedback is part of review culture.

### What NOT to review

- **Style** — linters handle this. Don't comment on indentation or quote style if a linter is configured.
- **Preferences** — "I'd use a different variable name" without a clear reason isn't a review, it's noise.

## As an author

### Before opening a PR

- Run the linter — fix everything it flags
- Run the tests — all must pass
- Review your own diff — read it like you're reviewing someone else's code
- Keep it small — one concern per PR

### Receiving feedback

- Read every comment before responding to any
- Don't be defensive — every comment is an opportunity to improve
- Ask for clarification if a comment is unclear — don't guess what they meant
- If you disagree, explain why — a PR comment thread is a technical discussion, not a hierarchy

### Merging

- Respond to every comment (even if just "done" or "acknowledged")
- Get at least one approval before merging
- Squash fixup commits — keep the history clean

## The nitpick principle

From 37signals: "Treat nitpicking as meticulous rigor, not pedantry."

Three things are always worth scrutinizing, no matter how small:
1. **Naming** — names outlive implementations
2. **Consistency** — the most maintainable codebase is the one that looks like one person wrote it
3. **Edge cases** — "what happens when this is null?"

A nitpick caught in review costs 30 seconds. The same issue found in production costs hours.
