---
name: ship
description: After the human has explicitly approved reviewed work, push the agent branch and open a pull request. Never merges.
disable-model-invocation: true
argument-hint: "[slug]"
---

# /ship: Push and Open a PR (Requires Approval)

Running `/ship` counts as the user's approval for **this** work only.

1. Find the work: use `$ARGUMENTS` as the slug if given. Otherwise use the
   most recent `.agent-work/*/handoff.md`. If it's ambiguous, ask.
2. **Pre-flight checks.** Abort and report if any of them fail.
   - The current branch is `agent/<slug>`, and the working tree is clean.
   - The **`verifier`** passes on the full suite.
   - `handoff.md` exists and matches the branch, meaning there are no commits
     after the handoff that the user hasn't seen. If there are, show them and
     ask again.
3. Push with `git push -u origin agent/<slug>`. The user's permission settings
   will prompt for this, which is intended.
4. Build the PR body from `handoff.md`: what, why, how it was verified,
   autonomous decisions, and follow-ups. End it with:
   `🤖 Generated with [Claude Code](https://claude.com/claude-code)`
5. Run `gh pr create --base <base> --head agent/<slug> --title "<title>" --body-file .agent-work/<slug>/pr-body.md`.
   If `gh` is unavailable, print the GitHub compare URL instead.
6. Report the PR URL. **Do not merge, and do not request auto-merge.**
