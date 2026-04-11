# Install Instructions

Use these steps when you want another repository to adopt this workflow.

## 1. Copy the starter pack into the repo root

Copy the contents of this starter pack so that paths like these exist in the
repository root:

- `AGENTS.md`
- `.codex/config.toml`
- `.codex/hooks.json`
- `.codex/agents/...`
- `KNOWLEDGE_BASE.md`
- `MEMORY.md`
- `quality_reports/plans/`
- `quality_reports/session_logs/`
- `.agents/skills/...` if you want repo-local skills

## 2. Remove or keep only relevant nested guidance

The starter includes example nested `AGENTS.md` files for common directory
patterns such as:

- `scripts/`
- `explorations/`
- `master_supporting_docs/`
- `Slides/`
- `Quarto/`

Keep only the ones that match the target repo's actual structure.

If the target repo is not slide-heavy, you can also remove the example skills:

- `.agents/skills/slide-excellence/`
- `.agents/skills/qa-quarto/`

## 3. Tailor the root workflow files

Edit these files for the target repo:

- `AGENTS.md`
- `KNOWLEDGE_BASE.md`
- `MEMORY.md`

Make the root guidance reflect the repo's own verification steps, review
standards, and important conventions.

## 4. Restart Codex

Restart the Codex app or CLI after copying files. Hooks, custom agents, and
config are discovered at startup.

## 5. Trust the project

Repo-scoped `.codex/config.toml` is only loaded for trusted projects. Mark the
repository as trusted in Codex.

## 6. Validate instruction discovery

Run a prompt like:

> List the `AGENTS.md` files you loaded for this working directory, then
> summarize the active custom agents and any repo-local skills in this repo.

The expected guidance chain is:

- root `AGENTS.md`
- plus the nearest nested `AGENTS.md` for the current working directory, if any

## 7. Validate skill discovery

If the repo has local skills, ask Codex to list them or invoke them explicitly.

If it does not, that is fine. The starter still works with plans, logs,
templates, and the root guidance alone.

## 8. Validate hook setup

Hooks are experimental. A simple test is to restart Codex and confirm that the
session-start context mentions recent plans or memory entries.

## 9. Windows note

Current documented Codex hooks are disabled on Windows. If you are running
Codex natively on Windows, treat `.codex/hooks.json` as documentation for the
workflow rather than an immediately active feature, or use a supported
environment such as macOS / Linux / WSL for the hook-heavy parts.

## 10. First real task

Once the files are installed, use a prompt like:

> Read `AGENTS.md`, `KNOWLEDGE_BASE.md`, `MEMORY.md`, and
> `docs/CODEX_WORKFLOW.md`. Propose the next smallest step to tailor this
> workflow to the current repo and write a plan under `quality_reports/plans/`.
