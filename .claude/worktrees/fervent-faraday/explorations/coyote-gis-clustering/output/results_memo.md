# Results Memo

## Bottom line
Belmont's coyote reports are not spatially random, but the strongest clustering signal weakens materially when the analysis collapses exact duplicate coordinates and removes the most repeated locations.
That pattern is most consistent with non-uniform report concentration that is sharpened by repeated reporting from recurring places, with only limited first-pass support for a stronger habitat explanation from the official context layers used here.

## Key empirical findings
- Raw reports recovered: 290.
- Unique exact locations: 251.
- Share of all reports on exact coordinates that repeat: 22.8%.
- Share of nonblank-address reports from addresses that repeat: 27.0%.
- Share of all reports from the single most repeated exact location: 1.4%.
- Share of all reports from the five most repeated exact locations: 6.6%.
- Simulation-based nearest-neighbor ratio, raw reports: 0.697 (Monte Carlo p=0.005).
- Simulation-based nearest-neighbor ratio, unique locations: 0.833 (Monte Carlo p=0.005).
- Quadrat test p-value, raw reports: 1.6e-07.
- Quadrat test p-value, unique locations: 2.01e-05.
- Median distance from unique sighting locations to open space: 138 m, versus 99 m for random points.
- Median distance from unique sighting locations to wetlands: 277 m, versus 251 m for random points.
- Share of dated reports from 2011-2012: 46.0%.
- Raw hotspot cells across scale choices: 27, 13, 10, 6 at 150 m, 250 m, 400 m, and 600 m grids.

## Interpretation
The coyote map contains many repeated exact points and repeated addresses, which is what you would expect if some residents or households reported multiple sightings over time from the same vantage points.
Even after deduplication, the remaining unique locations are still less uniform than a complete-spatial-random benchmark inside Belmont, but that benchmark should be read as a report-process check rather than as a direct ecological null.
That means the surviving concentration is not only a one-household artifact, but it also cannot be cleanly separated from broader reporting opportunity with the current design.

## Ecological-context read
The first-pass official context layers do not provide strong support for a simple habitat story. Unique sighting locations are not closer to wetlands than random Belmont points, and in this specification they are farther from mapped open space on average.
Because the controls are sampled uniformly from all of Belmont rather than from observer-accessible places, these habitat diagnostics should themselves be treated cautiously.
That means the visual western-side pattern in the maps should be treated as suggestive rather than confirmed by the distance diagnostics.
Some repeated hotspots also sit on ordinary residential streets rather than inside habitat polygons, which points back toward observer concentration and repeated report origins.

## Reporting-bias read
The data do not identify reporters, so the analysis cannot prove a literal super-caller.
What it can show is that repeated reporting from recurring locations is real, even if the concentration is not extreme enough to support a dramatic single-reporter story.
The stronger duplicate question also does not end with exact-point deduplication alone; repeated addresses and repeated address-week combinations still matter.
Taken together with the weak first-pass habitat diagnostics, that makes any raw heatmap interpretation too strong unless it is paired with unique-location and top-location-removed checks.
