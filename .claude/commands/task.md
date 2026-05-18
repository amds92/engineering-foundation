# Task

Load context and prepare to work on a task like a senior engineer.

## What this does

This is the entry point for any piece of work. It ensures Claude understands the project deeply before writing a single line of code. A Claude that starts coding without context is a junior. This command makes it a senior.

## Steps

### 1. Load project context
Read `CLAUDE.md` in the project root. If it doesn't exist, stop and say:
> "No CLAUDE.md found. Copy the template from engineering-foundation and fill it in before starting work. Run: `cp ~/engineering-foundation/templates/CLAUDE.md.template ./CLAUDE.md`"

### 2. Understand the task
The task description is provided as the argument to this command (e.g. `/task Fix pagination bug in users endpoint`).

If the task is vague or ambiguous, ask clarifying questions before proceeding:
- What is the expected behaviour?
- What is the current (broken) behaviour?
- Is there a ticket, issue, or spec to reference?
- Any constraints (performance, backwards compatibility, deadlines)?

Do not assume. Ask once, clearly.

### 3. Explore relevant code
Based on the task, read the relevant files:
- The files most likely to change
- Related tests
- Any service, model, or controller touched by this task
- Check for existing similar patterns — never duplicate logic that already exists

### 4. Define the plan (brief)
Before creating a branch, state clearly:
- What files will change
- What pattern will be followed (service object, concern, background job, etc.)
- What tests will be written
- Any risks or unknowns

### 5. Create the branch
Run `/branch` automatically with a name derived from the task.

## Output

End with a clear summary:

```
Task: [task title]
Branch: [branch name]
Files to change: [list]
Pattern: [what architecture pattern]
Tests: [what will be tested]
Ready to code.
```

## Rules

- Never start coding without reading CLAUDE.md first
- Never duplicate logic — always search for existing implementations
- If the task requires a service object, background job, or cron — say so explicitly before starting
- If the task touches an external service (API, database, queue) — identify the correct client/adapter to use
