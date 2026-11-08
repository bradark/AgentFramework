# The Delivery Workflow

Every piece of work, from a feature to a bug fix, moves through five phases. Work
stops for the human at only two points: **Intake** at the start and **Approval**
at the end. Everything in between runs in autonomous loops.

```
 ┌──────────┐   ┌───────────┐   ┌────────┐   ┌──────────────────────────┐   ┌───────────┐
 │ 1 Intake │──▶│ 2 Discover│──▶│ 3 Plan │──▶│ 4 Build loop (autonomous)│──▶│ 5 Approval│──▶ PR
 │  (human) │   │   (cheap) │   │ (deep) │   │ implement→verify→review  │   │  (human)  │
 └──────────┘   └───────────┘   └────────┘   └──────────────────────────┘   └───────────┘
```

## 1. Intake: ask everything up front

- First, run a quick **discovery pass** so the questions are informed and don't
  ask the human for things the code already answers.
- Then ask **all** the questions in one batch. Ask only what matters: scope,
  acceptance criteria, constraints, and anything that can't be undone.
- Offer a recommended default for every question so the human can just accept it.
- Write the answers to `brief.md`. The human confirms the brief, and from that
  point on the work runs autonomously.

See the [`intake`](../skills/intake/SKILL.md) skill.

## 2. Discover: cheap and parallel

The low-cost tier maps the territory: relevant files, conventions, the test and
build commands, and prior art. It produces facts only, with no opinions or design.

## 3. Plan: deep thinking, done once

The high-end tier turns the brief and the discovery facts into `plan.md`, an
ordered checklist of small tasks. Each task lists:
- the files it touches
- what "done" means for it
- how it will be verified

## 4. Build loop: autonomous

```
for each task in plan.md:
    attempt = 0
    loop:
        implementer (mid tier)  → makes the change
        verifier    (low tier)  → runs build/lint/tests, reports facts
        reviewer    (high tier) → checks the diff against the principles
        if verifier passes and reviewer has no BLOCKING findings: mark task done, break
        attempt += 1
        if attempt == 3: send the task back to the architect to re-plan it
        if attempt == 5: mark the task BLOCKED, record why, move on to independent tasks
```

Rules while in the loop:
- **Do not ask the human.** Make the call the brief points toward, and record
  it under *Autonomous decisions* in `log.md`.
- **Exceptions that still require stopping:** a destructive or irreversible
  action, a need for credentials or secrets, or a discovery that the brief
  itself is wrong (the scope would have to change).
- **Commit locally after each finished task** on the `agent/<slug>` branch.
  Local commits are cheap to review and easy to undo.
- **Never push, open a PR, or merge** during the loop.

## 5. Approval: the human gate

The orchestrator writes `handoff.md`. It contains:
- a summary of the change
- the diff stats
- how the change was verified
- the autonomous decisions that were made
- known gaps and BLOCKED tasks

The human then reviews the branch and either approves, which runs `/ship` to
push and open the PR, or sends feedback, which goes back into the loop.

The gate is enforced twice: by the instructions in the skills, and by
permission rules that **require a human prompt** for `git push` and
`gh pr create` (see [`claude/settings.json`](../claude/settings.json)).

## State on disk

Loops persist their state to disk, which lets them survive context compaction
and restarts:

```
.agent-work/<slug>/
  brief.md     # intake output: goal, acceptance criteria, constraints (human-approved)
  plan.md      # ordered task checklist  [ ] / [x] / [BLOCKED]
  log.md       # one entry per loop iteration + autonomous decisions
  review.md    # latest reviewer findings
  handoff.md   # what the human reads at the approval gate
```

`.agent-work/` is git-ignored in target repos. The installer adds it to `.gitignore`.
