# Knowledge Base

This file is the durable, versioned knowledge base for the Codex port.

Use it for conventions that should persist across sessions and across agents.
For this repository, that means the stable operating rules of the Codex-first
workflow, the canonical artifact locations, and the pitfalls that repeatedly
cause drift.

Keep entries short, canonical, and easy to update.

## Notation Registry

| Rule | Convention | Example | Anti-Pattern |
|------|------------|---------|--------------|
| Beamer authority | When Beamer and Quarto differ, `Slides/*.tex` is authoritative for user-facing content | Mirror a frame-content fix from Beamer into the matching Quarto deck in the same task | Treating `Quarto/*.qmd` as a creative rewrite of the lecture |
| Durable state | Plans, session logs, and quality reports live on disk under `quality_reports/` | Refresh `quality_reports/plans/YYYY-MM-DD_task.md` before a non-trivial implementation pass | Leaving key decisions only in chat |
| Quality score semantics | `60` exploration, `80` production baseline, `90` PR-ready, `95` excellence | Use `90` for infrastructure docs intended to guide future sessions | Treating any passing edit as implicitly PR-ready |
| Specialist-first review | Specialist review is the default review mode when a task maps cleanly onto the reviewer set | Use the slide reviewers for serious slide work and `r-reviewer` for meaningful R work | Falling back to a single generalist review when a specialist workflow clearly fits |
| Explicit subagents | Codex parallelism must be requested explicitly; it is never automatic | Ask for `slide-auditor`, `pedagogy-reviewer`, and `proofreader` when doing a serious deck review | Assuming specialist review happens because a skill name was mentioned casually |
| Directory-local guidance | Path behavior is encoded through layered `AGENTS.md` files instead of Claude `paths:` rules | Read `Slides/AGENTS.md` and `Quarto/AGENTS.md` before paired slide work | Expecting one root rule file to fully replace folder-local guidance |
| Conservative infrastructure edits | `.codex/`, `.agents/`, `AGENTS.md`, `KNOWLEDGE_BASE.md`, and `MEMORY.md` are workflow infrastructure and should change deliberately | Explain why a hook or skill change is needed and record it in a report or session log | Casual workflow edits with no rationale or follow-up verification |

## Workflow Symbols And Artifacts

| Symbol / Artifact | Meaning | Introduced | Notes |
|-------------------|---------|------------|-------|
| `quality_reports/plans/` | Durable task plans for non-trivial work | Codex port starter pack | Naming convention is `YYYY-MM-DD_short-task.md` |
| `quality_reports/session_logs/` | Durable state checkpoints during active work | Codex port starter pack | Update after plan approval, major decisions, and wrap-up |
| `quality_reports/` | Home for reports, QA writeups, and review artifacts | Codex port starter pack | Critical reasoning should not live only in the live thread |
| `KNOWLEDGE_BASE.md` | Stable conventions and canonical repo truth | Codex port starter pack | Use for durable operational or domain truth |
| `MEMORY.md` | Durable workflow lessons learned from experience | Codex port starter pack | Use for tactical lessons and recovery hints |
| `implement -> verify -> review -> fix -> re-verify -> score -> summarize` | Default contractor loop for non-trivial work | `AGENTS.md` and `docs/CODEX_WORKFLOW.md` | Applies to infrastructure work as well as content work |
| specialist-first review | Default expectation that review uses the relevant specialists instead of a single generalist pass | `AGENTS.md` and `docs/CODEX_WORKFLOW.md` | Requires explicit runtime delegation in Codex when the full workflow is requested |
| `qa-quarto` hard gates | No overflow, no parity loss, no notation drift, no visual regression, no centering regressions | `Quarto/AGENTS.md` and skill docs | Beamer remains the benchmark |

## Port Progression

| # | Phase | Core Question | Key Artifacts | Exit Condition |
|---|-------|---------------|---------------|----------------|
| 1 | Starter pack scaffolding | Does the repo contain the core Codex-native control plane? | `AGENTS.md`, `.codex/`, `.agents/skills/`, templates, `quality_reports/` | Core workflow artifacts exist on disk |
| 2 | Documentation alignment | Do the docs accurately describe the repo's actual current state? | `docs/PORTING_MAP.md`, `docs/CODEX_WORKFLOW.md`, plan/log artifacts | No obvious docs-vs-repo mismatches remain |
| 3 | Knowledge capture | Are durable conventions and repeated pitfalls written down for future sessions? | `KNOWLEDGE_BASE.md`, `MEMORY.md` | A new session can recover the workflow without re-discovery |
| 4 | Verification hardening | Is there a repeatable way to verify infrastructure changes, not just content changes? | workflow guide, scripts, reports | Infra edits have explicit verification expectations |
| 5 | In-practice validation | Has the workflow been exercised on real tasks end to end? | quality reports, pilot task outputs | Skills and docs are validated by actual use, not just presence on disk |

## Empirical Applications

