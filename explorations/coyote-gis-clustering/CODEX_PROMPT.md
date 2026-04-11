# Master Prompt: Belmont Coyote GIS Blog Project

Paste or adapt the prompt below in a fresh Codex task when you want Codex to
run the full project.

---

You are working inside `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow`.
This is an exploratory but high-standards empirical GIS project. Your objective
is to conduct a serious, reproducible spatial analysis and draft a blog post on
the following question:

**Do spatial clusters in Belmont's coyote sighting data reflect real coyote
behavior and habitat use, or do they more likely reflect reporting patterns
such as one or a few super-callers?**

This should be the main focus of the post. A secondary but worthwhile component
is to explore other fun, weird, or unexpectedly rich GIS datasets published by
Massachusetts towns, and include those analyses if feasible.

The user does **not** want a generic local-interest post based on vibes. The
core of the piece must come from original analysis using strong GIS and spatial
statistics methods. Municipal context, local news, and town documentation can be
used as supporting context, but not as substitutes for empirical analysis.

## Working style and repo rules

Follow this repository's workflow rules strictly:

1. Read the active `AGENTS.md` guidance, `MEMORY.md`, `KNOWLEDGE_BASE.md`, and
   any relevant nested `AGENTS.md` before doing substantial work.
2. Because this is a non-trivial task, create or refresh:
   - `quality_reports/plans/YYYY-MM-DD_coyote-gis-analysis.md`
   - `quality_reports/session_logs/YYYY-MM-DD_coyote-gis-analysis.md`
3. Work under a self-contained exploration folder:
   - `explorations/coyote-gis-clustering/`
4. Use the contractor loop:
   - implement -> verify -> review -> fix -> re-verify -> score -> summarize
5. Leave a concise breadcrumb in:
   - `quality_reports/codex_activity/YYYY-MM-DD_coyote-gis-analysis.md`
6. Treat the minimum acceptable quality level for the final exploratory package
   as **80**, even though `explorations/` normally permits 60.
7. Use explicit subagents. Do not assume specialist review happens
   automatically in Codex.

## Top-level objective

Produce a blog-ready draft that analyzes Belmont's coyote sighting point data
with enough rigor to make a careful claim about whether observed clustering is
more consistent with:

- true ecological or behavioral concentration of coyotes
- observer/reporting concentration
- or some mixture of the two

The final piece should be readable to a general audience but methodologically
credible to a technically literate GIS reader.

## Non-negotiable standards

1. Do not fake access to shapefiles, metadata, or municipal web sources.
2. Do not treat a heatmap as analysis.
3. Do not claim causal certainty from opportunistic sighting data.
4. Do not ignore the possibility of strong reporting bias.
5. Do not rely on one clustering method.
6. Do not stop after a first-pass map and summary statistic.
7. Do not hide uncertainty, data limitations, geocoding issues, or
   incompleteness.
8. Do not present "wildlife habitat" claims without grounding them in
   observable spatial context such as land cover, parks, woods, water, rail
   corridors, cemeteries, or edge environments.
9. This prompt expects specialist review and at least one adversarial review
   loop before completion.

## Core research questions

Answer the following:

1. Do Belmont coyote sightings exhibit statistically meaningful spatial
   clustering?
2. Where are the strongest clusters, if any?
3. Are those clusters better explained by plausible coyote habitat and
   movement corridors, or by reporting behavior?
4. Is there evidence consistent with a super-caller or concentrated set of
   reporters generating a disproportionate share of the pattern?
5. What contextual spatial features best line up with the clusters:
   parks, woods, conservation land, streams, cemeteries, rail lines, school
   campuses, major roads, or neighborhood boundaries?
6. If other Massachusetts towns publish unusual GIS datasets, which ones are
   analytically or narratively worth including as a sidecar section?

## Feasibility gate: do this first

Before deep analysis, run a feasibility audit and write it down.

You must determine:

1. **Belmont coyote data access**
   - Is the point shapefile or equivalent dataset publicly available?
   - What fields exist: date, time, address, notes, reporter, incident type,
     status, duplicate flag, etc.?
   - Is there metadata explaining how the points were created?

