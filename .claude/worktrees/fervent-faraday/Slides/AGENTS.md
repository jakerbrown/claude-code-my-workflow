# Slides directory guidance

`Slides/` is the authoritative source for lecture content when a paired Quarto
version exists.

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

## Rules for edits here

- Preserve frame order, mathematical notation, and citation intent exactly
  unless the task explicitly asks for substantive changes.
- If there is a matching `Quarto/*.qmd`, mirror equivalent user-facing edits in
  the same task.
- Avoid introducing new overlay / pause mechanics unless the local deck already
  depends on them and the user explicitly wants them.
- Prefer structural fixes over tiny-font fixes.
- Compile after meaningful edits whenever practical.

## Review expectations

Before milestones, use the `slide-excellence` skill or explicitly spawn:

- `slide-auditor`
- `pedagogy-reviewer`
- `proofreader`

Optionally add:

- `tikz-reviewer` for TikZ-heavy decks
- `domain-reviewer` for substance review
