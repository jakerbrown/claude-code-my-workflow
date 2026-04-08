---
name: qa-quarto
description: Run an adversarial Quarto-vs-Beamer QA loop. Spawn a critic to find parity and quality failures, then spawn a fixer to apply only those fixes, re-render, and re-audit until APPROVED or the round limit is reached.
---

# qa-quarto

Use this skill when a Quarto deck should be judged against an existing Beamer
source and the user wants a **hard** quality pass rather than a casual review.

This skill recreates the original critic/fixer loop by explicitly spawning two
specialist agents in sequence.

## Inputs

One of:

- a lecture stem
- an explicit Beamer path and Quarto path
- a Quarto path from which the matching Beamer source can be inferred

## Output locations

Write round-by-round artifacts under `quality_reports/`:

- `quality_reports/[stem]_qa_critic_round1.md`
- `quality_reports/[stem]_qa_fixer_round1.md`
- ...
- `quality_reports/[stem]_qa_final.md`

## Hard gates

See `references/hard-gates.md`. If a hard gate fails, the critic should reject.

## Workflow

### 0. Resolve the artifact pair

Identify:

- Beamer source (`Slides/*.tex`)
- Beamer output (`Slides/*.pdf`) if present
- Quarto source (`Quarto/*.qmd`)
- rendered Quarto output if present

If the pairing is ambiguous, resolve it conservatively and document the choice.

### 1. Pre-flight checks

Before round 1:

- read the Beamer source and the Quarto source
- check whether the Quarto output is stale relative to the source
- if the workflow normally depends on rendered HTML or synced assets, render them
  before the first critic pass when practical
- if relevant figures are derived from TikZ or scripts, note freshness concerns

### 2. Critic round

Explicitly spawn `quarto-critic`.

Instruct it to:

- compare the Quarto deck against the Beamer benchmark
- enforce the hard gates
- return a structured markdown report
- include a top-line verdict of `APPROVED` or `REJECTED`

Write the report to:
`quality_reports/[stem]_qa_critic_round[N].md`

### 3. Approval check

If the critic returns `APPROVED` and no hard gates fail:

- stop the loop
- write the final report
- summarize the result

Otherwise continue.

### 4. Fix round

Explicitly spawn `quarto-fixer`.

Give it:

- the target Quarto source
- the critic report path
- the current round number
- instruction to apply only the requested fixes in priority order

The fixer should:

- make the smallest defensible changes
- re-render when required
- report exactly what changed
- avoid unrelated improvements

Write the report to:
`quality_reports/[stem]_qa_fixer_round[N].md`

### 5. Re-audit

Run another critic round using the updated artifacts.

### 6. Loop control

- maximum rounds: **5**
- if still rejected after round 5, stop and produce a clear escalation report
- do not loop indefinitely

## Final report

Write `quality_reports/[stem]_qa_final.md` with this structure:

```markdown
# Quarto QA Final Report: [stem]

## Final verdict
- Status: APPROVED / REJECTED
- Hard gates passed: yes/no
- Rounds used: N

## Gate summary
| Gate | Status | Notes |
|------|--------|-------|
| Overflow | | |
| Plot quality | | |
| Content parity | | |
| Visual regression | | |
| Slide centering | | |
| Notation fidelity | | |

## Round summary
| Round | Critic verdict | Fix applied | Notes |
|-------|----------------|-------------|-------|
| 1 | | | |
| 2 | | | |

## Remaining issues
- ...

## Recommended next action
- ...
```

## Important boundaries

- The critic is read-only and adversarial.
- The fixer implements; it does not redesign the deck on its own.
- Beamer is the benchmark unless the user explicitly changes the source-of-truth rule.
- If rendering fails, report that clearly instead of pretending QA completed.
