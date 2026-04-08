# Quarto directory guidance

`Quarto/` is the web-slide mirror of the Beamer source, not an independent
creative branch.

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
