---
name: pr-handoff
description: Human approval gate - prepares a review handoff, waits for explicit human approval, and only then pushes and opens a pull request. Use when autonomous work is complete, or when asked to open a PR.
---

# PR Handoff: The Human Approval Gate

**Nothing is pushed and no PR is opened without explicit human approval in the
current conversation.** Approval given for an earlier piece of work doesn't
carry over.

## Step 1: Prepare the handoff (no approval needed)

Write `.agent-work/<slug>/handoff.md` and show it to the human:

```markdown
# Ready for review: <title>
**Branch:** agent/<slug>  →  **Target:** <base branch>
**Diff:** <N files, +X / -Y>   (from `git diff --stat <base>...HEAD`)

## What changed and why
## Acceptance criteria
- [x] 1. ... (verified by: <test / command>)
## How it was verified
## Autonomous decisions made   (decision → reason)
## Known gaps / BLOCKED tasks / follow-up suggestions
## How to review
- `git diff <base>...agent/<slug>`
- Areas that deserve the closest look: ...
```

Then ask: **"Approve opening a PR, or send feedback?"**

## Step 2: Wait

- **Feedback:** return to the build loop with the feedback as new review
  findings, then come back to Step 1.
- **Approval:** an explicit "approve", "ship it", "yes, open the PR", or
  similar. Silence, or an ambiguous reply, is **not** approval.

## Step 3: Ship (only after approval)
1. Make sure the working tree is clean and all tests pass one more time.
2. Run `git push -u origin agent/<slug>`.
3. Open the PR with the `gh` CLI. If `gh` isn't installed, give the human the
   compare URL instead.

   ```
   gh pr create --base <base> --head agent/<slug> --title "<title>" --body-file <file>
   ```

   The PR body is the handoff, trimmed down: what, why, how it was verified,
   and the follow-ups.
4. Report the PR URL. **Never merge.** Merging is the human's call.