2. **Context-layer access**
   - What ancillary layers are available or readily obtainable for Belmont:
     parcels, roads, land cover, open space, parks, hydrography, rail lines,
     zoning, schools, census geography, 311/request layers, or conservation
     land?
   - Which of these are legally usable and easy to harmonize?

3. **Reporting-bias feasibility**
   - Does the source data include reporter identifiers, dates, addresses, or
     narrative notes that could reveal repeat reporters or reporting bursts?
   - If reporter IDs are absent, what indirect diagnostics can still be run?

4. **Other-town sidecar feasibility**
   - Are there other Massachusetts towns with quirky or rich GIS layers worth
     a compact comparative section?
   - If yes, which ones can be analyzed quickly without derailing the main
     Belmont story?

If key data are missing, do **not** bluff. Instead:

- document the blocker clearly
- state the minimum additional inputs needed
- complete the strongest partial analysis still defensible

## Deliverables

Create as many of these as feasible, with real content:

- `explorations/coyote-gis-clustering/README.md`
- `explorations/coyote-gis-clustering/SESSION_LOG.md`
- `explorations/coyote-gis-clustering/data/`
- `explorations/coyote-gis-clustering/output/`
- `explorations/coyote-gis-clustering/src/`
- `explorations/coyote-gis-clustering/output/data_inventory.md`
- `explorations/coyote-gis-clustering/output/coyote_points_cleaned.geojson`
- `explorations/coyote-gis-clustering/output/context_layers_manifest.csv`
- `explorations/coyote-gis-clustering/output/clustering_results.csv`
- `explorations/coyote-gis-clustering/output/reporting_bias_diagnostics.csv`
- `explorations/coyote-gis-clustering/output/other_towns_catalog.csv`
- `explorations/coyote-gis-clustering/output/methods_memo.md`
- `explorations/coyote-gis-clustering/output/results_memo.md`
- `explorations/coyote-gis-clustering/output/blog_post_draft.md`
- `explorations/coyote-gis-clustering/output/figure_notes.md`
- `quality_reports/review_r_coyote-gis-analysis.md`
- `quality_reports/review_domain_coyote-gis-analysis.md`
- `quality_reports/proofread_coyote-gis-blog.md`
- `quality_reports/verifier_coyote-gis-analysis.md`
- `quality_reports/adversarial_coyote-gis_round1.md`
- `quality_reports/adversarial_coyote-gis_round2.md`

If some deliverables are not feasible, explain exactly why in the results memo.

## Data-acquisition expectations

Use the web and local filesystem aggressively but carefully. For each source,
record:

- URL
- file type
- download date
- jurisdiction
- coordinate reference system if known
- relevant fields
- limitations

Prioritize authoritative sources:

- town GIS or ArcGIS/OpenData portals
- municipal PDF or metadata pages
- MassGIS layers
- town 311 or animal-control pages if relevant
- official conservation, parcel, road, and open-space data

Keep a clear distinction between:

- official source data
- derived layers you create
- contextual interpretation from local documents or news stories

## Main analytical design

This project should not be one-method or one-map. Use several complementary
approaches and compare them.

### 1. Descriptive spatial reconnaissance

Start with:

- point maps with careful basemap/context choices
- by-date or by-period summaries if dates exist
- duplicate or near-duplicate checks
- simple nearest-neighbor diagnostics
- counts by neighborhood or custom grid if useful

But treat this only as setup, not as the conclusion.

### 2. Point-pattern and hotspot methods

Use multiple clustering methods where the data support them, such as:

- nearest neighbor index
- Ripley's K or L
- kernel density estimation
- local Moran's I on aggregated units if aggregation is justified
- Getis-Ord Gi* hotspot analysis if a gridded or areal framework makes sense
- DBSCAN or similar density-based clustering
- quadrat-based tests

For each method, explain:

- what the method captures
- what tuning choices matter
- how sensitive the findings are to scale and parameter choices

### 3. Ecological-context analysis

Test whether clusters align with plausible coyote habitat or movement features.
Potential layers:

