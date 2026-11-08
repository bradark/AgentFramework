---
name: fix-bug
description: Autonomous minimal-diff bug fix - brief intake, cheap evidence gathering, deep root-cause diagnosis, smallest correct fix with a regression test, review, then a human approval gate before any PR. Use when the user reports a bug, regression, or failing test.
disable-model-invocation: true
argument-hint: <bug description, error, or failing test>
---

# /fix-bug: Minimal-Diff Bug Fix

You are the **orchestrator**. The goal is the **smallest diff that fixes the
root cause**, plus a regression test. Follow the `minimal-diff` skill throughout.

Bug: $ARGUMENTS

## 1. Setup and intake
1. Create `.agent-work/<slug>/` and record `<base>`.
2. Launch **`scout` agents in parallel** to find:
   - where the symptom is produced
   - recent commits that touched that area (`git log`)
   - the test command and existing tests for the area
3. Ask the user **one batch** of questions with `AskUserQuestion`, and only the
   ones the scouts couldn't answer:
   - the expected vs. actual behavior, if unclear
   - reproduction steps or environment, if unclear
   - the urgency trade-off: "a minimal patch now, with a proper fix as a
     follow-up?" (recommended default: yes)
4. Write a short `brief.md` and confirm it. **From here on, you are autonomous.**

## 2. Reproduce
1. Create the branch `agent/<slug>`.
2. Have an **`implementer`** write a **failing regression test** that
   reproduces the bug. It must not change any production code.
3. Run the **`verifier`** to confirm the test fails *for the right reason*.
   If it can't be reproduced, loop up to 3 times with more scouting, then
   report to the user.

## 3. Diagnose
Send the bug, the failing test, and the scout evidence to the
**`diagnostician`**. It returns the root cause and a minimal fix spec.

## 4. Fix loop (autonomous)
```
attempt = 1
loop:
  implementer: apply ONLY the diagnostician's minimal fix
  verifier: regression test + surrounding suite + lint
      → FAIL: attempt++; at attempt 3, re-diagnose with the attempt log
  reviewer (bug-fix mode: minimal-diff strictly enforced, drive-bys are BLOCKING)
      → CHANGES_REQUIRED: attempt++
      → PASS: commit "fix: <summary>"; break
  attempt 5 → stop and report to the user with findings
```
Log every iteration to `log.md`.

## 5. Approval gate
Follow `pr-handoff`. The handoff **must** include:
- `git diff --stat <base>...HEAD`
- the root cause, in one paragraph
- the regression test name
- any *follow-up suggestions*: the refactors you deliberately did not do

Then **stop** and wait for approval. On approval, follow `/ship`.
