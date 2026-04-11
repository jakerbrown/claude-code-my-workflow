# Plan: referenda integration gap evaluation

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Evaluate which features of `codex-my-workflow` are not yet well integrated into
the local `referenda` repo.

## Scope

- In scope:
  - Compare workflow infrastructure and guidance between the two repos.
  - Identify missing, partial, or weakly integrated features in `referenda`.
  - Produce a concrete gap assessment grounded in files on disk.
- Out of scope:
  - Implementing the missing integrations in `referenda`.
  - Auditing the entire referenda codebase for unrelated bugs.

## Assumptions and clarifications

- CLEAR: The task is evaluative, not an implementation pass.
- ASSUMED: "Well integrated" means present on disk, adapted to repo context,
  and reinforced by guidance or durable workflow artifacts rather than copied
  mechanically.
- BLOCKED: None.

## Files likely to inspect

- `AGENTS.md`
- `KNOWLEDGE_BASE.md`
- `MEMORY.md`
- `.codex/`
- `.agents/skills/`
- `docs/`
- `templates/`
- `quality_reports/`
- matching workflow surfaces in `/Users/jacobbrown/Documents/GitHub/referenda`

## Implementation approach

1. Inventory the workflow features in `codex-my-workflow`.
2. Inspect the corresponding workflow surfaces in `referenda`.
3. Classify gaps as missing, partial, or well integrated.
4. Summarize the highest-value missing integrations first.

## Verification plan

- Compile / render: Not applicable.
- Run scripts / tests: Not applicable.
- Manual checks:
  - Confirm findings are tied to concrete files or absent paths.
  - Distinguish missing infrastructure from repo-specific intentional omissions.
  - Keep the evaluation focused on workflow integration rather than domain code.
- Reports to write:
  - Matching session log with inspection notes and final assessment.

## Review plan

- Specialists to spawn: None.
- Whether adversarial QA is needed: No.
- Final quality threshold: 90

## Risks

- Risk: Overstating a gap when referenda intentionally uses a different local
  mechanism.
- Mitigation: Check for equivalent structures and note when a feature is
  present under a different name or path.
