# scripts directory guidance

This directory is for reproducible, non-experimental project code.

## Codex diary breadcrumbs

For any non-trivial Codex work session tied to this repo, leave a short
breadcrumb entry under repo-root `quality_reports/codex_activity/` before
wrap-up, using a filename like `YYYY-MM-DD_short-task.md`.

Each breadcrumb should briefly capture:

- what you worked on
- what changed
- why it mattered
- what was verified or left unresolved

Write in plain English. Keep it concise, concrete, and not overly technical.
These breadcrumbs are collected by the nightly diary automation in
`jakerbrown.github.io`, so do not leave the only useful summary in chat.

## Standards

- Use relative paths from the repository root.
- Load packages near the top of the script.
- Use `set.seed()` once near the top for stochastic code.
- Save heavy intermediate outputs in durable formats such as RDS when useful to
  downstream rendering.
- Keep functions small, named, and documented.
- Prefer code that runs cleanly from a fresh clone via `Rscript`.

## Workflow

- If work is exploratory or uncertain, start in `explorations/` instead.
- For production scripts, verify by actually running the script or the relevant
  entry point.
- Document expected outputs and where they land.
- Use `r-reviewer` when the task is important enough to justify a dedicated code
  review.
