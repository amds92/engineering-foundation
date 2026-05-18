# Engineering Foundation

This is a language-agnostic engineering operating system for serious developers.

## What this repo is

A collection of:
- **Slash commands** — workflow automation for Claude Code
- **Guides** — engineering principles based on Thoughtbot, 37signals, Shopify, and GitHub practices
- **Templates** — CLAUDE.md template, PR template

## How to use it in a new project

```sh
# Copy the CLAUDE.md template to your project
cp templates/CLAUDE.md.template /path/to/project/CLAUDE.md

# Copy the slash commands
cp -r .claude/commands /path/to/project/.claude/commands

# Edit CLAUDE.md with your project specifics
```

## Slash commands

| Command | Phase | What it does |
|---------|-------|-------------|
| `/task` | Define | Load context, clarify scope, prepare to work |
| `/plan` | Plan | Architecture before code |
| `/branch` | Build | Create correctly named branch |
| `/commit` | Build | Semantic commit with verification |
| `/review` | Review | Senior-level code review |
| `/pr` | Ship | Create PR with real description |
| `/ci` | Ship | Check GitHub Actions status |
| `/ship` | Ship | Full gate: review + CI + merge |

## The most important file

`templates/CLAUDE.md.template` — this is what you fill in for each project.

The more context you give Claude in CLAUDE.md, the better it performs. A well-filled CLAUDE.md turns Claude into a senior engineer who knows your codebase. An empty one gives you a generic assistant.

## Requirements

- Claude Code CLI
- GitHub CLI (`gh auth login`)
- Git
