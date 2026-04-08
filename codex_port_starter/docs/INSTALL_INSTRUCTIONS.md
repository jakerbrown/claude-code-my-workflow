# Install Instructions

Use these steps after cloning the original repository.

## 1. Copy the starter pack into the repo root

Copy the contents of this starter pack so that paths like these exist in the
repository root:

- `AGENTS.md`
- `.codex/config.toml`
- `.codex/hooks.json`
- `.codex/agents/...`
- `.agents/skills/...`
- `KNOWLEDGE_BASE.md`
- `MEMORY.md`

Keep the original `.claude/` folder for reference while porting.

## 2. Restart Codex

Restart the Codex app or CLI after copying files. Skills, hooks, custom agents,
and config are discovered at startup.

## 3. Trust the project

Repo-scoped `.codex/config.toml` is only loaded for trusted projects. Mark the
repository as trusted in Codex.

## 4. Validate instruction discovery

Run a prompt like:

> List the `AGENTS.md` files you loaded for this working directory, then
> summarize the active Codex skills and custom agents in this repo.

The expected guidance chain is:

- root `AGENTS.md`
- plus the nearest nested `AGENTS.md` for the current working directory, if any

## 5. Validate skill discovery

Ask Codex to list available repo skills or invoke them explicitly:

- `$slide-excellence`
- `$qa-quarto`

## 6. Validate hook setup

Hooks are experimental. A simple test is to restart Codex and confirm that the
session-start context mentions recent plans or memory entries.

## 7. Windows note

Current documented Codex hooks are disabled on Windows. If you are running
Codex natively on Windows, treat `.codex/hooks.json` as documentation for the
workflow rather than an immediately active feature, or use a supported
environment such as macOS / Linux / WSL for the hook-heavy parts.

## 8. First real task

Once the files are installed, use a prompt like:

> Read `AGENTS.md`, `docs/PORTING_MAP.md`, and `docs/CODEX_WORKFLOW.md`.
> Compare the current `.claude/` folder to the Codex scaffolding and propose the
> next smallest faithful porting step.
