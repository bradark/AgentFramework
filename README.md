# AgentFramework

A personal framework of AI **agents** and **skills** for software
work. It has two layers:

- **Portable skills** in the open Agent Skills format (`SKILL.md`), usable by
  GitHub Copilot, Claude Code, and other tools that support the format.
- **Platform-specific teams** for Claude Code and Copilot, where each role is
  pinned to the model tier that suits it.

## Core ideas

| # | Principle | Where it lives |
|---|---|---|
| 1 | Clean, readable code | [`skills/clean-code`](skills/clean-code/SKILL.md) |
| 2 | Resilient, secure code | [`skills/secure-resilient-code`](skills/secure-resilient-code/SKILL.md) |
| 3 | Bug fixes use the smallest diff that fixes the root cause | [`skills/minimal-diff`](skills/minimal-diff/SKILL.md) |
| 4 | Separation of duties and model tiering | [`docs/model-tiering.md`](docs/model-tiering.md) |
| 5 | Ask everything up front, then loop autonomously | [`skills/intake`](skills/intake/SKILL.md), [`docs/workflow.md`](docs/workflow.md) |
| 6 | The human approves before any PR | [`skills/pr-handoff`](skills/pr-handoff/SKILL.md), [`claude/settings.json`](claude/settings.json) |

## The team

```
           ┌─────────────── orchestrator (main session, sonnet) ───────────────┐
           │                                                                   │
  scout ×N (haiku)    architect (opus)   implementer (sonnet)   verifier (haiku)   reviewer (opus)
  discovery           plan / re-plan     code one task          build/lint/test    quality+security gate
                      diagnostician (opus): bug root cause
```

**Flow:** Intake (human) → Discover → Plan → **Loop:** implement → verify →
review → Handoff → **Human approves** → PR. See [docs/workflow.md](docs/workflow.md).

## Repo layout

```
skills/            Portable skills (Agent Skills standard): principles + workflow steps
claude/
  agents/          Claude Code subagents (scout, architect, implementer, verifier, reviewer, diagnostician)
  skills/          Claude orchestration skills: /deliver, /fix-bug, /ship
  settings.json    Permission rules: push/PR require a human prompt; force-push denied
  CLAUDE.md        Working agreement (user- or project-level memory)
copilot/
  agents/          Copilot custom agents (*.agent.md) with model + handoffs
  prompts/         Copilot prompt files: /deliver, /fix-bug
  copilot-instructions.md
docs/              Workflow and model-tiering design
scripts/install.ps1
```

## Install

```powershell
# Claude Code: available in every project
.\scripts\install.ps1 -Target ClaudeUser

# Claude Code: a single repo (commit .claude/ so it travels with the repo)
.\scripts\install.ps1 -Target ClaudeProject -Repo ..\SomeRepo

# GitHub Copilot: a single repo
.\scripts\install.ps1 -Target Copilot -Repo ..\SomeRepo
```

The installer copies files and skips existing ones unless you pass `-Force`.
Re-run it after updating the framework.

## Usage

**Claude Code**
- `/deliver add rate limiting to the public API`: the full workflow.
- `/fix-bug login fails when email has a plus sign`: the minimal-diff bug flow.
- `/ship`: after you've reviewed the handoff, push and open the PR.

Tip: run the main session on Sonnet (`/model sonnet`). The subagents pick
their own tiers.

**Copilot (VS Code)**
- Select the **lead** agent, or run the `/deliver` or `/fix-bug` prompt.
- Use the handoff buttons (*Plan with Architect* → *Start implementation* →
  *Review changes*) to move between tiers.
- Check the `model:` names in `copilot/agents/*.agent.md` against your Copilot
  model picker. Display names change over time.

## Prerequisites
- `git`
- [`gh`](https://cli.github.com/), for opening PRs. Without it, `/ship` prints
  a compare URL instead.

## Extending
- **A new principle or reusable procedure** → add `skills/<name>/SKILL.md`,
  which works in both tools. Give it a precise `description`, since that's how
  agents decide when to load it.
- **A new Claude role** → add `claude/agents/<name>.md` with `model:` set to
  the cheapest tier that can do the job, and preload the relevant skills via
  `skills:`.
- **A new Copilot role** → add `copilot/agents/<name>.agent.md`.
