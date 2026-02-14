#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$HOME/.config/opencode/agents"

mkdir -p "$AGENTS_DIR"

create_agent() {
  local name="$1"
  local description="$2"
  local prompt_path="$3"
  local description_escaped

  local agent_file="$AGENTS_DIR/${name}.md"
  if [ -f "$agent_file" ]; then
    echo "[install] Agent already exists: $agent_file"
    return 0
  fi

  if [ ! -f "$prompt_path" ]; then
    echo "[install] Prompt not found: $prompt_path" >&2
    exit 1
  fi

  description_escaped=${description//\"/\\\"}

  cat > "$agent_file" <<EOF
---
description: "${description_escaped}"
mode: subagent
prompt: "{file:${prompt_path}}"
tools:
  write: true
  edit: true
  bash: true
---
EOF

  echo "[install] Created agent: $agent_file"
}

create_agent "sp-implementer" "Implements tasks using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/implementer-prompt.md"
create_agent "sp-investigator" "Investigates independent issues in parallel" "$REPO_ROOT/skills/dispatching-parallel-agents/investigator-prompt.md"
create_agent "sp-spec-reviewer" "Reviews spec compliance using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/spec-reviewer-prompt.md"
create_agent "sp-code-quality-reviewer" "Reviews code quality using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/code-quality-reviewer-prompt.md"
create_agent "sp-final-reviewer" "Final end-to-end review using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/final-reviewer-prompt.md"

echo "[install] Done. Edit agent files to set per-agent models if desired."
