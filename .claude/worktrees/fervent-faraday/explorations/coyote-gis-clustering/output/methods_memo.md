# Methods Memo

## Feasibility summary
Belmont's coyote layer is publicly queryable through the PeopleGIS viewer even though one-click data export is disabled.
The public query returns address, date, time, internal record IDs, and geometry, but not reporter identifiers or narrative notes.

## Data pipeline
Randomized procedures are seeded with `set.seed(20260408)` for reproducibility.
1. Logged into Belmont's public PeopleGIS backend as the viewer account used by the web app.
2. Queried the coyote site layer with a polygon covering Belmont's full town extent.
3. Parsed the returned JSON into a cleaned sf point layer.
4. Added Belmont boundary from Census TIGER county subdivisions.
5. Added open space and wetlands from MassGIS statewide downloads, then clipped to Belmont.
6. Added official habitat-like context from MassGIS open space and wetlands.

## Spatial-statistics toolkit
- Simulation-based nearest-neighbor ratio against complete spatial randomness for raw reports, unique exact locations, and a top-repeat-removed robustness variant.
- Quadrat test on a 4x4 fishnet within Belmont.
- Ripley's L envelopes against CSR.
- Kernel density estimation with Diggle bandwidth selection.
- Local Moran's I on a Belmont-clipped 250-meter count grid, with separate hotspot-sensitivity output across multiple cell sizes.

## Reporting-bias diagnostics
- Exact coordinate repetition.
- Repeated reporting-address counts.
- Same-location same-day multiplicity.
- Same-address same-day and same-week multiplicity.
- Repeated addresses that map to more than one coordinate.
- Comparison of raw, unique-location, and top-location-removed clustering metrics.

## Ecological-context diagnostics
- Distance-to-open-space and wetlands comparisons against random points within Belmont.
- Logistic model distinguishing unique sighting locations from random controls using log-distance predictors.
- Ecological-context summary table saved to `ecological_context_results.csv`.
- Temporal concentration summary saved to `temporal_concentration_results.csv`.
- Hotspot scale-sensitivity summary saved to `hotspot_sensitivity.csv`.

## Important limitations
- Opportunistic sightings are not a census of coyotes.
- Full-period CSR benchmarks are tests of report concentration, not clean tests of coyote behavior.
- The ecological controls are not observer-exposure aware, so they cannot cleanly validate or reject habitat stories.
- KDE and hotspot surfaces are descriptive and scale-sensitive.
- Reporter IDs and narrative notes are absent from the public layer.
- Viewer-returned geometry CRS needed to be inferred from coordinate values rather than trusted directly from the viewer metadata.
