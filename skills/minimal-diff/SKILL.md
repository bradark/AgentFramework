---
name: minimal-diff
description: Discipline for fixing bugs with the smallest possible, root-cause-correct diff. Use whenever fixing a bug, regression, or failing test.
---

# Minimal-Diff Bug Fixing

A bug fix should be the **smallest change that removes the root cause**. A
small diff is fast to review, safe to revert, and easy to backport.

## Process
1. **Reproduce first.** Get a failing test, or an exact reproduction command,
   before you touch the code.
2. **Find the root cause, not the symptom.** Ask "why" until you reach the line
   that is actually wrong. A null check that hides a bad upstream value is a
   symptom patch.
3. **Change as few lines as possible at the root cause.**
4. **Add a regression test** that fails without the fix and passes with it.
5. **Verify.** Run the new test, the surrounding test suite, and the linter.

## Hard rules
- **No drive-by changes.** No refactors, renames, reformatting, import
  reordering, or comment cleanup in a bug-fix diff, even when the code is ugly.
  Write them down in the handoff as *follow-up suggestions* instead.
- **Don't reformat touched lines** beyond what the formatter forces.
- **Don't change public signatures** unless the bug is in the signature itself.
- **Don't add dependencies** to fix a bug.
- If the true fix needs a large change, **stop and report it** with options:
  a minimal patch now plus a proper fix later, or the proper fix now. The
  human chooses.

## Smallest is not the same as hackiest
The smallest diff that is *correct at the root cause* wins. A one-line
`try/except: pass` is small, but it is wrong. When choosing between candidate
fixes, prefer the one that:
1. fixes the root cause,
2. touches the fewest lines and files,
3. has the least behavior change outside the bug, and
4. matches existing patterns in the code.

## Self-check
- [ ] Does `git diff --stat` look as small as it reasonably could?
- [ ] Is every changed line necessary for the fix or its test?
- [ ] Is there a regression test that would have caught this?
