# Feasibility Audit

## Main question

Can Belmont's public coyote data support a serious spatial analysis about
behavioral clustering versus reporting concentration?

## 1. Belmont coyote data access

### Status

Feasible, with caveats.

### What is public

- Belmont's public PeopleGIS map includes a `Coyote Sightings` layer.
- Direct public download is disabled in the web interface.
- The viewer's public backend still returns records through the same query path
  the web app uses internally.

### Source details

- Viewer landing page: `https://www.mapsonline.net/belmontma/index.html`
- Query endpoint used in this project:
  `https://www.mapsonline.net/peopleforms/mo4/mo4_server.php?request=identify_multi`
- Access date: 2026-04-08

### Fields actually recovered

- `Reporting Address`
- `Date of Report`
- `Time`
- `date` (epoch-style field)
- `record_id`
- `jump_id`
- point geometry

### Key limitations

- No public reporter identifier.
- No public narrative notes.
- No public duplicate flag.
- Geometry CRS could not be trusted from the viewer metadata and had to be
  inferred from the returned coordinate values.

## 2. Context-layer access

### Status

Feasible for a strong first pass.

### Layers used in the first pass

- Belmont boundary from Census TIGER county subdivisions.
- MassGIS open space.
- MassGIS National Wetlands Inventory layer.

### Additional layers identified but not yet fully integrated

- Belmont map-service layers for schools, cemeteries, rail, hydrography,
  conservation, and related municipal context.
- These are visible in capabilities metadata, but feature export is not openly
  enabled in the same straightforward way as the coyote points.

### Practical conclusion

The available official layers are sufficient to support a serious first-pass
habitat-context comparison, but not yet sufficient to support every desirable
corridor and parcel-level analysis without more extraction work.

## 3. Reporting-bias feasibility

### Status

Moderately feasible.

### Direct super-caller test

Not feasible from public data alone because reporter identifiers are absent.

### Indirect diagnostics that are feasible

- exact coordinate repetition
- repeated reporting-address concentration
- same-location same-day repeat events
- raw-report versus unique-location clustering comparison
- removing the top repeated locations and re-running clustering metrics

### Practical conclusion

The project can test whether the observed map is consistent with observer
concentration, but it cannot prove that a single named person generated a large
share of the reports.

## 4. Other-town sidecar feasibility

### Status

Feasible as a compact catalog, and selectively feasible for small companion
analysis.

### Good candidates located quickly

- Weston wildlife reporting and map infrastructure.
- Dedham tree inventory and sewer infrastructure services.
- Cambridge street-tree inventory.

### Practical conclusion

A short sidecar section is realistic without derailing the Belmont story. A
full multi-town comparative analysis would be possible later but would exceed
the scope of this first Belmont-centered package.
