# Plan: ward_sim integration overlay update

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Revise the reusable workflow-integration guidance so a ward_sim-style repo can
adopt this workflow with explicit default multi-agent review mappings and a
scoped adversarial-review rule that is reserved for high-stakes changes.

## Scope

- In scope:
  - Update the integration overlay template to encode stronger default
    multi-agent review guidance.
  - Add a scoped adversarial-review rule for high-stakes changes.
  - Keep the minimal overlay kit and usage guidance aligned with the updated
    integration pattern.
  - Record the work in durable plan and session-log artifacts.
- Out of scope:
  - Editing the external `ward_sim` repository directly.
  - Introducing new repo skills or automation.
  - Reworking unrelated starter-pack documentation.

## Assumptions and clarifications

- CLEAR: The request is to improve the workflow integration materials used for a
  ward_sim integration, not to modify ward_sim in this workspace.
- ASSUMED: ward_sim already has local agents, reviewers, or command suites that
  should remain authoritative once mapped into the overlay.
- ASSUMED: "Scoped adversarial-review rule" means using adversarial review only
  for higher-risk changes such as release-sensitive, architecture-sensitive, or
  correctness-critical work.
- BLOCKED: No direct ward_sim repo context is available in this workspace, so
  the change will stay template-oriented.

## Files likely to change

- `templates/workflow-integration-overlay.md`
- `templates/minimal-workflow-overlay-kit.md`
- `templates/minimal-workflow-overlay-usage.md`
- `quality_reports/plans/2026-04-08_ward-sim-integration.md`
- `quality_reports/session_logs/2026-04-08_ward-sim-integration.md`

## Implementation approach

1. Update the broader overlay template so it explicitly defaults to mapped
   multi-agent review when tasks match the repo's reviewer set.
2. Add a concrete, scoped adversarial-review section that limits the critic /
   fixer pattern to high-stakes changes and requires an explicit summary when
   skipped.
3. Mirror the new expectations into the minimal overlay kit and usage notes,
   then verify the three docs read consistently together.

## Verification plan

- Compile / render: Not applicable.
- Run scripts / tests: Not applicable.
- Manual checks:
  - Confirm the overlay still preserves the target repo's existing agents and
    planning surfaces.
  - Confirm multi-agent review is framed as the default when the task maps
    cleanly onto the repo's reviewer set.
  - Confirm adversarial review is clearly scoped to high-stakes changes rather
    than applied indiscriminately.
  - Confirm the minimal kit and usage notes match the broader overlay.
- Reports to write:
  - Update the session log after plan creation and wrap-up.

## Review plan

- Specialists to spawn: None; this is a narrow documentation/infrastructure
  update.
- Whether adversarial QA is needed: No; the task is defining the policy, not
  exercising a high-stakes target repo workflow.
- Final quality threshold: 90

## Risks

- Risk: The new guidance could imply automatic agent spawning that Codex does
  not provide.
- Mitigation: Keep the language explicit that the mapping is a workflow default
  and still requires intentional runtime delegation.
- Risk: The adversarial-review rule could be too vague to apply consistently.
- Mitigation: Include concrete high-stakes trigger examples and a lightweight
  fallback for lower-stakes tasks.
