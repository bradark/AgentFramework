---
description: Minimal-diff bug fix - reproduce, root-cause, smallest correct fix plus regression test, human approval before PR.
agent: lead
---

Fix this bug following the `minimal-diff` skill:
1. Explore read-only, then ask me any questions in **one** batch, and only the
   ones the code can't answer.
2. Write a failing regression test that reproduces the bug.
3. Find the **root cause**, not the symptom.
4. Apply the **smallest diff** that fixes the root cause. No refactors,
   renames, or reformatting. List those as follow-up suggestions instead.
5. Verify, then review the change in bug-fix mode, looping until it passes.
6. Hand off with `git diff --stat`, the root cause, and the regression test
   name. Wait for my approval before pushing or opening a PR.

Bug: ${input:bug:Describe the bug, error, or failing test}
