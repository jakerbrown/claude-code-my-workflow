# qa-quarto hard gates

A hard gate failure means the critic should reject the deck.

## Gates

| Gate | Standard |
|------|----------|
| Overflow | No content cutoff, clipping, or likely scroll requirement |
| Plot quality | Interactive or web-rendered plots must be at least as readable as the Beamer originals |
| Content parity | No missing slides, equations, bullets, citations, or key text |
| Visual regression | Quarto must not be materially worse in layout, hierarchy, or semantics |
| Slide centering | Content should stay visually centered and stable across related slides |
| Notation fidelity | Mathematical expressions should match the Beamer source verbatim unless the task explicitly changes them |

## Default verdict rule

- If any hard gate fails: **REJECTED**
- If all hard gates pass and remaining issues are minor: **APPROVED**
