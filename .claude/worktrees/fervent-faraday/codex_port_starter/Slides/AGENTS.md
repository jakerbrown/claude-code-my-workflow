# Slides directory guidance

`Slides/` is the authoritative source for lecture content when a paired Quarto
version exists.

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
