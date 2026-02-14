# Superpowers Multi-Model Fork Design

## Goal
Enable per-subagent model selection in a Superpowers fork for OpenCode, while keeping installation simple and deterministic.

## Scope
- OpenCode only.
- Modify Superpowers skills that dispatch subagents to use explicit @agent names.
- Provide a single installer that configures OpenCode agents automatically.

## Architecture
- Fork `obra/superpowers` and edit skill files directly.
- Dispatch subagents via explicit names (e.g., `@sp-implementer`, `@sp-spec-reviewer`).
- OpenCode `opencode.json` defines those agents and their models.
- No runtime preprocessing or plugin hooks.

## Components
- `skills/subagent-driven-development/SKILL.md`:
  - Replace dispatch text with explicit @agent names for implementer and reviewers.
- `skills/dispatching-parallel-agents/SKILL.md`:
  - Update example snippets to use @agent names.
- `skills/requesting-code-review/SKILL.md` (optional):
  - Note the reviewer agent name used by the fork for clarity.
- `install.sh` (new):
  - Runs base Superpowers install steps.
  - Adds/updates `agent` entries in `~/.config/opencode/opencode.json`.
  - Idempotent and non-destructive to unrelated config.

## Data Flow
1. User installs the fork.
2. User runs `./install.sh`.
3. Script ensures `~/.config/opencode/opencode.json` exists.
4. Script adds/updates `sp-*` agent entries (defaults to main model).
5. Skills dispatch `@sp-*` agents with existing prompt templates.

## Error Handling and Edge Cases
- If `opencode.json` is missing, `install.sh` creates a minimal config.
- If `opencode.json` is invalid JSON, `install.sh` aborts with a clear error.
- Existing config remains intact; only `sp-*` agents are added/updated.
- Running `install.sh` multiple times is safe and idempotent.

## Testing Plan
- Run `install.sh` with no existing `opencode.json`.
- Run `install.sh` with an existing config and verify:
  - JSON remains valid
  - unrelated providers/agents preserved
  - `sp-*` agents inserted/updated
- Smoke test a Superpowers skill that dispatches `@sp-implementer`.

## Open Questions (Resolved)
- No runtime plugin hooks for skill preprocessing in OpenCode.
- Fork is the correct approach with a single installer.