| Application | Source Of Truth | Where Used | Purpose |
|------------|-----------------|------------|---------|
| Slide-to-Quarto parity | `Slides/AGENTS.md` plus `Quarto/AGENTS.md` | paired lecture maintenance | Preserve user-facing parity when lectures exist in both formats |
| R script production workflow | `scripts/AGENTS.md` | `scripts/` and workflow reviews | Keep reproducible analysis code separate from exploratory work |
| On-resume context recovery | `.codex/hooks/session_start.py` | resumed sessions | Recover state from plans, session logs, and memory without relying on chat history alone |
| End-of-turn checkpointing | `.codex/hooks/stop_require_checkpoint.py` | dirty worktrees and long tasks | Prevent sessions from ending without durable state updates |
| Command safety policy | `.codex/rules/default.rules` plus `.codex/hooks/pre_tool_use_policy.py` | shell usage in repo work | Keep destructive commands and high-risk infra changes deliberate |

## Design Principles

| Principle | Evidence | Where Applied |
|-----------|----------|---------------|
| Preserve workflow outcomes, not literal Claude mechanics | `docs/PORTING_MAP.md` explicitly prefers outcome-faithful Codex-native artifacts | Porting strategy, hooks, skills, layered guidance |
| Keep durable state on disk | Root `AGENTS.md`, `MEMORY.md`, and hooks all reinforce plans and session logs | Non-trivial tasks, resume flow, stop checks |
| Prefer layered guidance over global magic | Nested `AGENTS.md` files replace Claude `paths:` rules | `Slides/`, `Quarto/`, `scripts/`, `explorations/`, `master_supporting_docs/` |
| Keep permissions conservative by default | `.codex/config.toml` uses `approval_policy = "on-request"` and `sandbox_mode = "workspace-write"` | Repo-wide execution policy |
| Use explicit review loops for high-stakes work | `slide-excellence` and `qa-quarto` encode specialist and adversarial QA patterns | Slide reviews, Quarto fidelity work |
| Make review defaults strong even when automation is weaker | Codex cannot auto-spawn specialists the way Claude-style users might expect, so the repo compensates with stronger default guidance and skill entry points | Root guidance, workflow docs, startup reminders |
| Separate exploration from production | Root guidance and `scripts/AGENTS.md` push uncertain work into `explorations/` first | Analysis code, prototype ideas, infra experiments |

## Anti-Patterns

| Anti-Pattern | What Happened | Correction |
|-------------|---------------|-----------|
| Stale port map | `docs/PORTING_MAP.md` said most skills were only planned even though many existed in `.agents/skills/` | Reconcile docs against the filesystem and distinguish "present in repo" from "validated in practice" |
| Chat-only reasoning | Decisions and verification can disappear across turns if not written down | Write or refresh plans, session logs, and reports during the task |
| Implicit delegation assumption | Claude-era habits assume specialists will appear automatically | Name the subagents explicitly in the prompt, skill, or plan |
| Specialist review treated as optional polish | Users may stop after implementation and verification without the stronger specialist pass | Treat specialist review as the normal default for serious work and explain explicitly when it was skipped |
| Over-broad infrastructure edits | Hook, rule, or memory changes can quietly alter the whole workflow | Keep infra edits minimal, explain the rationale, and verify the affected path |
| Production edits without paired verification | It is easy to update docs or content without checking the corresponding runtime or mirror | Match each edit class with a specific verification step and record the result |
| Quarto drift from Beamer | Web slides can accumulate simplifications or layout-driven content loss | Treat Beamer as the benchmark and use hard-gate QA for substantial Quarto work |

## Infrastructure Pitfalls

| Bug / Pitfall | Impact | Fix |
|---------------|--------|-----|
| Assuming a Claude `PreCompact` equivalent exists | Sessions may lose state if plans and logs are not maintained manually | Use `quality_reports/plans/` and `quality_reports/session_logs/` as the primary state surface |
| Assuming "default" means platform-native automation | Guidance can become misleading if it promises automatic delegation or context capture that Codex does not expose | Phrase defaults as expected workflow behavior, then use plans, skills, hooks, and explicit prompts to realize them |
| Assuming hook coverage is universal | Codex hooks in this repo are strongest around shell usage, not every edit path | Backstop workflow discipline with docs, templates, and session habits |
| Confusing `KNOWLEDGE_BASE.md` and `MEMORY.md` | Stable conventions and tactical lessons get mixed together and become harder to maintain | Put canonical truth here and keep experience-based lessons in `MEMORY.md` |
| Treating skill presence as proof of maturity | A skill may exist on disk without having been exercised thoroughly on real tasks | Track "implemented in repo" separately from "validated in practice" |
| Editing workflow infrastructure without a report trail | Future sessions cannot tell why behavior changed | Record infra changes in plans, session logs, or quality reports the same day |
| Skipping explicit verification for non-content files | Docs, hooks, and config can silently drift from the repo's real behavior | Re-read changed docs, inspect referenced files on disk, and run any targeted checks relevant to the infrastructure path |
