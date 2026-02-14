# Superpowers Multi-Model Fork Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add model-configurable subagents to a Superpowers fork for OpenCode with a single installer that configures the required agents.

**Architecture:** Update Superpowers skills to dispatch explicit @sp-* subagents. Ship an `install.sh` that creates OpenCode agent definitions (markdown) pointing to the existing prompt templates. Model selection is done by editing those agent files; if no model is specified, OpenCode defaults to the invoking primary agent’s model.

**Tech Stack:** Bash, OpenCode agent markdown config, Superpowers markdown skills.

---

### Task 1: Add installer that creates OpenCode agent files

**Files:**
- Create: `install.sh`
- (Optional) Create: `scripts/templates/sp-implementer.md`
- (Optional) Create: `scripts/templates/sp-spec-reviewer.md`
- (Optional) Create: `scripts/templates/sp-code-quality-reviewer.md`
- (Optional) Create: `scripts/templates/sp-final-reviewer.md`
- Modify: `README.md`

**Step 1: Write the failing test**

Not applicable (no automated test harness). Create a manual verification checklist in the README section you add in this task.

**Step 2: Run test to verify it fails**

Not applicable.

**Step 3: Write minimal implementation**

Create `install.sh` that:

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$HOME/.config/opencode/agents"

mkdir -p "$AGENTS_DIR"

create_agent() {
  local name="$1"
  local description="$2"
  local prompt_path="$3"

  local agent_file="$AGENTS_DIR/${name}.md"
  if [ -f "$agent_file" ]; then
    echo "[install] Agent already exists: $agent_file"
    return 0
  fi

  cat > "$agent_file" <<EOF
---
description: ${description}
mode: subagent
prompt: {file:${prompt_path}}
tools:
  write: true
  edit: true
  bash: true
---
EOF

  echo "[install] Created agent: $agent_file"
}

create_agent "sp-implementer" "Implements tasks using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/implementer-prompt.md"
create_agent "sp-spec-reviewer" "Reviews spec compliance using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/spec-reviewer-prompt.md"
create_agent "sp-code-quality-reviewer" "Reviews code quality using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/code-quality-reviewer-prompt.md"
create_agent "sp-final-reviewer" "Final end-to-end review using Superpowers prompts" "$REPO_ROOT/skills/subagent-driven-development/code-quality-reviewer-prompt.md"

echo "[install] Done. Edit agent files to set per-agent models if desired."
```

Notes:
- The agent files omit `model:` so OpenCode defaults to the invoking agent’s model.
- Users can add `model: provider/model-id` later to any agent file.

**Step 4: Run test to verify it passes**

Run: `bash -n install.sh`
Expected: no output, exit code 0.

**Step 5: Commit**

```bash
git add install.sh README.md
git commit -m "feat: add installer for sp-* agents"
```

---

### Task 2: Update subagent-driven-development to use @sp-* agents

**Files:**
- Modify: `skills/subagent-driven-development/SKILL.md`

**Step 1: Write the failing test**

Not applicable.

**Step 2: Run test to verify it fails**

Not applicable.

**Step 3: Write minimal implementation**

Update dispatch instructions to explicitly mention agent names, for example:

```text
Dispatch @sp-implementer subagent (prompt: ./implementer-prompt.md)
Dispatch @sp-spec-reviewer subagent (prompt: ./spec-reviewer-prompt.md)
Dispatch @sp-code-quality-reviewer subagent (prompt: ./code-quality-reviewer-prompt.md)
Dispatch @sp-final-reviewer subagent for entire implementation
```

Keep all prompt template references intact in the skill text for clarity.

**Step 4: Run test to verify it passes**

Manual check: ensure every “Dispatch … subagent” line references an `@sp-*` agent and no generic dispatch remains.

**Step 5: Commit**

```bash
git add skills/subagent-driven-development/SKILL.md
git commit -m "docs: add explicit sp-* agent dispatch"
```

---

### Task 3: Update dispatching-parallel-agents examples

**Files:**
- Modify: `skills/dispatching-parallel-agents/SKILL.md`

**Step 1: Write the failing test**

Not applicable.

**Step 2: Run test to verify it fails**

Not applicable.

**Step 3: Write minimal implementation**

Replace the example Task calls with OpenCode-style mentions, e.g.:

```text
@sp-investigator Fix agent-tool-abort.test.ts failures
@sp-investigator Fix batch-completion-behavior.test.ts failures
@sp-investigator Fix tool-approval-race-conditions.test.ts failures
```

If you introduce `@sp-investigator`, add it to `install.sh` with a suitable prompt (or reuse the implementer prompt if no better template exists).

**Step 4: Run test to verify it passes**

Manual check: examples show OpenCode-compatible `@sp-*` usage.

**Step 5: Commit**

```bash
git add skills/dispatching-parallel-agents/SKILL.md install.sh
git commit -m "docs: align parallel agent examples with sp-* agents"
```

---

### Task 4: Document model configuration and install flow

**Files:**
- Modify: `README.md`

**Step 1: Write the failing test**

Not applicable.

**Step 2: Run test to verify it fails**

Not applicable.

**Step 3: Write minimal implementation**

Add a concise section:
- Run `./install.sh` after cloning.
- Explain where agent files are created: `~/.config/opencode/agents/`.
- Show how to set per-agent models by adding `model: openrouter/qwen3-coder-next` to `sp-implementer.md`.
- Note default behavior: if `model` is omitted, subagents use the invoking primary agent’s model.

**Step 4: Run test to verify it passes**

Manual check: README includes install and configuration steps.

**Step 5: Commit**

```bash
git add README.md
git commit -m "docs: document sp-* agent setup and models"
```

---

### Task 5: Smoke test locally

**Files:**
- None

**Step 1: Write the failing test**

Not applicable.

**Step 2: Run test to verify it fails**

Not applicable.

**Step 3: Write minimal implementation**

Run:
- `./install.sh`
- Launch OpenCode and invoke a Superpowers skill that dispatches `@sp-implementer`.

**Step 4: Run test to verify it passes**

Expected: the `@sp-*` agent launches successfully and uses the configured prompt.

**Step 5: Commit**

No commit; verification only.
