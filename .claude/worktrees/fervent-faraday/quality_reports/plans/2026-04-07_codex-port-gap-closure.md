# Plan: Codex port gap closure

- **Date:** 2026-04-07
- **Status:** COMPLETED
- **Owner:** Codex / user
- **Quality target:** 90

## Goal

Bring the Codex port's durable workflow artifacts into tighter alignment with the
repo's actual current state so future work starts from accurate guidance. The
current pass focuses on infrastructure documentation, durable planning, and a
clear gap list rather than adding new runtime features.

## Scope

- In scope:
  - Draft the first durable plan for Codex-port continuation work
  - Draft a matching session log for this implementation pass
  - Reconcile `docs/PORTING_MAP.md` against the repo's actual agents and skills
  - Populate `KNOWLEDGE_BASE.md` with real Codex-port conventions and pitfalls
  - Document read-only reconnaissance and infrastructure verification guidance
  - Identify the next highest-value Codex-port follow-up tasks
- Out of scope:
  - Editing skill internals or agent configs
  - Changing hooks, rules, or permissions
  - Running slide, Quarto, or R-content verification

## Assumptions and clarifications

- CLEAR:
  - The user wants execution to continue, not just planning.
  - This task is infrastructure-focused and should avoid broad behavioral
    changes.
- ASSUMED:
  - A docs-reality reconciliation pass should update stale status language even
    if some implemented skills still need later validation.
  - This task can proceed without changing `MEMORY.md` because the current
    lessons already match the observed workflow.
- BLOCKED:
  - None for this pass.

## Files likely to change

- `quality_reports/plans/2026-04-07_codex-port-gap-closure.md`
- `quality_reports/session_logs/2026-04-07_codex-port-gap-closure.md`
- `KNOWLEDGE_BASE.md`
- `docs/CODEX_WORKFLOW.md`
- `docs/PORTING_MAP.md`

## Implementation approach

1. Read root guidance, workflow docs, and reusable templates.
2. Create durable plan and session-log artifacts for the Codex-port workstream.
3. Compare the documented port map against the repo's actual `.codex/agents/`
   and `.agents/skills/` contents, then update stale sections.
4. Populate `KNOWLEDGE_BASE.md` with stable workflow conventions, artifact
   meanings, design principles, anti-patterns, and pitfalls.
5. Extend `docs/CODEX_WORKFLOW.md` with lightweight reconnaissance and
   infrastructure-verification guidance.
6. Summarize verified changes, remaining gaps, and the next recommended wave.

## Verification plan

- Compile / render:
  - Not applicable for this docs-and-infrastructure pass.
- Run scripts / tests:
  - Use shell inspection to confirm referenced agents, skills, and directories
    actually exist.
- Manual checks:
  - Re-read updated `KNOWLEDGE_BASE.md` for internal consistency with root and
    nested guidance.
  - Re-read updated `docs/PORTING_MAP.md` for internal consistency.
  - Re-read updated `docs/CODEX_WORKFLOW.md` to ensure the new guidance fits the
    existing contractor loop.
  - Confirm plan and session-log naming follows repo conventions.
- Reports to write:
  - This plan
  - Matching session log

## Review plan

- Specialists to spawn:
  - None for this initial pass; the task is small and primarily documentary.
- Whether adversarial QA is needed:
  - No, but a later meta-review of skills/docs alignment would be valuable.
- Final quality threshold:
  - 90 for PR-ready documentation alignment.

## Risks

- Risk:
  - Documentation may overstate implementation maturity if "implemented" is read
    as "fully validated."
- Mitigation:
  - Use language that distinguishes "present in repo" from "battle-tested in
    practice."

- Risk:
  - The first plan may be too broad for one sitting.
- Mitigation:
  - Keep this pass limited to durable artifacts plus docs reconciliation, then
    stage later waves separately.
