# Workflow Memory

This file stores **durable lessons** that the workflow should revisit before
non-trivial work.

Use concise entries with a stable format so future sessions can recover quickly.

## Format

```text
[LEARN] YYYY-MM-DD — short title
Context:
Lesson:
Action:
```

## Active lessons

[LEARN] 2026-04-07 — Explicit subagents in Codex
Context: The original Claude workflow relies on automatic specialist delegation.
Lesson: Codex only spawns subagents when explicitly asked.
Action: Skills and plans that depend on parallel specialists must tell Codex which agents to spawn.

[LEARN] 2026-04-07 — Use on-disk plans and logs to survive context changes
Context: The Claude workflow uses a PreCompact hook; Codex does not expose the same hook surface.
Lesson: Durable state should live in `quality_reports/plans/` and `quality_reports/session_logs/`, not only in the live thread.
Action: Refresh plans for non-trivial work and append session logs during long tasks.

[LEARN] 2026-04-07 — Nested AGENTS files replace path-scoped Claude rules
Context: Claude's `paths:`-scoped rule files do not have a direct Codex equivalent.
Lesson: Codex guidance should be layered by directory using `AGENTS.md`.
Action: Keep root guidance short and put folder-specific rules close to the relevant files.

[LEARN] 2026-04-08 — Keep the starter generic, then specialize locally
Context: This starter may be copied into many different project types.
Lesson: Reusable workflow scaffolding should encode process and decision rules,
not assumptions about one domain unless those assumptions are clearly marked as
optional examples.
Action: Put repo-specific practices in nested `AGENTS.md`, `KNOWLEDGE_BASE.md`,
or repo-local skills after install.

## User house style

- Autonomy:
  - Default to making reasonable assumptions and continuing unless a real fork
    has non-obvious consequences.
- Durability:
  - Prefer on-disk plans, logs, and reports over chat-only reasoning.
- Review standard:
  - Treat verification and review as part of done, not optional polish.
- Reusability:
  - Capture repeatable repo conventions in this file or `KNOWLEDGE_BASE.md`
    once they are learned.

## Retired lessons

Move stale or superseded lessons here with a note explaining what replaced them.
