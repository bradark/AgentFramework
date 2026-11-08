---
name: clean-code
description: Standards for writing clean, readable, maintainable code. Use whenever writing, modifying, or reviewing code in any language.
---

# Clean, Readable Code

The aim is code that the next reader understands on the first pass. That next
reader is often you or another agent, with no context.

## Match the codebase first
- Follow the conventions already in the repo: naming, formatting, file layout,
  error-handling style, and test style. **Consistency beats your personal preference.**
- Use the project's existing helpers, utilities, and dependencies before writing
  new ones. Search before you write.
- Run the project's formatter and linter. Don't hand-format.

## Naming
- Names say *what* something is or does, not *how*. `unpaidInvoices`, not `filteredList2`.
- Booleans read as questions: `isExpired`, `hasAccess`, `shouldRetry`.
- Functions are verbs: `calculateTotal`, `loadConfig`.
- Avoid abbreviations unless they are universal in the domain (`id`, `url`, `http`).

## Structure
- **One job per function.** If you need "and" to describe it, split it.
- Keep functions short enough to see at once. As a rule of thumb, more than
  about 40 lines is a smell, not a law.
- **Return early** with guard clauses instead of nesting. Aim for at most about
  3 levels of indentation.
- Keep each function at one level of abstraction. Don't mix orchestration with
  bit-twiddling.
- Make illegal states unrepresentable where the type system allows it.

## Simplicity
- Write the simplest thing that meets the requirement. **No speculative
  generality**: no abstractions, options, or extension points nobody has asked for.
- Three similar lines are better than a premature abstraction. Extract at the
  third real repetition.
- Delete dead code. Don't comment it out, because git remembers it.
- No clever one-liners that need a comment to decode.

## Comments
- Explain **why**, never **what**. The code already says what.
- Good comments cover non-obvious constraints, workarounds (with a link to the
  bug or ticket), and the reason a simpler-looking approach was rejected.
- Keep public API docs (docstrings, JSDoc) accurate. A wrong comment is worse
  than none.

## Tests
- Name each test after the behavior: `returns_empty_list_when_no_matches`.
- Use the Arrange / Act / Assert layout, and test one behavior per test.
- Test behavior through public interfaces, not implementation details.

## Self-check before you finish
- [ ] Would a newcomer understand this without asking me?
- [ ] Did I reuse what already exists instead of reinventing it?
- [ ] Is there anything here that isn't needed for the requirement?
- [ ] Do the formatter and linter pass?
