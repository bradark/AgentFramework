# Separation of Duties and Model Tiering

Each role is assigned to the **cheapest model tier that can do its job well**.
Expensive models only do work where judgment matters.

| Role | Tier | Claude model | Why this tier |
|---|---|---|---|
| **scout**: discovery, file mapping, fact-finding | Low | `haiku` | High volume of reading; needs recall, not judgment |
| **verifier**: runs build/lint/tests, reports results | Low | `haiku` | Mechanical work; reports facts only |
| **implementer**: writes code against a plan | Mid | `sonnet` | Strong at coding when the design is already decided |
| **architect**: plans, designs, re-plans when stuck | High | `opus` | Deep reasoning, trade-offs, decomposition |
| **diagnostician**: root-causes bugs | High | `opus` | Hypothesis-driven reasoning over the evidence |
| **reviewer**: quality and security gate | High | `opus` | The last line of defense before the human |
| **orchestrator**: the main session that runs the skill | Mid (recommended) | `sonnet` | Coordination only; it delegates thinking upward and reading downward |

## Rules of thumb

1. **Information flows up and gets condensed.** Scouts return short, structured
   facts, never raw file dumps. This keeps the high-tier context small and cheap.
2. **Decisions flow down and get frozen.** The architect's plan is the contract.
   The implementer doesn't redesign, and if the plan is wrong it reports back.
3. **High-tier models never do grunt work.** If an Opus agent is searching for
   files, a scout should have done it first.
4. **Spend more where a mistake costs more.** Review and diagnosis use the high
   tier, because a missed bug is more expensive than the extra tokens.

## Changing the mapping

- **Claude:** edit the `model:` field in each file under
  `claude/agents/*.md`. Accepted values: `haiku`, `sonnet`, `opus`, `inherit`,
  or a full model ID.
- **Copilot:** edit the `model:` field in each file under
  `copilot/agents/*.agent.md`. Use the display name exactly as it appears in
  your Copilot model picker.
