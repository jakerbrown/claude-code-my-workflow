# Quarto directory guidance

`Quarto/` is the web-slide mirror of the Beamer source, not an independent
creative branch.

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

- The Beamer deck is the benchmark when a matching `.tex` file exists.
- Do not condense, summarize, or silently simplify Beamer content.
- Preserve equations, notation, and citation coverage exactly.
- Browsers do not render inline PDF images; use SVG or other web-safe assets.
- Keep layout centered and stable across slides.
- If a Beamer environment has visual semantics, use a matching Quarto class or
  create one deliberately.

## Review expectations

For substantial Quarto work, prefer the `qa-quarto` skill. Its hard gates are:

- no overflow or cutoff
- no content parity loss
- no notation drift
- no visual regression relative to Beamer
- no centering regressions
