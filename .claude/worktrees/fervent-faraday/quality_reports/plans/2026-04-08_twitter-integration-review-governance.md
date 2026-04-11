# Plan: twitter integration review governance

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Revise the workflow integration guidance intended for a large application repo
such as the twitter repo so it explicitly includes default multi-agent review
mappings and a narrowly scoped adversarial-review rule for high-stakes changes.

## Scope

- In scope:
  - Update the integration overlay template to include copy-ready default
    specialist mappings for a software-product repo.
  - Add guidance that makes multi-agent review the default when work maps
    cleanly onto multiple existing specialists.
  - Add a scoped adversarial-review rule that applies only to high-stakes
    changes rather than all tasks.
  - Record the work in a durable plan and session log.
- Out of scope:
  - Installing the overlay into an external twitter repository.
  - Creating or renaming actual specialist agents in another repo.
  - Expanding the rule into a blanket requirement for every docs or code edit.

## Assumptions and clarifications

- CLEAR:
  - The requested change is about the integration guidance, not a live external
    repo edit.
- ASSUMED:
  - The twitter repo has its own specialists, and this overlay should map
    workflow roles onto those local reviewers rather than replace them.
  - "High-stakes changes" should mean areas such as auth, privacy, security,
    safety, payments, migrations, or irreversible production-impacting changes.
- BLOCKED:
  - None.

## Files likely to change

- `templates/workflow-integration-overlay.md`
- `quality_reports/plans/2026-04-08_twitter-integration-review-governance.md`
- `quality_reports/session_logs/2026-04-08_twitter-integration-review-governance.md`

## Implementation approach

1. Reuse the repo's existing default-review governance language where it fits.
2. Expand the integration overlay with a copy-ready multi-agent mapping section
   suitable for a large product repo.
3. Add a scoped adversarial-review section that names high-stakes categories and
   emphasizes narrow use.
4. Re-read the updated template to verify clarity, consistency, and restraint.

## Verification plan

- Compile / render:
  - Not applicable.
- Run scripts / tests:
  - None; this is a documentation-governance update.
- Manual checks:
  - Confirm the template now includes default multi-agent review mappings.
  - Confirm the adversarial-review rule is explicitly scoped to high-stakes
    changes.
  - Confirm the guidance still preserves local repo specialists and does not
    overprescribe blanket heavy review.
- Reports to write:
  - This plan
  - Matching session log

## Review plan

- Specialists to spawn:
  - None; this is a bounded workflow-doc update.
- Whether adversarial QA is needed:
  - No.
- Final quality threshold:
  - 90

## Risks

- Risk:
  - The integration guidance could become too generic to be useful for a large
    product repo.
- Mitigation:
  - Add a concrete copy-ready mapping block for product, infra, security, docs,
    and verification roles.

- Risk:
  - The adversarial-review rule could accidentally read as mandatory for routine
    changes.
- Mitigation:
  - Explicitly limit it to high-stakes categories and require lightweight
    verification for normal changes.
