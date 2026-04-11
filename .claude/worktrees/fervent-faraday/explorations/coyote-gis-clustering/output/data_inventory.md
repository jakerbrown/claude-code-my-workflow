# Data Inventory

## Belmont coyote layer
- Source URL: https://www.mapsonline.net/peopleforms/mo4/mo4_server.php?request=identify_multi
- Access path: public PeopleGIS viewer login as `viewer`, then `identify_multi` polygon query on site layer `28433` / layer `5629`.
- Download date: 2026-04-08
- Geometry note: the viewer config advertises EPSG:2249, but returned point WKT is clearly EPSG:3857-like Web Mercator coordinates.
- Record count recovered: 290
- Fields recovered: Reporting Address; Date of Report; Time; date; record_id; jump_id; geometry
- Limitations: no reporter ID, no narrative notes, no direct public layer export.

## Context layers
- Belmont boundary from Census TIGER via `tigris::county_subdivisions()`.
- MassGIS open space ZIP: https://s3.us-east-1.amazonaws.com/download.massgis.digital.mass.gov/shapefiles/state/openspace.zip
- MassGIS NWI ZIP: https://s3.us-east-1.amazonaws.com/download.massgis.digital.mass.gov/shapefiles/state/nwi.zip
- This first pass uses open space and wetlands as the main official habitat-context layers.

## Reporting-bias feasibility
- Direct reporter identifiers: not available in the public layer.
- Indirect diagnostics available: exact coordinate repetition, repeated address counts, same-day repeat locations, raw-vs-unique-location clustering, and top-location removal robustness.

## Time concentration
- Reports are pooled across many years, so any full-period spatial test is partly a reporting-process test rather than a pure behavioral test.

## Other-town sidecar feasibility
- See `other_towns_catalog.csv` for the municipal dataset scout list.
