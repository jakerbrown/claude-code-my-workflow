# Plan: Default review governance

- **Date:** 2026-04-07
- **Status:** COMPLETED
- **Owner:** Codex / user
- **Quality target:** 90

## Goal

Strengthen the repo's default Codex workflow so specialist review,
adversarial QA, quality thresholds, and durable context persistence become the
default expected operating mode wherever Codex can support them, while staying
honest about the runtime limits Codex still imposes.

## Scope

- In scope:
  - Update root guidance to make specialist review and quality gates default
    expectations
  - Update workflow docs to define default review behavior by artifact type
  - Update the knowledge base with the stronger default-governance conventions
  - Tighten hook reminders so they reinforce scoring, specialist review, and
    on-disk persistence
  - Preserve accurate caveats where Codex cannot automate Claude-style behavior
- Out of scope:
  - Changing Codex platform behavior beyond repo-local guidance and hooks
  - Guaranteeing automatic subagent spawning without explicit user permission
  - Implementing new specialist agents or new skills in this pass

## Assumptions and clarifications

- CLEAR:
  - The user wants the strongest possible default-governance version that
    remains truthful about Codex limitations.
  - The repo should encourage specialist review and adversarial QA by default.
- ASSUMED:
  - "By default" means default workflow expectation and default repo guidance,
    not guaranteed autonomous spawning in every session.
  - Hook reminders should nudge behavior, not invent nonexistent runtime
    capabilities.
- BLOCKED:
  - None for this pass.

## Files likely to change

- `AGENTS.md`
- `docs/CODEX_WORKFLOW.md`
- `KNOWLEDGE_BASE.md`
- `.codex/hooks/session_start.py`
- `.codex/hooks/post_tool_use_review.py`
- `quality_reports/plans/2026-04-07_default-review-governance.md`
- `quality_reports/session_logs/2026-04-07_default-review-governance.md`

## Implementation approach

1. Record the task in a durable plan and session log.
2. Update root and deep workflow guidance to make specialist review,
   adversarial QA, quality thresholds, and on-disk persistence default
   expectations.
3. Update hook reminders so startup and post-verification nudges reinforce the
   stronger defaults.
4. Re-read all updated files and confirm the new defaults are strong but still
   truthful about Codex's limits.

## Verification plan

- Compile / render:
  - Not applicable.
- Run scripts / tests:
  - None beyond direct file inspection for this governance update.
- Manual checks:
  - Re-read updated guidance for internal consistency.
  - Confirm hook text matches actual Codex limitations.
  - Confirm the docs do not promise automatic subagent spawning or a true
    `PreCompact` equivalent.
- Reports to write:
  - This plan
  - Matching session log

## Review plan

- Specialists to spawn:
  - None; this is a bounded infrastructure-guidance task.
- Whether adversarial QA is needed:
  - No.
- Final quality threshold:
  - 90 for PR-ready workflow guidance.

## Risks

- Risk:
  - Guidance could overclaim automation that Codex does not support.
- Mitigation:
  - Explicitly distinguish default workflow expectations from platform-native
    automation.

- Risk:
  - Default-governance language could become too repetitive across files.
- Mitigation:
  - Keep `AGENTS.md` concise and move detail into `docs/CODEX_WORKFLOW.md` and
    `KNOWLEDGE_BASE.md`.
