# Session Log: referenda integration gap evaluation

- **Date:** 2026-04-08
- **Status:** COMPLETED

## Current objective

Compare `codex-my-workflow` against the local `referenda` repo and identify
which workflow features are not yet well integrated.

## Timeline

### 15:50 — Plan approved
- Summary:
  - Started a read-only comparison between this workflow repo and the local
    referenda repo.
- Files in play:
  - `AGENTS.md`
  - `KNOWLEDGE_BASE.md`
  - `MEMORY.md`
  - `.codex/`
  - `.agents/skills/`
  - `docs/`
  - `templates/`
  - `quality_reports/`
  - `/Users/jacobbrown/Documents/GitHub/referenda`
- Next step:
  - Inventory the referenda repo's workflow surfaces and compare them to the
    starter workflow features.

### 15:56 — Important decision
- Decision:
  - Treat `referenda` as a partial integration rather than a missing-from-scratch
    case because it already adopted the root overlay, durable memory files, memo
    planning, and session logs.
- Why:
  - The repo has clearly integrated the lightweight overlay design, but deeper
    Codex workflow infrastructure from `codex-my-workflow` is still absent.
- Impact:
  - The final assessment focuses on advanced gaps such as control-plane files,
    repo-local skills, specialist agent infrastructure, layered guidance,
    reusable templates, and stronger review governance.

### 16:00 — Verification
- Command or method:
  - Compared root guidance, workflow-memory files, directory structure, and
    workflow-specific paths across both repos using direct file inspection.
- Result:
  - Verified that `referenda` has `AGENTS.md`, `KNOWLEDGE_BASE.md`,
    `MEMORY.md`, `.agent/PLANS.md`, `memos/`, `memos/session_logs/`, and
    `CODEX_START.md`, but lacks `.codex/`, `.agents/skills/`,
    `.codex/agents/`, nested `AGENTS.md`, workflow templates, and broader
    workflow-guide/report infrastructure.
- Notes:
  - `README.md` in `referenda` still shows an expected `.agents/skills/`
    layout even though that directory is not on disk, which is a concrete sign
    of incomplete integration.

## End-of-session summary

- What changed:
  - Wrote a durable plan and session log for the gap evaluation.
- What was verified:
  - Confirmed the presence or absence of the key workflow surfaces in both
    repos and checked for equivalent structures before calling them gaps.
- Remaining work:
  - None in this repo. The next step would be to choose which missing workflow
    features are worth porting into `referenda` first.
