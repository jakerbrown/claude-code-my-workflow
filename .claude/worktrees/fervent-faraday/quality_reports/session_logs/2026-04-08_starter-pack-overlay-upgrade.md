# Session Log: starter pack overlay upgrade

- **Date:** 2026-04-08
- **Status:** COMPLETED

## Current objective

Upgrade the starter pack docs and templates so they better fit overlay-style
integration into existing repos.

## Timeline

### 16:21 — Plan approved
- Summary:
  - Began a starter-pack revision pass based on the referenda integration
    lessons.
- Files in play:
  - `templates/workflow-integration-overlay.md`
  - `templates/minimal-workflow-overlay-kit.md`
  - `templates/minimal-workflow-overlay-usage.md`
  - `docs/CODEX_WORKFLOW.md`
  - `docs/PORTING_MAP.md`
  - new integration-helper templates
- Next step:
  - Update the overlay model and add phased integration artifacts.

### 16:31 — Design decision
- Decision:
  - Recast the starter pack as a high-integration overlay kit for existing
    repos, rather than implying a literal copy of the whole pack should be the
    default.
- Why:
  - The referenda integration showed that the strongest pattern is preserving
    host planning and domain-doc authority while porting most of the workflow
    machinery in phases.
- Impact:
  - The revised docs and templates now emphasize host-native durable state,
    phased adoption, and direct-port vs adapt vs skip decisions.

### 16:36 — Verification
- Command or method:
  - Re-read the updated overlay templates, the new migration-checklist and
    roadmap templates, the root workflow guide, and the mirrored
    `codex_port_starter` docs.
- Result:
  - Verified that the starter pack now teaches overlay-first adoption,
    host-native durable-state adaptation, and phased Milestone A/B/C
    integration.
- Notes:
  - The repo already had unrelated uncommitted changes in other files, so this
    pass was kept scoped to the starter-pack integration materials.

## End-of-session summary

- What changed:
  - Updated the broader and minimal overlay templates to support host-native
    durable state and phased adoption.
  - Added `templates/repo-integration-roadmap.md`.
  - Added `templates/existing-repo-migration-checklist.md`.
  - Updated `docs/CODEX_WORKFLOW.md` and `docs/PORTING_MAP.md` with
    overlay-first, Milestone A/B/C, and direct-port / adapt / skip guidance.
  - Synced the mirrored `codex_port_starter` workflow guide and porting map.
- What was verified:
  - Re-read the revised starter-pack docs and templates for internal
    consistency and checked that the new guidance matched the referenda-tested
    integration pattern.
- Remaining work:
  - The starter-pack revision is complete for this pass.
  - A future follow-up could propagate the same framing into any remaining
    starter-facing docs or examples if needed.