- parks and conservation land
- woods / tree cover / land cover
- cemeteries
- streams and wetlands
- rail corridors and utility corridors
- school campuses and athletic fields
- parcels with low density or large setbacks
- edges between developed and undeveloped land

Possible analyses:

- distance-to-feature comparisons
- point-in-polygon rates
- buffer overlaps
- matched random-point comparisons within Belmont
- simple predictive models distinguishing sighting points from random points

Be explicit that alignment with habitat-like features is suggestive, not proof.

### 4. Reporting-bias and super-caller diagnostics

This is central. Treat it as seriously as the clustering analysis.

Look for evidence consistent with reporting concentration:

- repeated points at or near the same address
- repeated reports in narrow time windows
- unusual concentration along particular streets or around a few homes
- patterns strongly aligned with population density or sidewalk-level observer
  exposure rather than habitat
- bursts following local publicity or seasonal awareness campaigns
- note text that looks duplicated or standardized
- multiple incidents snapped to the same geocoded location

If reporter identifiers exist, use them carefully and ethically. If they do not,
design indirect diagnostics such as:

- de-duplicating by time-place windows
- clustering after collapsing repeated locations
- comparing raw points to unique-location points
- comparing daytime and nighttime patterns if timestamps exist
- measuring how much the pattern changes when the top repeated locations are
  removed

### 5. Counterfactual and robustness work

This project needs robustness checks, not just one preferred map.

At minimum, test some of:

- alternative bandwidths for KDE
- alternative DBSCAN parameters
- unique-location versus raw-report analysis
- excluding top repeated addresses
- excluding obvious duplicates
- separate analyses by season or year if dates exist
- different spatial aggregation schemes
- random-point baselines within town boundaries
- alternative contextual-feature sets

State clearly which conclusions survive these checks.

## Super-caller inference standard

Be disciplined here. You are allowed to make a careful argument, not a cheap
gotcha claim.

Use language like:

- "consistent with"
- "hard to reconcile with"
- "more suggestive of observer concentration than habitat concentration"

Avoid language like:

- "proves there was a super-caller"
- "shows the reports are fake"
- "demonstrates where coyotes truly live"

If the evidence is mixed, say so.

## Other Massachusetts towns sidecar

After the Belmont analysis is underway, spend some time scouting for fun or
weird GIS data published by other Massachusetts towns.

Examples of what might qualify:

- wildlife sightings
- rat complaints
- tree inventories with colorful attributes
- sidewalk defects
- snow complaints
- beaver activity
- geocoded historical oddities
- hyperlocal code-enforcement layers
- anything unexpectedly vivid, peculiar, or analytically rich

This sidecar should not overwhelm the main story. Good outputs:

- a compact catalog of interesting towns/datasets
- one or two mini-analyses or maps if feasible
- a short sidebar section in the blog post

## Blog-post requirements

Write for a smart general audience. The tone can be lively and a bit amused,
but the empirical spine should stay serious.

The blog post should roughly include:

1. A strong opening with the Belmont coyote question.
2. Why clustering in sighting data is harder to interpret than it looks.
3. What data were obtained and how reliable they are.
4. The spatial-analysis strategy in plain English.
5. Main findings on clustering.
6. Main findings on habitat-context versus reporting-bias explanations.
7. A clear section on the super-caller hypothesis:
   - what supports it
   - what weakens it
   - bottom-line judgment
8. A short section on other weird Massachusetts municipal GIS data.
9. A limitations section.
10. A conclusion that says what we learned and what remains unknowable.

If possible, produce simple but persuasive visuals such as:

- cleaned point map
- KDE or hotspot map
- map with context layers like parks/woods/rail
- plot showing how clustering changes after de-duplication or removal of top
  repeated locations
- compact table of unusual other-town datasets

## Mandatory specialist workflow

This repository's workflow is strongest when specialist review is used
explicitly. For this project, treat the following as default.

### Required specialist agents

Use these repo agents explicitly when their scope exists:

- `r-reviewer`
  - Review any substantial R analysis code, spatial-statistics code, data
    cleaning code, or figure-generation code you create.
