---
name: intake
description: Question-first intake that gathers every requirement up front so the rest of the work can run autonomously. Use at the start of any non-trivial task before planning or writing code.
---

# Intake: Ask Everything Up Front

Spend a few minutes of the human's time now so the next few hours run without
interruptions. **After intake, the agents should not need to ask the human
anything else.**

## Steps

1. **Discover before asking.** Do a quick read-only pass to understand the
   context: the relevant files, the stack, conventions, and the test and build
   commands. Never ask something the repo can answer.

2. **Ask all your questions in one batch.** Ask only questions whose answers
   change what gets built. Cover the categories below as they apply.

   | Category | Example |
   |---|---|
   | Goal | What problem does this solve, and for whom? |
   | Scope | What is explicitly *out* of scope? |
   | Acceptance | How will we know it's done? What behavior and which tests? |
   | Constraints | Performance, compatibility, dependencies we can or can't add |
   | Interfaces | API shape, UI behavior, data formats, migrations |
   | Risk | Is anything destructive or irreversible (data, infra, public API)? |
   | Autonomy | Is it OK to add dependencies, change schemas, or touch shared config? |
   | Delivery | Branch name, PR target branch, reviewers |

   - Give **each question a recommended default**, so that "go with your
     defaults" is a valid answer.
   - Prefer multiple-choice options over open-ended questions.
   - In Claude Code, use the `AskUserQuestion` tool, with up to 4 questions per
     call. Chain calls if you need more, but keep the total small (about 4–10).

3. **Write the brief** to `.agent-work/<slug>/brief.md`:

   ```markdown
   # Brief: <title>
   ## Goal
   ## In scope
   ## Out of scope
   ## Acceptance criteria   (numbered, testable)
   ## Constraints
   ## Decisions from intake (question → answer)
   ## Pre-authorized autonomous actions
   ## Requires human (stop and ask if hit)
   ```

4. **Get explicit confirmation** of the brief. After that, go autonomous.

## Anti-patterns
- Asking questions one at a time, spread across the session.
- Asking about naming, style, or file layout. The codebase already answers those.
- Asking for permission on things already pre-authorized in the brief.
