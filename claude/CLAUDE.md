# Working Agreement (AgentFramework)

## Engineering principles
- Write clean, readable code that matches the existing codebase. See the
  `clean-code` skill.
- Write secure, resilient code: validate input at boundaries, put timeouts on
  all I/O, and never put secrets in code or logs. See `secure-resilient-code`.
- **Bug fixes use the smallest diff that fixes the root cause**, plus a
  regression test. No drive-by changes. See `minimal-diff`.

## How work flows
- For non-trivial work, use `/deliver <request>`. For bugs, use `/fix-bug <bug>`.
- Ask all clarifying questions **up front**, in one batch with recommended
  defaults. After the brief is confirmed, work autonomously in loops and don't
  interrupt me except for destructive actions, secrets, or a brief that is
  wrong.
- Delegate by tier: `scout`/`verifier` (haiku) for discovery and checks,
  `implementer` (sonnet) for code, `architect`/`diagnostician`/`reviewer`
  (opus) for thinking.
- Keep loop state in `.agent-work/<slug>/` (brief, plan, log, review, handoff).

## Human approval gate
- Work happens on `agent/<slug>` branches, with local commits only.
- **Never push, open a PR, or merge without my explicit approval for that
  specific work.** Present `handoff.md` and wait. I approve with `/ship`.
