# Codex Workflow Starter Pack

This folder is a **project-agnostic Codex workflow starter** derived from the
workflow methods in this repository.

Copy it into the root of another repo when you want that repo to adopt the same
operating discipline:

- plan-first execution for non-trivial work
- durable state on disk
- implement -> verify -> review -> fix loops
- explicit specialist review when warranted
- clear completion thresholds and verification reporting

## What this starter pack includes

- layered `AGENTS.md` guidance
- repo-scoped Codex configuration in `.codex/config.toml`
- optional hooks in `.codex/hooks.json`
- custom specialist agent manifests in `.codex/agents/`
- `KNOWLEDGE_BASE.md` and `MEMORY.md` scaffolds
- templates for plans, session logs, and quality reports
- `quality_reports/` directories for durable workflow artifacts
- optional repo-local skills under `.agents/skills/`
- optional example nested guidance for repos that use
  `scripts/`, `explorations/`, `Slides/`, `Quarto/`, or
  `master_supporting_docs/`
- two optional slide-oriented example skills:
  - `slide-excellence`
  - `qa-quarto`

## What this starter pack is for

Use it when you want another repository to inherit this workflow's
methodologies and principles without depending on this repository directly.

The starter gives each project its own local workflow layer so that:

- repo conventions live with the repo
- durable plans and logs stay in the project history
- project-specific guidance can evolve independently

## What it does not claim to do

This is not a byte-for-byte or feature-for-feature runtime clone of every
Claude-era mechanism.

The main known gaps are:

1. Path-scoped Claude rules are emulated with nested `AGENTS.md` files.
2. Claude-style `PreCompact` hooks do not have a direct Codex equivalent.
3. Codex hook interception is strongest around shell usage, not every edit
   event.

The starter therefore leans on:

- on-disk plans
- on-disk session logs
- `SessionStart` resume context
- `Stop` checkpoint reminders

## Suggested install sequence

1. Copy this folder into the root of the target repository.
2. Keep only the nested guidance folders that match the target repo's actual
   structure.
3. Tailor `AGENTS.md`, `KNOWLEDGE_BASE.md`, and `MEMORY.md` to that repo.
4. Restart Codex after copying files so the new config, hooks, agents, and
   skills are discovered.
5. Trust the project in Codex so repo-scoped `.codex/` configuration is loaded.
6. Start from `docs/INSTALL_INSTRUCTIONS.md`.

## First useful prompt after install

Use a prompt like this in Codex app or Codex CLI:

> Read `AGENTS.md`, `KNOWLEDGE_BASE.md`, and `MEMORY.md`. Tell me which
> guidance layers you loaded, summarize this repo's workflow setup, and propose
> the next smallest step to tailor the workflow to this project.

## Adaptation advice

- Keep the root workflow rules generic and stable.
- Move project-specific conventions into nested `AGENTS.md` files and the
  knowledge base.
- Add repo-local skills only when a workflow is used often enough to justify
  maintaining it.
- Treat `slide-excellence` and `qa-quarto` as examples to keep only in
  slide-heavy repos.
- Remove slide or Quarto examples if the target repo does not use them.
