# explorations directory guidance

This directory is the sandbox for uncertain, experimental, or fast-moving work.

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

## Operating rules

- Move quickly, but document the goal and the state of play.
- Quality threshold here is **60**, not 80.
- Keep the experiment self-contained under its own subfolder.
- Maintain a lightweight `README.md` and `SESSION_LOG.md` inside each active
  exploration.
- When the idea stabilizes, either:
  - graduate it into production directories, or
  - archive it with a brief explanation.

## Do not do this

- Do not let half-finished experiments leak directly into production folders.
- Do not hide dead ends. Archive them with a sentence or two explaining why the
  path was abandoned.
