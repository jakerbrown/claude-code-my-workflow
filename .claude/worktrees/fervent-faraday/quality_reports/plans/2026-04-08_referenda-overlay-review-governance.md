# Plan: referenda overlay review governance

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Revise the reusable workflow integration overlay so a referenda-style repo
integration inherits explicit default multi-agent review mappings and a scoped
adversarial-review rule for high-stakes changes.

## Scope

- In scope:
  - Update the broader integration overlay template.
  - Add explicit default review-role mappings that an external repo can adapt.
  - Add a scoped rule defining when adversarial review is expected for
    high-stakes changes.
  - Record the work in a durable session log.
- Out of scope:
  - Installing the overlay into the external referenda repo itself.
  - Creating new custom agents for that repo.
  - Changing Codex runtime behavior beyond repo-local guidance.

## Assumptions and clarifications

- CLEAR: The user wants the integration guidance strengthened for a referenda
  repo adoption path.
- ASSUMED: The correct place to express this is the reusable overlay template
  that would be copied into the target repo.
- ASSUMED: "High-stakes" should be scoped narrowly enough to avoid making
  adversarial review mandatory for ordinary low-risk changes.
- BLOCKED: None.

## Files likely to change

- `templates/workflow-integration-overlay.md`
- `templates/minimal-workflow-overlay-usage.md`
- `quality_reports/plans/2026-04-08_referenda-overlay-review-governance.md`
- `quality_reports/session_logs/2026-04-08_referenda-overlay-review-governance.md`

## Implementation approach

1. Replace generic product-repo review examples with referenda-compatible ones.
2. Add a concrete default multi-agent mapping for analysis, domain, workflow,
   and verification roles.
3. Tighten the adversarial-review rule around narrowly scoped high-stakes
   surfaces.
4. Re-read the edited docs for consistency and repo fit.

## Verification plan

- Compile / render: Not applicable.
- Run scripts / tests: Not applicable.
- Manual checks:
  - Confirm the overlay now provides copy-ready default multi-agent mappings.
  - Confirm the high-stakes adversarial rule is explicit but scoped.
  - Confirm the guidance still preserves repo-specific agents and local
    verification authority.
- Reports to write:
  - Matching session log with decisions and verification notes.

## Review plan

- Specialists to spawn: None.
- Whether adversarial QA is needed: No; this is a bounded workflow-doc edit.
- Final quality threshold: 90

## Risks

- Risk: The overlay could become too prescriptive for non-referenda repos.
- Mitigation: Keep the new rules framed as defaults that map onto existing repo
  specialists.
- Risk: "High-stakes" could be vague and over-trigger adversarial review.
- Mitigation: Define the trigger by impact categories and require explicit scope
  statements.