- `domain-reviewer`
  - Review the GIS interpretation, ecological plausibility claims, reporting-
    bias logic, and whether the blog post's substantive conclusions outrun the
    data.
- `proofreader`
  - Review the final blog draft for clarity, overstatement, awkward wording,
    and whether the narrative remains evidence-based.
- `verifier`
  - Run a final package-level verification pass checking that all cited maps,
    outputs, and claims are supported by the artifacts.

### Delegation rules

1. After the first serious implementation pass, explicitly launch the relevant
   specialist agents rather than relying only on self-review.
2. Run independent specialists in parallel when possible.
3. Save each specialist's findings into `quality_reports/` in a durable report.
4. Fix material findings before declaring the task complete.
5. In the final summary, say exactly which specialist agents were used, what
   they found, and what remains unresolved.

### Strongly encouraged extra delegation

If the task becomes large enough, also use Codex subagents beyond the repo
specialists. Good examples:

- a data-scouting worker focused on municipal portals and shapefile retrieval
- a methods skeptic focused on spatial inference and multiple-testing issues
- a map-design editor focused on figure readability and narrative sequencing

Keep subagent scopes narrow and durable.

## Adversarial review requirement

This task should use an adversarial critic/fixer loop.

After you have:

- a methods memo
- a results memo
- a draft blog post
- at least one clustering output and one reporting-bias diagnostic output

run an explicit critic/fixer cycle.

### Round 1

1. Spawn or assign a **critic** whose job is to attack the work, not defend it.
2. The critic should look for:
   - weak inference from observational point data
   - hotspot methods used decoratively rather than substantively
   - over-interpretation of habitat alignment
   - failure to rule out duplicate-report or repeat-location artifacts
   - CRS or geometry mistakes
   - scale dependence swept under the rug
   - map choices that exaggerate certainty
   - claims about super-callers unsupported by the data
3. Save the critique to:
   - `quality_reports/adversarial_coyote-gis_round1.md`
4. Apply fixes to the analysis, memos, and blog draft.

### Round 2

1. Re-run the critic or an equivalent skeptical reviewer on the revised work.
2. Save the re-audit to:
   - `quality_reports/adversarial_coyote-gis_round2.md`
3. If major defects remain, keep iterating until the project reaches the target
   quality threshold or you hit a clearly documented blocker.

## Preferred workflow sequence

1. Reconnaissance and feasibility audit.
2. Download and inventory Belmont and context layers.
3. Clean and standardize geometries and attributes.
4. Produce descriptive maps and preliminary diagnostics.
5. Run multiple clustering methods.
6. Run reporting-bias and super-caller diagnostics.
7. Run ecological-context analyses.
8. Scout and optionally analyze sidecar datasets from other towns.
9. Write methods memo and results memo.
10. Draft the blog post.
11. Run specialist reviews.
12. Run adversarial critic/fixer loop.
13. Re-verify and score.

## Verification requirements

Before declaring success, verify:

- every output file you claim exists actually exists
- town boundaries and coordinate systems were handled correctly
- map captions match the underlying analysis
- the methods memo matches the implemented analysis
- the blog post's claims are supported by the results memo
- uncertainty and limitations are explicit

If you run code, save scripts in `src/` and write enough notes that another
person could reproduce the workflow with the same inputs.

## Review expectations

This task is substantial enough that specialist review is expected by default.
At minimum, you must:

- run the required repo specialists that match the artifacts you created
- run the adversarial critic/fixer loop above
- do a serious final self-review focused on:
  - spatial-inference quality
  - geospatial-data integrity
  - ecological interpretation
  - reporting-bias logic
  - writing quality
  - whether the blog-post claims outrun the evidence

## What good completion looks like

A successful run does **not** require perfect municipal data. It does require:

- intellectual honesty
- multiple real spatial-analysis methods
- explicit confrontation with reporting bias
- reproducible outputs
- durable specialist-review artifacts
- an adversarial re-audit after fixes
- a lively but careful blog draft

The best possible version of this project will feel like a real small-scale
investigative GIS piece, not just a local curiosity map.

Start by reading the repo guidance, then create the plan and feasibility audit.

---
