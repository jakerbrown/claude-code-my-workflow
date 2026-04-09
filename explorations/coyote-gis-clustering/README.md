# Exploration: coyote GIS clustering

- **Date started:** 2026-04-08
- **Status:** active, first full analysis pass completed

## Goal

Analyze whether Belmont's public coyote-sighting clusters look more like a real
coyote-use gradient, a reporting concentration effect, or a mixture of both.
Package the work as a reproducible exploratory GIS analysis and a blog-ready
draft for a technically literate audience.

## What this exploration now contains

- A recovered point dataset from Belmont's public PeopleGIS viewer, even though
  direct layer export is disabled.
- A reproducible R pipeline in `src/run_analysis.R`.
- Cleaned point output, clustering diagnostics, reporting-bias diagnostics,
  figures, and narrative memos in `output/`.
- A sidecar catalog of other Massachusetts municipal GIS datasets that are
  unusually vivid or analytically promising.

## Public repo note

This public copy keeps the prompt, executable code, recovered raw Belmont JSON,
and analysis outputs needed to inspect the workflow. The large third-party GIS
context layers are not checked in here; `src/run_analysis.R` downloads the
official MassGIS inputs when they are missing locally.

## Main empirical direction

- Test whether Belmont's coyote reports are clustered using several methods,
  not just a visual heatmap.
- Re-run key tests after collapsing repeated coordinates and after removing the
  most repeated locations.
- Compare coyote-report locations to random points inside Belmont using open
  space and wetlands as first-pass official ecological context.
- Treat any super-caller conclusion as indirect unless reporter identifiers can
  be observed directly.

## Current bottom line

The first serious pass suggests that Belmont's coyote reports are genuinely
clustered, but that raw hotspots are amplified by repeated reports from a small
number of recurring mapped locations. The maps still suggest a western-edge
pattern, but the first-pass official context diagnostics do not strongly
validate a simple habitat story, so the package currently supports a mixed
spatial-plus-reporting interpretation with stronger evidence for reporting
concentration than for habitat concentration.
