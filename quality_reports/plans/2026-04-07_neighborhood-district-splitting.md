# Plan: neighborhood district splitting

- **Date:** 2026-04-07
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Produce a reproducible research pipeline and short paper assessing whether
city-defined neighborhoods are kept whole within state legislative districts
and city council districts, how often neighborhoods are split across multiple
districts, and how splitting patterns differ across district types.

## Scope

- In scope:
  - Read and extract key measurement and coverage details from the
    Ansolabehere et al. neighborhood-boundary paper and linked data materials.
  - Define estimands, units of analysis, weighting schemes, and core outcome
    measures before full analysis.
  - Build a reproducible acquisition and analysis workflow in this repo.
  - Produce summary statistics, tables, figures, at least one example map, and
    a short paper draft with limitations.
  - Run specialist review on the R pipeline and manuscript draft, then fix
    issues and re-verify before completion.
- Out of scope:
  - Exhaustive national assembly of every city council district source if
    source heterogeneity makes that infeasible within this task.
  - Strong causal claims about why some cities split neighborhoods more than
    others.

## Assumptions and clarifications

- CLEAR:
  - The neighborhood source of truth is Ansolabehere et al. (2025),
    "City-Defined Neighborhood Boundaries in the United States."
  - Results must compare state legislative and city council district splitting
    where possible and document coverage limits.
- ASSUMED:
  - A narrower multi-city city-council design is acceptable if national city
    council coverage is too heterogeneous, but the state-legislative analysis
    should still aim for broad coverage.
  - A short paper draft in Quarto markdown plus rendered outputs is acceptable.
- BLOCKED:
  - Final city council scope depends on source coverage and acquisition burden.

## Files likely to change

- `quality_reports/plans/2026-04-07_neighborhood-district-splitting.md`
- `quality_reports/session_logs/2026-04-07_neighborhood-district-splitting.md`
- `quality_reports/design_memo_neighborhood_district_splitting.md`
- `quality_reports/lit_review_neighborhood_district_splitting.md`
- `quality_reports/neighborhood_district_splitting_analysis_report.md`
- `explorations/neighborhood_district_splitting/`
- `scripts/R/neighborhood_district_splitting_run.R`
- `output/neighborhood_district_splitting/`

## Implementation approach

1. Read the anchor paper and minimal related literature, then write a concise
   design memo covering scope, estimands, units, weights, and data risks.
2. Audit feasible boundary sources for neighborhoods, state legislative
   districts, and city council districts; decide whether city council analysis
   should be national, sampled, or city-specific.
3. Build the data pipeline in exploration space first if needed, then promote
   stable code into `scripts/R/` once the design stabilizes.
4. Compute containment and splitting measures by district type and weighting
   scheme, generate tables/figures/example maps, and save analysis-ready
   outputs.
5. Draft the short paper, run specialist review on the R pipeline and
   manuscript, fix issues, re-verify outputs, render the manuscript, and record
   the final quality score.

## Verification plan

- Compile / render:
  - Render the manuscript draft to HTML and PDF.
- Run scripts / tests:
  - Run the main R script entry point used for acquisition, measurement, and
    figure/table generation.
- Manual checks:
  - Confirm key data-source links, city coverage statements, and weighting
    definitions against source materials.
  - Inspect at least one example map and sanity-check split metrics for the
    matched city sample.
- Reports to write:
  - Design memo
  - Literature review
  - Analysis report
  - Session log checkpoints
  - Specialist review artifacts

## Review plan

- Specialists to spawn:
  - `r-reviewer` on the final R analysis script
  - `domain-reviewer` on the paper draft and research design
- Whether adversarial QA is needed:
  - Not a Beamer/Quarto parity task; specialist review replaces the
    adversarial critic/fixer loop here.
- Final quality threshold:
  - 90

## Risks

- Risk:
  - City council district data may be fragmented across cities and portals.
- Mitigation:
  - Document source heterogeneity early and pivot to a justified sampled-city
    design if necessary.

- Risk:
  - Neighborhood source coverage may not align cleanly with district coverage.
- Mitigation:
  - Define the analysis universe explicitly and report coverage denominators for
    every comparison.

- Risk:
  - Spatial intersections may be sensitive to projection, slivers, and invalid
    geometry.
- Mitigation:
  - Use consistent projected CRS choices, validate geometries, and document
    intersection tolerances.

## Completion note

- Completed on 2026-04-07 after the full contractor loop:
  - implement -> verify -> review -> fix -> re-verify -> summarize
- Final review structure used:
  - parallel R-pipeline review
  - parallel manuscript review
- Final quality assessment:
  - 90/100
