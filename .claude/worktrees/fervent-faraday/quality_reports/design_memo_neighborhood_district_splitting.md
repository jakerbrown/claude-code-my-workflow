# Design Memo: Neighborhood Splitting Across Legislative Districts

- **Date:** 2026-04-07
- **Project:** neighborhood district splitting
- **Status:** active design baseline

## Research question

Are city-defined neighborhoods typically contained within a single electoral
district, or are they split across multiple districts? How do splitting
patterns compare between state legislative districts and city council districts?

## Source anchor

The core neighborhood source is Ansolabehere, Brown, Enos, Shair, Simko, and
Sutton (2025), "City-Defined Neighborhood Boundaries in the United States,"
*Scientific Data* ([article](https://www.nature.com/articles/s41597-025-05329-6);
[data release](https://doi.org/10.7910/DVN/02NP1O)).

Key takeaways for this project:

- The paper reports a target frame of **336 U.S. cities with populations above
  100,000** as of 2022.
- It identifies some form of city-defined neighborhood map for **206 cities**
  and more than **77 million people**.
- The release provides cleaned city-level neighborhood boundary files and
  Census-block-linked city files with 2020 demographic data.
- The intended use is measurement: the authors explicitly position city-defined
  neighborhoods as a higher-precision alternative to Census tract or block-group
  proxies when researchers need locally meaningful neighborhood boundaries.

## Minimum related literature

This short paper needs only a focused bridge across two literatures.

### Neighborhood measurement

- Ansolabehere et al. (2025), for the new city-defined neighborhood dataset.
- Wong et al. (2020), "Maps in People's Heads," for the broader point that
  politically relevant local context is not well captured by arbitrary
  administrative geography.

### Communities of interest and districting

- Cross (1998), "Communities of Interest and Minority Districting after
  *Miller v. Johnson*," for competing meanings of communities of interest in
  redistricting.
- Barabas and Jerit (2004), "Redistricting Principles and Racial
  Representation," for the way traditional districting principles interact and
  trade off.
- Chen and Rodden (2015), "Cutting Through the Thicket," for the broader
  argument that districting outcomes should be evaluated relative to competing
  legitimate criteria, including communities of interest.

This is enough to motivate the paper's contribution: it does not claim that
neighborhoods are the only communities of interest, but it provides a concrete
descriptive benchmark for how often one observable and locally meaningful
community boundary is kept together.

## Proposed estimands

For each neighborhood `n` in district system `d`, define:

- `contained_nd`: indicator that the neighborhood is fully contained in one
  district after applying a minimal sliver tolerance.
- `district_count_nd`: number of distinct districts intersecting the
  neighborhood.
- `largest_area_share_nd`: share of neighborhood area contained in the largest
  intersecting district.
- `largest_pop_share_nd` (optional): share of neighborhood population in the
  largest intersecting district using the Census-block-linked files from the
  Dataverse release, if feasible at adequate coverage.

Core aggregate estimands:

- Neighborhood-weighted containment rate.
- Neighborhood-weighted mean and distribution of `district_count`.
- Neighborhood-weighted mean and quantiles of `largest_area_share`.
- City-weighted analogs to prevent very large cities from dominating.
- Population-weighted analogs only if the coverage and implementation are
  strong enough to support main-text reporting.

## Unit of analysis and weighting

The base unit of analysis is the **city-defined neighborhood**.

Primary weighting schemes:

- **Neighborhood-weighted:** each neighborhood counts equally.
- **City-weighted:** each city contributes equally through city-level means.
- **Population-weighted:** each neighborhood weighted by neighborhood
  population from the source release, only if feasible.

Interpretation rule:

- The main state-legislative results can be shown for all covered cities.
- The cleanest comparison between state legislative and city council systems
  should use the **same matched city sample** for both district types.

## Scope decision

### State legislative districts

Use a broad design based on Census/TIGER state legislative district boundaries.
This part appears feasible at scale and should cover nearly the full
neighborhood-source city universe.

### City council districts

Use a **matched-city sample** rather than forcing a nominally national city
council analysis.

Rationale:

- City council boundaries are maintained by cities, not one national provider.
- Coverage is heterogeneous across municipal open-data systems.
- A sampled design with explicit official sources is more reproducible and
  easier to audit than a rushed pseudo-national scrape.

Matched sample selected for this run:

- Austin, Texas
- Chicago, Illinois
- Minneapolis, Minnesota
- Seattle, Washington

These cities are in the neighborhood release and have official municipal
district data accessible through stable GIS endpoints.

## Measurement details

- Use cleaned neighborhood polygons from the Dataverse release.
- Reproject each city to a local projected CRS before area calculations.
- Validate and repair geometry before overlay.
- Ignore microscopic slivers when counting intersections.
- Keep state upper and lower chambers separate throughout.
- Treat any population-weighted branch as secondary until it yields clear
  multi-city coverage.

## Planned outputs

- A source-and-coverage table describing the city universe and district sources.
- Summary statistics table by district type and weighting scheme.
- Distribution figure for the number of intersecting districts.
- Figure for containment rates and/or largest-share metrics.
- One example city map showing a notably split neighborhood.
- Short paper draft with introduction, data, measurement, results, limitations,
  and conclusion.

## Limitations to foreground

- The neighborhood dataset covers only cities present in the source release.
- The city-council analysis is a strong-coverage sample, not a national city
  census.
- Area-based containment may differ from resident-weighted containment.
- The paper is descriptive and does not by itself identify why cities differ in
  neighborhood fragmentation.

## Decision checkpoint

This memo adopts the following baseline unless implementation reveals a serious
data problem:

1. Broad state legislative analysis.
2. Matched four-city city council sample using official city data.
3. Main cross-system comparison restricted to matched cities for fairness.
