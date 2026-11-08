# Working Agreement (AgentFramework)

## Engineering principles
Apply these skills whenever you write or review code:
- `clean-code`: readable code that matches the codebase.
- `secure-resilient-code`: validate input, put timeouts on all I/O, keep
  secrets out of code and logs.
- `minimal-diff`: **bug fixes use the smallest diff that fixes the root
  cause**, plus a regression test. No drive-by changes.

## How work flows
1. **Intake.** Explore the repo first, then ask me **all** clarifying questions
   in one batch, each with a recommended default (`intake` skill). Write the
   brief to `.agent-work/<slug>/brief.md` and get my "go".
2. **Autonomous loop.** Plan, then implement, verify, and review each task
   until it passes. Don't ask me questions mid-loop. Decide, and log the
   decision in `.agent-work/<slug>/log.md`. Stop only for destructive actions,
   secrets, or a brief that is wrong.
3. **Approval gate.** Work on an `agent/<slug>` branch with local commits.
   **Never push or open a PR without my explicit approval** (`pr-handoff`
   skill). Never merge.

## Roles and model tiers
| Agent | Tier | Job |
|---|---|---|
| `scout` | low | Read-only discovery. Returns condensed facts. |
| `architect` | high | Plans and designs. |
| `implementer` | mid | Codes exactly one planned task. |
| `reviewer` | high | Quality and security gate. |
| `lead` | mid | Runs intake, the loop, and the handoff. |
