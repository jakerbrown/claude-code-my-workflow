# Porting Map

This document is optional background for teams migrating from a Claude-style
workflow. If your target repo is not coming from Claude, you can skip this file.

## Status legend

- **Direct**: close conceptual and file-level equivalent exists
- **Emulated**: behavior is recreated with different Codex primitives
- **No direct equivalent**: the starter pack approximates the behavior but cannot
  recreate it exactly with currently documented Codex features

## Core mapping

| Claude source | Codex destination | Status | Notes |
|---|---|---|---|
| `CLAUDE.md` | `AGENTS.md` + nested `AGENTS.md` + `docs/CODEX_WORKFLOW.md` | Emulated | Codex uses layered `AGENTS.md` rather than Claude's project memory surface |
| `.claude/settings.json` | `.codex/config.toml` + `.codex/hooks.json` + `.codex/rules/default.rules` | Emulated | Same control plane split across config, hooks, and rules |
| `.claude/agents/*.md` | `.codex/agents/*.toml` | Direct | Custom Codex agents map cleanly to the specialist-agent concept |
| `.claude/skills/*` | `.agents/skills/*` | Direct | Codex skills are repo-native and share a similar folder model |
| `.claude/rules/plan-first-workflow.md` | `AGENTS.md` + `templates/plan.md` + hook reminders | Emulated | Planning is encoded in guidance and disk artifacts |
| `.claude/rules/orchestrator-protocol.md` | `AGENTS.md` + `docs/CODEX_WORKFLOW.md` + skills | Emulated | Same loop, but not a native built-in Codex protocol |
| `.claude/rules/session-logging.md` | `quality_reports/session_logs/` + templates + hooks | Direct | Same on-disk pattern |
| `.claude/rules/knowledge-base-template.md` | `KNOWLEDGE_BASE.md` | Direct | Promoted to a first-class root artifact |
| `.claude/rules/beamer-quarto-sync.md` | `Slides/AGENTS.md` + `Quarto/AGENTS.md` | Emulated | Directory guidance replaces path-scoped rule loading |
| `.claude/rules/r-code-conventions.md` | `scripts/AGENTS.md` + `KNOWLEDGE_BASE.md` | Emulated | File-based guidance, not standalone path rules |
| `.claude/rules/exploration-*` | `explorations/AGENTS.md` | Emulated | Same behavior through nested guidance |
| `.claude/rules/pdf-processing.md` | `master_supporting_docs/AGENTS.md` | Emulated | Same idea through directory-local guidance |
| `.claude/hooks/PreCompact` flow | on-disk plans/logs + `SessionStart` + `Stop` hooks | No direct equivalent | Current Codex docs do not expose a `PreCompact` hook |
| Claude `PreToolUse` for `Edit|Write` | Codex `PreToolUse` on `Bash` + repo rules | No direct equivalent | Current Codex hook interception is Bash-oriented |
| Claude notification hook | omitted in starter pack | No direct equivalent | Can be added later if a suitable app / local integration is desired |

## Specialist agent mapping

| Claude agent | Codex agent file |
|---|---|
| `proofreader` | `.codex/agents/proofreader.toml` |
| `slide-auditor` | `.codex/agents/slide-auditor.toml` |
| `pedagogy-reviewer` | `.codex/agents/pedagogy-reviewer.toml` |
| `r-reviewer` | `.codex/agents/r-reviewer.toml` |
| `tikz-reviewer` | `.codex/agents/tikz-reviewer.toml` |
| `beamer-translator` | `.codex/agents/beamer-translator.toml` |
| `quarto-critic` | `.codex/agents/quarto-critic.toml` |
| `quarto-fixer` | `.codex/agents/quarto-fixer.toml` |
| `verifier` | `.codex/agents/verifier.toml` |
| `domain-reviewer` | `.codex/agents/domain-reviewer.toml` |

## Skill mapping in this starter pack

| Original skill | Codex status | Notes |
|---|---|---|
| `/slide-excellence` | Implemented | Uses explicit parallel subagent spawning |
| `/qa-quarto` | Implemented | Uses explicit critic/fixer loop |
| remaining skills | Planned | Best added after the starter pack is working in practice |

## What the starter pack already includes

- root guidance
- nested directory guidance
- repo config
- repo hooks
- repo rules
- 10 specialist custom agents
- knowledge base and memory scaffolding
- plan / log / quality templates
- quality-report directory scaffolding
- 2 flagship skills

## Next likely porting waves

### Wave 2
- `proofread`
- `visual-audit`
- `pedagogy-review`
- `review-r`
- `translate-to-quarto`
- `context-status`
- `learn`

### Wave 3
- compile / deploy workflow
- research workflow skills
- broader verification wrappers
- merge-quality reporting polish

### Wave 4
- app local-environment setup
- automations
- optional Agents SDK orchestrator
- CI / GitHub Action integration

## Recommended principle

Do not try to force Codex to imitate every Claude mechanism literally.

Prefer:
- a faithful **workflow outcome**
- small, composable Codex-native artifacts
- explicit subagent spawning
- durable files on disk for state

## Integration guidance for existing repos

When porting this starter pack into an existing repo, use this quick matrix:

| Category | Default action | Examples |
|---|---|---|
| Operational control plane | Port directly | `.codex/config.toml`, hooks, rules |
| Reusable workflow machinery | Port directly when relevant | skills, reviewer role files |
| Durable-state locations | Adapt to host repo | `memos/`, `docs/session_logs/`, `docs/audits/` |
| Planning/report templates | Adapt to host repo | plan, session-log, quality-report templates |
| Review governance | Adapt to host repo | specialist mapping, adversarial-review triggers |
| Slide / lecture tooling | Skip unless relevant | Quarto parity, TikZ, LaTeX, slide reviewers |

For most mature repos, the right path is:

1. preserve the host repo's planning and domain-doc authority
2. port Milestone A first
3. add Milestone B once the repo needs more structure
4. add Milestone C only when reviewer roles and audit surfaces prove useful
