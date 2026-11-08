---
name: deliver
description: End-to-end autonomous delivery of a feature or change - question-first intake, cheap discovery, deep planning, an autonomous implement/verify/review loop with tiered subagents, then a human approval gate before any PR. Use when the user wants a feature, change, or multi-step task built.
disable-model-invocation: true
argument-hint: <what you want built>
---

# /deliver: Autonomous Delivery with a Human Gate

You are the **orchestrator**. You coordinate the work and delegate it:
reading goes down to cheap agents and thinking goes up to expensive ones.
**Don't do the scouts' or the architect's work yourself.** The point of the
team is the model tiering (see `docs/model-tiering.md`).

Request: $ARGUMENTS

## Phase 0: Setup
1. Pick a short kebab-case `<slug>` for the work.
2. Create `.agent-work/<slug>/`. Check that `.agent-work/` is in `.gitignore`,
   and if it isn't, tell the user and add it.
3. Record the current branch as `<base>`. Check that the working tree is clean.
   If it isn't, **ask** before going further.

## Phase 1: Intake (the human is present)
1. Launch **2–4 `scout` agents in parallel**, each with one focused question:
   where the relevant code lives, how similar features are built, what the
   build, test, and lint commands are, and what constraints exist (CI config,
   lint rules).
2. Follow the `intake` skill. Ask **all** of your questions up front with
   `AskUserQuestion`, and give a recommended default for each one.
3. Write `brief.md`, show it to the user, and get an explicit "go".
   **This is the last time you ask the user anything until handoff**, except
   for the stop conditions listed below.

## Phase 2: Plan
1. Send the brief and the condensed scout findings to the **`architect`**.
2. If it returns `Needs scouting`, run scouts on those questions and send the
   architect the answers.
3. Save the plan to `plan.md`.
4. Create the branch: `git checkout -b agent/<slug>`.

## Phase 3: Build loop (fully autonomous)
For each unchecked task in `plan.md`, in dependency order:

```
attempt = 1
loop:
  implementer(task, conventions, previous findings)
      → PLAN_ISSUE: send to architect for a re-plan of this task; continue
  verifier(commands)
      → FAIL: findings = failures; attempt++; continue
      → ENV_ISSUE: try one obvious fix (e.g. the documented install step); otherwise BLOCKED
  reviewer(diff of this task, brief, task)
      → CHANGES_REQUIRED: findings = BLOCKING (+ cheap SHOULD); attempt++; continue
      → PASS: commit "<task title>" on agent/<slug>; mark [x]; break
  attempt 3 → architect re-plans this task with the full attempt log
  attempt 5 → mark [BLOCKED] with the reason; move on to independent tasks
```

After every iteration, append to `log.md`:
`T<n> attempt <k>: <implementer status> | <verifier result> | <reviewer verdict> | <next action>`.

**Autonomy rules:**
- Do **not** ask the user. Decide the way the brief points, and log each
  choice under `## Autonomous decisions` in `log.md`.
- **The only stop conditions** are:
  - an action that is destructive or irreversible (deleting data,
    migrations on shared databases, force pushes)
  - a need for credentials or secrets
  - evidence that the brief itself is wrong
  - everything remaining is BLOCKED
- Independent tasks may be implemented by **parallel implementers** only if
  they touch disjoint files.
- Re-read `plan.md` and `log.md` from disk whenever you lose track of the
  state. They are the source of truth.

## Phase 4: Final review
1. Run the **`verifier`** on the full suite.
2. Run the **`reviewer`** on the whole branch: `git diff <base>...HEAD`.
3. Address any BLOCKING findings with the loop above.

## Phase 5: Human approval gate
Follow the `pr-handoff` skill. Write `handoff.md`, present it, and **stop**.
Never push or open a PR until the user explicitly approves. On approval,
the user runs `/ship`, or says "ship it", in which case follow `/ship`.
