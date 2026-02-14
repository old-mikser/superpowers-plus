# Superpowers-Plus Install/Uninstall Docs Design

## Goal
Align installation with upstream Superpowers while adding a minimal step to create OpenCode subagents, and provide a full uninstall guide for superpowers-plus.

## Scope
- Modify `.opencode/INSTALL.md` to add one extra step: run `./install.sh` from the repo root.
- Add `.opencode/UNINSTALL.md` with full removal instructions for superpowers-plus.
- No detection or migration of existing Superpowers installs.

## Architecture
- Keep upstream install steps intact and append the new step.
- Uninstall guide removes:
  - `~/.config/opencode/skills/superpowers` symlink or folder
  - `~/.config/opencode/superpowers` repo clone (or installed path)
  - `~/.config/opencode/agents/sp-*.md`

## Components
- `.opencode/INSTALL.md`: add `./install.sh` step and a short note about running from repo root.
- `.opencode/UNINSTALL.md`: new uninstall instructions.

## Data Flow
1. User/agent follows `.opencode/INSTALL.md`.
2. Standard Superpowers steps run.
3. Final step runs `./install.sh` to create `sp-*` agents.

## Error Handling
- If `./install.sh` fails (missing prompt paths or wrong working directory), rerun it from the repo root.

## Testing Plan
- Follow `.opencode/INSTALL.md` in a clean environment.
- Verify `sp-*` agents exist in `~/.config/opencode/agents/`.
- Follow `.opencode/UNINSTALL.md` and confirm removal.
