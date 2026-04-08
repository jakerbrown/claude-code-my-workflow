# Codex workflow guidance

This repository is configured as a **Codex-first port** of the original
Claude workflow. Keep this file concise; deeper procedures live in
`docs/CODEX_WORKFLOW.md`, `docs/PORTING_MAP.md`, `KNOWLEDGE_BASE.md`,
`MEMORY.md`, and the repo skills.

## Core operating mode

- For any non-trivial task, start with or refresh a plan in
  `quality_reports/plans/YYYY-MM-DD_short-task.md`.
- Before editing slides, Quarto, or R code, read the relevant parts of
  `KNOWLEDGE_BASE.md` and `MEMORY.md`.
- After plan approval, use the contractor loop:

  `implement → verify → review → fix → re-verify → score → summarize`

- Save reports to `quality_reports/` rather than leaving critical reasoning only
  in chat.
- Update a session log in `quality_reports/session_logs/` after plan approval,
  after major decisions, and at wrap-up.

## Parallel work

- Codex does **not** spawn subagents unless explicitly asked.
- When a task benefits from parallel review, explicitly spawn the relevant
  specialist agents and then synthesize their outputs.
- Prefer the repo skills when they fit:
  - `$slide-excellence`
  - `$qa-quarto`

## Quality thresholds

Use these thresholds unless the user overrides them:

- **60** = exploration / experimental sandbox only
- **80** = production-ready baseline and commit threshold
- **90** = PR-ready
- **95** = excellence / aspirational

Below threshold, keep iterating or clearly report what remains.

## Slide and Quarto policy

- If a user-facing content change is made in `Slides/` and the matching file
  exists in `Quarto/`, mirror the equivalent change in the same task unless the
  change is purely LaTeX infrastructure.
- Treat the Beamer source as authoritative when Beamer and Quarto drift.
- Preserve equations, notation, and citations verbatim unless the task itself is
  to change them.

## Verification expectations

- `Slides/*.tex`: compile or otherwise verify renderability.
- `Quarto/*.qmd`: render or otherwise verify output freshness and hard-gate
  status against the Beamer source.
- `scripts/**/*.R`: run the relevant script entry point and confirm expected
  outputs exist.
- Record what was verified and what was not.

## Infrastructure files

- `.codex/` and `.agents/` are workflow infrastructure. Change them carefully
  and explain why.
- Do not broaden permissions, hooks, or rules casually.
- Keep repo guidance short and stable; put longer procedures in markdown docs
  and skills.

## Exploration policy

- Experimental work belongs under `explorations/` first.
- Production directories should not receive half-formed prototypes.
- Promote work out of `explorations/` only after it clears the higher quality
  bar and is documented.

## Completion standard

Before declaring a task done, be explicit about:

- what changed
- what was verified
- what reports were written
- current quality level
- any remaining drift, blockers, or open questions
