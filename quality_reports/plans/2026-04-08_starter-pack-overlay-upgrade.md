# Plan: starter pack overlay upgrade

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Revise the starter pack so it better supports integrating nearly all of this
workflow into existing projects while adapting to host-repo planning systems,
domain docs, and durable-state surfaces.

## Scope

- In scope:
  - Update the integration overlay and minimal overlay templates.
  - Update the workflow guide to emphasize overlay-first and phased adoption.
  - Add guidance for direct-port vs adapt vs skip decisions.
  - Add a migration checklist and phased roadmap template for existing repos.
- Out of scope:
  - Reworking the entire starter pack structure.
  - Changing slide- or Quarto-specific workflow logic beyond how it is
    presented to adopters.

## Assumptions and clarifications

- CLEAR: The user wants the starter pack updated based on the successful
  referenda integration pattern.
- ASSUMED: The starter should default to host-native durable state when a repo
  already has strong planning and documentation surfaces.
- ASSUMED: The right abstraction is a high-integration overlay kit, not a
  literal full-copy migration by default.
- BLOCKED: None.

## Files likely to change

- `templates/workflow-integration-overlay.md`
- `templates/minimal-workflow-overlay-kit.md`
- `templates/minimal-workflow-overlay-usage.md`
- `docs/CODEX_WORKFLOW.md`
- `docs/PORTING_MAP.md`
- `templates/repo-integration-roadmap.md`
- `templates/existing-repo-migration-checklist.md`
- `quality_reports/plans/2026-04-08_starter-pack-overlay-upgrade.md`
- `quality_reports/session_logs/2026-04-08_starter-pack-overlay-upgrade.md`

## Implementation approach

1. Shift the docs toward an overlay-first adoption model.
2. Add phased integration guidance modeled on Milestones A, B, and C.
3. Add a reusable direct-port / adapt / skip matrix.
4. Add migration-checklist and phased-roadmap templates.
5. Re-read the edited docs for internal consistency.

## Verification plan

- Compile / render: Not applicable.
- Run scripts / tests: Not applicable.
- Manual checks:
  - Confirm the starter now supports host-native durable state explicitly.
  - Confirm phased adoption is clear and actionable.
  - Confirm direct-port / adapt / skip guidance is easy to apply.
  - Confirm slide/Quarto-specific features are framed as optional for unrelated repos.
- Reports to write:
  - Matching session log with decisions and verification notes.

## Review plan

- Specialists to spawn: None.
- Whether adversarial QA is needed: No.
- Final quality threshold: 90

## Risks

- Risk: The docs could become too broad or repetitive.
- Mitigation: Keep the new guidance high-signal and put the structure into
  reusable templates.
