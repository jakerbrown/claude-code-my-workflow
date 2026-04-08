# Codex Port Starter Pack

This folder is a **Codex-first mirror scaffold** for the repository
`pedrohcgs/claude-code-my-workflow`.

It is designed to be copied into the root of a cloned repository and used as the
starting layer for a Codex-native port. The emphasis is on the pieces that prove
the workflow concept:

- layered `AGENTS.md` guidance
- Codex project configuration in `.codex/config.toml`
- experimental lifecycle hooks in `.codex/hooks.json`
- custom specialist subagents in `.codex/agents/`
- a repo-native knowledge base and memory file
- two flagship skills:
  - `slide-excellence`
  - `qa-quarto`

## What this starter pack does

It recreates the **intent** of the original Claude workflow:

- plan-first execution for non-trivial tasks
- contractor-style implement → verify → review → fix loops
- parallel specialized reviews through explicit subagent spawning
- adversarial Quarto vs Beamer QA
- durable memory through files on disk, not just chat context

## What it does not claim to do

This is not a byte-for-byte or feature-for-feature port.

The main known gaps are:

1. Claude-style **path-scoped rule frontmatter** is emulated with nested
   `AGENTS.md` files instead of being loaded automatically from rule files.
2. Claude-style **`PreCompact` hooks** do not have a direct Codex equivalent in
   the current documented hook surface.
3. Codex `PreToolUse` / `PostToolUse` interception is currently centered on
   **Bash** rather than the full set of file-edit tool events.

The starter pack therefore uses:

- on-disk plans
- on-disk session logs
- `SessionStart` resume context
- `Stop` checkpoint reminders

to recover most of the practical value.

## Suggested merge sequence

1. Copy this folder into the root of your cloned repository.
2. Keep the original `.claude/` folder intact for reference while porting.
3. Restart Codex after copying files so the new config, hooks, agents, and
   skills are discovered.
4. Trust the project in Codex so repo-scoped `.codex/` configuration is loaded.
5. Start from `docs/INSTALL_INSTRUCTIONS.md` and `docs/PORTING_MAP.md`.

## First useful prompt after install

Use a prompt like this in Codex app or Codex CLI:

> Read `AGENTS.md`, `KNOWLEDGE_BASE.md`, `MEMORY.md`, and `docs/PORTING_MAP.md`.
> Tell me which guidance layers you loaded, summarize the current Codex port
> status, and propose the next smallest faithful porting step.

## Starter pack scope

Included now:

- root and nested guidance
- config, rules, and hooks
- 10 custom specialist agent manifests
- knowledge-base and memory scaffolds
- workflow documentation
- reporting templates
- quality-report directory scaffolding
- two Codex-native skills

Planned for later waves:

- the rest of the original skill catalog
- app local-environment setup scripts
- automations
- CI/GitHub Action integration
- optional external orchestrator using the Agents SDK + Codex MCP server
