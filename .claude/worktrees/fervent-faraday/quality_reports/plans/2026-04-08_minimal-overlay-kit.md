# Plan: minimal overlay kit

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Create a minimal per-repo overlay kit that standardizes this workflow's default
behavior across many repos using only a few repo-specific fields, while
preserving each repo's existing agents, plans, and verification conventions.

## Scope

- In scope:
  - Create a compact template centered on five repo-specific fields.
  - Add a short usage guide explaining how to roll the kit out quickly.
  - Keep the kit lighter than the broader integration overlay template.
- Out of scope:
  - Installing the kit into external repos.
  - Replacing the existing broader overlay template.
  - Creating repo-specific agent mappings for any one project.

## Assumptions and clarifications

- CLEAR: The user wants a fast-rollout kit for many repos.
- ASSUMED: The most important reusable defaults are planning, durable state,
  explicit review, verification, and completion standards.
- ASSUMED: Five repo-level fields are enough to adapt the workflow to most
  existing repos without major restructuring.
- BLOCKED: None.

## Files likely to change

- `templates/minimal-workflow-overlay-kit.md`
- `templates/minimal-workflow-overlay-usage.md`
- `quality_reports/plans/2026-04-08_minimal-overlay-kit.md`
- `quality_reports/session_logs/2026-04-08_minimal-overlay-kit.md`

## Implementation approach

1. Define the five repo-specific fields that matter most.
2. Write a copy-ready root `AGENTS.md` overlay template using only those fields.
3. Add a short usage guide for fast rollout across many repos.
4. Verify that the kit is compact, concrete, and consistent with the broader
   workflow.

## Verification plan

- Compile / render: Not applicable.
- Run scripts / tests: Not applicable.
- Manual checks:
  - Confirm the template is materially smaller than the broader overlay.
  - Confirm the five fields cover plan path, log path, specialist mapping,
    verification, and quality threshold.
  - Confirm the guide explains how to use the kit at scale.
- Reports to write:
  - Update session log with design and verification notes.

## Review plan

- Specialists to spawn: None.
- Whether adversarial QA is needed: No.
- Final quality threshold: 90

## Risks

- Risk: The kit could become too compressed and lose practical usefulness.
- Mitigation: Include a copy-ready markdown block and a concrete checklist.
- Risk: Different repos may need slightly different field sets.
- Mitigation: Define the five fields as defaults, not rigid law.
