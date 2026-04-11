---
name: slide-excellence
description: Run a parallel, multi-dimensional review of a Beamer or Quarto slide deck using explicit specialist subagents, then synthesize a single actionable report. Use before milestones, lectures, commits, or when a deck needs a serious quality pass.
---

# slide-excellence

Use this skill when the user wants a **full deck review**, not a single narrow fix.

The purpose is to emulate the original Claude workflow's specialist-review pattern
inside Codex by **explicitly** spawning reviewer subagents in parallel.

## Inputs

One of:

- a full path to a `.tex` or `.qmd` deck
- a lecture stem that can be resolved under `Slides/` or `Quarto/`

## Output locations

Write individual reports under `quality_reports/` and then write a combined
summary report.

Recommended filenames:

- `quality_reports/[stem]_visual_audit.md`
- `quality_reports/[stem]_pedagogy_report.md`
- `quality_reports/[stem]_proofread_report.md`
- `quality_reports/[stem]_tikz_review.md` (only if needed)
- `quality_reports/[stem]_substance_review.md` (optional)
- `quality_reports/[stem]_slide_excellence.md` (combined summary)

## Workflow

### 1. Resolve the target deck

- Identify the deck path.
- Determine whether it is Beamer (`.tex`) or Quarto (`.qmd`).
- Infer the paired file when one should exist.

### 2. Read before spawning

Before spawning any agent:

- read the target file
- skim the paired file if parity matters
- check `KNOWLEDGE_BASE.md` and `MEMORY.md` if the deck appears to rely on
  project-specific notation or conventions

### 3. Spawn specialist reviewers in parallel

Spawn these agents **explicitly** and ask each one to return a report-ready
finding set:

- `slide-auditor`
- `pedagogy-reviewer`
- `proofreader`

Conditionally add:

- `tikz-reviewer` if the file contains `tikzpicture`, externalized TikZ assets,
  or obvious diagram-heavy content
- `domain-reviewer` if the user wants substance review or the deck is close to a
  teaching or publication milestone

Important:

- each subagent should stay focused on its own dimension
- each subagent should remain read-only
- the parent agent is responsible for synthesis and writing final files

### 4. Parent-agent parity checks

The parent agent should do the lightweight cross-artifact checks that do not need
their own specialist:

- if the target is `.qmd` and a matching `.tex` exists, compare structure and
  content coverage
- note likely parity drift, missing equations, missing citations, or obvious
  visual downgrades
- if parity issues are substantial, mention that `qa-quarto` is the next skill to run

### 5. Write the individual reports

Normalize the subagent outputs into clean markdown files under `quality_reports/`.

Each issue should include:

- file or slide reference
- severity
- what is wrong
- a specific recommendation

### 6. Synthesize the combined review

Write `quality_reports/[stem]_slide_excellence.md` with this structure:

```markdown
# Slide Excellence Review: [stem]

## Overall assessment
- Status: EXCELLENT / GOOD / NEEDS WORK / POOR
- Recommended next action: teach / revise / run qa-quarto / hold for rewrite

## Dimension summary
| Dimension | Critical | Major | Minor | Notes |
|-----------|----------|-------|-------|-------|
| Visual/Layout | | | | |
| Pedagogy | | | | |
| Proofreading | | | | |
| TikZ (if used) | | | | |
| Substance (if used) | | | | |
| Parity | | | | |

## Highest-priority fixes
1. ...
2. ...
3. ...

## Quality call
- Ready to present: yes/no
- Ready to commit: yes/no
- Estimated score: [0-100]

## Suggested next command
- ...
```

## Quality rubric

Use the rubric in `references/review-rubric.md`.

## Important boundaries

- Do not silently apply edits unless the user separately asks for fixes.
- Do not hide disagreement among reviewers; surface it in the combined summary.
- Be concrete. A deck review is only useful if a human can act on it immediately.
