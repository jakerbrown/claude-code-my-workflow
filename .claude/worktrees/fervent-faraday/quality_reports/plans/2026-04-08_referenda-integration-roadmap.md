# Plan: referenda integration roadmap

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Turn the referenda gap assessment into a prioritized integration roadmap that
can guide future workflow upgrades in the `referenda` repo.

## Scope

- In scope:
  - Draft a phased roadmap for integrating the missing workflow features into
    `referenda`.
  - Write the roadmap into `referenda`'s memo system.
  - Record the work in both repos' durable logs.
- Out of scope:
  - Implementing the roadmap itself in this turn.
  - Porting slide- or Quarto-specific functionality that does not fit
    `referenda`.

## Assumptions and clarifications

- CLEAR: The user wants a roadmap next, not the implementation pass yet.
- ASSUMED: The roadmap should preserve `referenda`'s memo/ExecPlan system and
  source-policy rules as authoritative.
- ASSUMED: Not every feature in `codex-my-workflow` should be copied verbatim;
  some need adaptation and some are out of scope.
- BLOCKED: None.

## Files likely to change

- `quality_reports/plans/2026-04-08_referenda-integration-roadmap.md`
- `quality_reports/session_logs/2026-04-08_referenda-integration-roadmap.md`
- `/Users/jacobbrown/Documents/GitHub/referenda/memos/referenda-codex-integration-roadmap-2026-04-08.md`
- `/Users/jacobbrown/Documents/GitHub/referenda/memos/session_logs/2026-04-08_integration-roadmap.md`
- `/Users/jacobbrown/Documents/GitHub/referenda/memos/codex_activity/2026-04-08_integration-roadmap.md`

## Implementation approach

1. Synthesize the identified gaps into a phased roadmap.
2. Prioritize portable, high-leverage infrastructure first.
3. Separate direct ports from repo-specific adaptations and out-of-scope items.
4. Save the roadmap in `referenda`'s existing durable planning surfaces.

## Verification plan

- Compile / render: Not applicable.
- Run scripts / tests: Not applicable.
- Manual checks:
  - Confirm the roadmap fits `referenda`'s existing planning conventions.
  - Confirm the phases are prioritized and actionable.
  - Confirm slide/Quarto-specific features are excluded or adapted honestly.
- Reports to write:
  - Matching session log in this repo.
  - Memo/session-log breadcrumb artifacts in `referenda`.

## Review plan

- Specialists to spawn: None.
- Whether adversarial QA is needed: No.
- Final quality threshold: 90

## Risks

- Risk: The roadmap could over-prescribe features that do not fit the repo.
- Mitigation: Mark items as direct port, adapt, or skip.

## Follow-through

- 2026-04-08:
  - Milestone A was executed in `referenda` as a first-pass implementation with
    a local `.codex/` control plane, five repo-local skills, and updated root
    guidance / README workflow docs.
