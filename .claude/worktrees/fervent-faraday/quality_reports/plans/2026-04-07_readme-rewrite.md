# Plan: README rewrite

- **Date:** 2026-04-07
- **Status:** COMPLETED
- **Owner:** Codex / user
- **Quality target:** 90

## Goal

Rewrite the root `README.md` so it accurately explains this repository as a
Codex-focused port of the original Claude workflow, properly credits the
upstream source, and helps a new user understand what the repo does, how it was
converted, how to use it, and where the Codex version faithfully emulates or
differs from the original workflow.

## Scope

- In scope:
  - Replace the current Claude-oriented root README with Codex-port messaging
  - Credit the upstream `pedrohcgs/claude-code-my-workflow` repository
  - Explain the Codex-native architecture and artifact layout
  - Explain how to use the repo in Codex app or Codex CLI
  - Reflect the repo's stronger default-governance language around specialist
    review, adversarial QA, quality thresholds, and durable context
  - Explain where the Codex port is faithful to the original Claude workflow
  - Explain where the Codex port differs, including strengths and limitations
- Out of scope:
  - Changing workflow behavior, hooks, rules, or skills
  - Updating the rendered docs site
  - Deep behavioral validation beyond documentation-level verification

## Assumptions and clarifications

- CLEAR:
  - The user wants a new root README, not a minor patch.
  - The README should describe the repo as it exists today, not as the original
    Claude version described it.
- ASSUMED:
  - Upstream credit should name Pedro Sant'Anna's repository and present this
    repo as a forked or cloned Codex-first port.
  - The README should remain practical and welcoming rather than exhaustive.
- BLOCKED:
  - None for this pass.

## Files likely to change

- `README.md`
- `quality_reports/plans/2026-04-07_readme-rewrite.md`
- `quality_reports/session_logs/2026-04-07_readme-rewrite.md`

## Implementation approach

1. Inspect the current root README, core workflow docs, and git remotes.
2. Draft a new README structure that centers the Codex port while preserving
   proper attribution to the original repo.
3. Rewrite the README with sections for overview, credit, architecture, usage,
   and a Claude-vs-Codex comparison.
4. Re-read the new README against current repo structure and durable docs.
5. Refresh the README so it reflects the repo's stronger default workflow
   expectations after the governance update.
6. Record the work and verification in the session log.

## Verification plan

- Compile / render:
  - Not applicable for this markdown rewrite.
- Run scripts / tests:
  - None.
- Manual checks:
  - Re-read `README.md` for accuracy against `AGENTS.md`,
    `docs/CODEX_WORKFLOW.md`, and `docs/PORTING_MAP.md`.
  - Confirm upstream credit matches the configured git remote.
  - Confirm all referenced directories and files exist.
- Reports to write:
  - This plan
  - Matching session log

## Review plan

- Specialists to spawn:
  - None; this is a bounded documentation task.
- Whether adversarial QA is needed:
  - No.
- Final quality threshold:
  - 90 for PR-ready documentation.

## Risks

- Risk:
  - The README could overclaim workflow maturity.
- Mitigation:
  - Distinguish clearly between implemented structure and in-practice
    validation.

- Risk:
  - The README could become too long and duplicate the deeper docs.
- Mitigation:
  - Keep the README high-signal and point readers to `docs/` for detail.
