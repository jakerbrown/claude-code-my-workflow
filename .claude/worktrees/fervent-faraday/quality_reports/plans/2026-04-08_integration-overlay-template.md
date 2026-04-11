# Plan: integration overlay template

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Create a small reusable integration template for repositories that already have
their own specialized agents and planning documents, so they can adopt this
workflow's methods without replacing existing infrastructure.

## Scope

- In scope:
  - Create a markdown template that shows how to layer workflow rules on top of
    existing repo agents and plan docs.
  - Keep the template lightweight and adaptation-oriented.
  - Include concrete mapping fields for existing agents, plan locations, and
    verification expectations.
- Out of scope:
  - Installing the template into a specific external repo.
  - Rewriting this repository's existing starter pack again.
  - Creating automation or repo-specific skill implementations.

## Assumptions and clarifications

- CLEAR: The user wants an integration template, not a full migration.
- ASSUMED: Target repos may already have strong domain-specific agents and
  planning conventions worth preserving.
- ASSUMED: The value to add is orchestration guidance, durable memory, and a
  consistent completion standard.
- BLOCKED: None.

## Files likely to change

- `templates/workflow-integration-overlay.md`
- `quality_reports/plans/2026-04-08_integration-overlay-template.md`
- `quality_reports/session_logs/2026-04-08_integration-overlay-template.md`

## Implementation approach

1. Write a minimal overlay template centered on preserving existing repo assets.
2. Include ready-to-copy sections for `AGENTS.md`, agent mapping, plan/log
   locations, verification rules, and completion standards.
3. Verify clarity and repo fit by rereading the template after creation.

## Verification plan

- Compile / render: Not applicable.
- Run scripts / tests: Not applicable.
- Manual checks:
  - Confirm the template assumes existing agents and plans instead of replacing
    them.
  - Confirm it provides a concrete structure the user can adapt quickly.
  - Confirm it stays small rather than turning into a full starter pack.
- Reports to write:
  - Update session log with design decision and verification notes.

## Review plan

- Specialists to spawn: None.
- Whether adversarial QA is needed: No.
- Final quality threshold: 90

## Risks

- Risk: The template could be too abstract to be immediately useful.
- Mitigation: Include copy-ready scaffolding and field placeholders.
- Risk: The template could accidentally prescribe replacing good existing repo
  structures.
- Mitigation: Make preservation of existing agents and plans a first-class
  principle.
