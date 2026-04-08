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

[LEARN] 2026-04-08 — Promote reusable user preferences into durable repo memory
Context: The user wants the workflow to improve across projects by remembering preferences on slide style, manuscript polish, review strictness, and autonomy.
Lesson: Reusable user feedback should not stay only in thread context; it should be written into durable repo memory and then applied by default in later work.
Action: When the user gives clear, reusable preferences, update `MEMORY.md`, `KNOWLEDGE_BASE.md`, or the relevant skill so future sessions start from that house style.

## User house style

- Autonomy:
  - Default to high autonomy on non-trivial work.
  - Make reasonable assumptions and continue unless there is a real fork with non-obvious consequences.
- Durability:
  - Prefer on-disk plans, session logs, reports, and reproducible artifacts over chat-only reasoning.
  - Important decisions, design choices, and review outcomes should be saved in the repo.
- Review standard:
  - Prefer specialist review for serious work and fix material findings before stopping.
  - Treat verification and review as part of done, not optional polish.
- Presentation polish:
  - User-facing outputs should be readable and publication-ready when feasible.
  - Tables and figures in papers/slides should be cleaned up for presentation rather than exposing raw analysis dumps.
- Preference capture:
  - Repeated feedback on slides, manuscripts, tables, figures, or workflow should be distilled into this section or a related skill.
  - Build forward from prior feedback instead of relearning style preferences each project.

## Retired lessons

Move stale or superseded lessons here with a note explaining what replaced them.
