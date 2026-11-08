---
name: review-checklist
description: Structured review of a code diff against correctness, security, resilience, readability, and diff-size standards, producing severity-ranked findings. Use when reviewing changes before they reach a human or a pull request.
---

# Review Checklist

Review the **diff** against the brief and plan. Report findings. Do not fix them.

## Severity
- **BLOCKING**: must be fixed before the human sees it. This covers bugs,
  security issues, failing or missing tests for new behavior, scope violations,
  and a broken acceptance criterion.
- **SHOULD**: real improvements to make in this change if they're cheap
  (readability, resilience gaps).
- **NIT**: optional. Never block on these. Leave them out entirely in
  bug-fix reviews.

## Checks, in priority order
1. **Correctness.** Does the change satisfy every acceptance criterion in the
   brief? Look at edge cases: empty, null, huge, concurrent, and unicode inputs,
   and time zones.
2. **Security.** Apply the `secure-resilient-code` skill: injection, authz,
   secrets, input validation.
3. **Resilience.** Look for timeouts, error handling, resource cleanup, and
   retries that are only applied to idempotent operations.
4. **Tests.** New behavior has tests, bug fixes have regression tests, and the
   tests assert behavior rather than implementation.
5. **Scope and diff size.** Every changed line serves the brief. Bug fixes
   follow `minimal-diff`. Flag drive-by changes as BLOCKING in bug fixes and as
   SHOULD elsewhere.
6. **Readability.** Apply `clean-code`: names, structure, consistency with the
   codebase, and no dead code.

## Output format

```markdown
## Verdict: PASS | CHANGES_REQUIRED

### BLOCKING
1. `path/file.ext:42`: <problem>. **Why:** <impact>. **Fix:** <concrete direction>.

### SHOULD
...

### NIT
...

### Verified
- <what you checked and found fine, briefly>
```

Be specific and concrete: give the file, the line, the failure scenario, and
the fix direction. If you're unsure whether something is a bug, say so and
explain what would confirm it.
