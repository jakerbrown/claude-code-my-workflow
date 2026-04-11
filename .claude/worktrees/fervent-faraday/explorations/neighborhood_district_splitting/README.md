# Exploration: neighborhood district splitting

- **Date started:** 2026-04-07
- **Status:** active

## Goal

Prototype a reproducible pipeline to measure whether city-defined neighborhoods
are kept whole within state legislative districts and city council districts.

## Current design

- Broad state legislative analysis.
- Matched city-council sample with official municipal data.
- Neighborhood as the base unit of analysis.
- Area-weighted outcomes required; city-weighted summaries required; population
  weighting only if the branch proves strong enough.

## Planned promotion path

If the acquisition and measurement pipeline stabilizes cleanly, promote the main
scripts into `scripts/R/` and keep only exploratory notes here.
