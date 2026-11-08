# Contributing to AgentFramework

Instructions for AI agents (and humans) editing **this** repo.

- **Portable first.** If a rule applies to any tool, it belongs in `skills/`.
  Platform folders (`claude/`, `copilot/`) only contain role wiring and
  platform-specific orchestration.
- **One source of truth.** Don't copy principle text into agent files.
  Reference the skill by name instead.
- **Skill descriptions are triggers.** Agents decide whether to load a skill
  based on its `description`. Say what the skill does *and when to use it*.
- **Tier deliberately.** Every agent gets the cheapest model that can do its
  job. Explain any change in `docs/model-tiering.md`.
- **Keep the human gate intact.** No skill or agent may push, open a PR, or
  merge without explicit human approval.
- When adding or renaming files, update the layout and tables in `README.md`.
