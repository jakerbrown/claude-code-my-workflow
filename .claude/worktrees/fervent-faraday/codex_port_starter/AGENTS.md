# Codex workflow guidance

This repository uses a **Codex-first workflow layer**. Keep this file concise;
deeper procedures live in `docs/CODEX_WORKFLOW.md`, `KNOWLEDGE_BASE.md`,
`MEMORY.md`, templates, and any repo-local skills.

## Codex diary breadcrumbs

For any non-trivial Codex work session, leave a short breadcrumb entry under
repo-root `quality_reports/codex_activity/` before wrap-up, using a filename
like `YYYY-MM-DD_short-task.md`.

Each breadcrumb should briefly capture:

- what you worked on
- what changed
- why it mattered
- what was verified or left unresolved

Write in plain English. Keep it concise, concrete, and not overly technical.
These breadcrumbs are collected by the nightly diary automation in
`jakerbrown.github.io`, so do not leave the only useful summary in chat.

## Core operating mode

- For any non-trivial task, start with or refresh a plan in
  `quality_reports/plans/YYYY-MM-DD_short-task.md`.
- Before substantial edits, read the relevant parts of `KNOWLEDGE_BASE.md` and
  `MEMORY.md`.
- After plan approval, use the contractor loop:

  `implement -> verify -> review -> fix -> re-verify -> score -> summarize`

- Save reports to `quality_reports/` rather than leaving critical reasoning only
  in chat.
- Update a session log in `quality_reports/session_logs/` after plan approval,
  after major decisions, and at wrap-up.

## Parallel work

- Codex does **not** spawn subagents unless explicitly asked.
- When a task benefits from parallel review, explicitly spawn the relevant
  specialists and then synthesize their outputs into a durable report.
- Put reusable repo-local workflows under `.agents/skills/` when they earn
  their maintenance cost.

## Quality thresholds

Use these thresholds unless the user overrides them:

- **60** = exploration / experimental sandbox only
- **80** = production-ready baseline and commit threshold
- **90** = PR-ready
- **95** = excellence / aspirational

Below threshold, keep iterating or clearly report what remains.

## Verification expectations

- Match verification to the kind of change:
  - code changes: run the narrowest relevant tests, scripts, or linters
  - docs or workflow changes: re-read edited files and verify referenced paths
    and commands
  - generated outputs: confirm the expected artifacts exist and are current
- Record what was verified and what was not.

## Infrastructure files

- `.codex/`, `.agents/`, `AGENTS.md`, `KNOWLEDGE_BASE.md`, and `MEMORY.md` are
  workflow infrastructure. Change them carefully and explain why.
- Do not broaden permissions, hooks, or rules casually.
- Keep repo guidance short and stable; put longer procedures in markdown docs
  and skills.

## Exploration policy

- Experimental work belongs under `explorations/` first when the repo uses that
  pattern.
- Production directories should not receive half-formed prototypes.
- Promote work out of `explorations/` only after it clears the relevant quality
  bar and is documented.

## Completion standard

Before declaring a task done, be explicit about:

- what changed
- what was verified
- what review was performed, or why it was skipped
- what reports were written
- current quality level
- any remaining blockers or open questions
