# Plan: Port Claude Code Workflow to 13 Research Repos

**Status:** DRAFT
**Date:** 2026-04-10

## Context

The user has a rich Claude Code workflow infrastructure in `codex-my-workflow` (10 agents, 22 skills, 18 rules, 7 hooks) built for academic slide development. They want to port the **generic, research-applicable** subset to 13 other GitHub repos that currently use Codex (AGENTS.md + .codex/). Claude Code configs (.claude/ + CLAUDE.md) will coexist alongside existing Codex configs.

## Approach: Portable Kit + Per-Repo Script

### Step 1: Create a portable Claude Code kit

Create `templates/claude-code-kit/` in this repo containing only the research-portable files:

**Agents (4):**
- `proofreader.md` — as-is
- `r-reviewer.md` — as-is
- `domain-reviewer.md` — generalized (remove slide-specific lenses)
- `verifier.md` — generalized (remove Beamer/Quarto checks, keep R/scripts/docs)

**Rules (10):**
- `plan-first-workflow.md` — as-is
- `orchestrator-protocol.md` — as-is
- `orchestrator-research.md` — as-is
- `quality-gates.md` — generalized (remove slide rubrics, keep R + docs)
- `session-logging.md` — as-is
- `r-code-conventions.md` — as-is
- `replication-protocol.md` — as-is
- `exploration-fast-track.md` — as-is
- `exploration-folder-protocol.md` — as-is
- `proofreading-protocol.md` — as-is

**Hooks (7):** All as-is (protect-files.sh with generic defaults)

**Skills (11):**
- `commit` — as-is
- `context-status` — as-is
- `data-analysis` — as-is
- `deep-audit` — generalized (remove slide-specific agent roles)
- `interview-me` — as-is
- `learn` — as-is
- `lit-review` — as-is
- `proofread` — as-is (generalized for any academic writing)
- `research-ideation` — as-is
- `review-paper` — as-is
- `review-r` — as-is

**Settings template:** `settings.json` with generic permissions (git, gh, R, python, ls, mkdir, etc. — no LaTeX/Quarto commands)

**CLAUDE.md template:** Research-focused version with placeholders for project name, plan path, verification commands, specialist mapping

### Step 2: Create installation script

`scripts/install_claude_kit.sh` that:
1. Takes a target repo path as argument
2. Copies `.claude/{agents,rules,hooks,skills}` from the kit
3. Copies `settings.json` with repo-appropriate permissions
4. Generates `CLAUDE.md` from template if one doesn't already exist
5. Creates `KNOWLEDGE_BASE.md` and `MEMORY.md` starters if missing
6. Sets `plansDirectory` in settings.json based on detected plan path
7. Does NOT touch existing AGENTS.md, .codex/, or any repo files

### Step 3: Run for all 13 repos

Execute the script for each repo, then do per-repo customization:

| Repo | Plan Path | Has CLAUDE.md | Has KB/MEM | Notes |
|------|-----------|---------------|------------|-------|
| aggregate_causal | logs/plans/ | NO | NO | Theory + simulation |
| ca_homeless | logs/ or memos/ | YES (keep) | NO | DiD + event studies |
| decomp_seg | logs/ | NO | YES | Has .claude/ worktrees only |
| multiple_comparisons | logs/ or docs/ | NO | YES | Has .codex/ |
| process_l2_snapshots | memos/ | NO | YES (has KB+MEM) | SCC safety rules |
| referenda | memos/ | NO | YES (has KB+MEM) | Data acquisition |
| twitter | plans/ or logs/ | NO | YES (has KB+MEM) | Social media data |
| ward_sim | plans/ | NO | YES (has KB+MEM) | R simulation |
| jakerbrown.github.io | logs/ | NO | NO | Personal site |
| maup_fix | logs/ | NO | NO | R package fix |
| referenda_list | logs/ | NO | NO | Data enrichment |
| source_seg_l2_2014_2025 | logs/ | NO | YES (has KB+MEM) | L2 voter data |
| usps_link | logs/ | NO | NO | Probabilistic linkage |

### Step 4: Per-repo CLAUDE.md customization

For each repo, CLAUDE.md will incorporate:
- Project description (from existing AGENTS.md or README.md)
- Correct plan/log paths
- Verification commands specific to the repo
- Specialist mapping relevant to the repo's domain
- Any critical domain rules from existing AGENTS.md

For `ca_homeless` (already has coauthor's CLAUDE.md): create `CLAUDE.local.md` instead. This file is automatically loaded by Claude Code alongside CLAUDE.md but is gitignored, so the coauthor's file stays untouched. The install script will detect existing CLAUDE.md and use CLAUDE.local.md in that case.

## Files to create/modify

All in this repo (`codex-my-workflow`):

```
templates/claude-code-kit/
  .claude/
    settings.json
    agents/
      proofreader.md
      r-reviewer.md
      domain-reviewer.md
      verifier.md
    rules/
      plan-first-workflow.md
      orchestrator-protocol.md
      orchestrator-research.md
      quality-gates.md
      session-logging.md
      r-code-conventions.md
      replication-protocol.md
      exploration-fast-track.md
      exploration-folder-protocol.md
      proofreading-protocol.md
    hooks/
      context-monitor.py
      log-reminder.py
      notify.sh
      post-compact-restore.py
      pre-compact.py
      protect-files.sh
      verify-reminder.py
    skills/
      commit/SKILL.md
      context-status/SKILL.md
      data-analysis/SKILL.md
      deep-audit/SKILL.md
      interview-me/SKILL.md
      learn/SKILL.md
      lit-review/SKILL.md
      proofread/SKILL.md
      research-ideation/SKILL.md
      review-paper/SKILL.md
      review-r/SKILL.md
  CLAUDE.md.template
  KNOWLEDGE_BASE.md.template
  MEMORY.md.template
scripts/install_claude_kit.sh
```

Then for each of the 13 target repos:
```
<repo>/
  .claude/          (new — full kit)
  CLAUDE.md         (new or updated — per-repo)
  KNOWLEDGE_BASE.md (new if missing)
  MEMORY.md         (new if missing)
```

## Skipped (slide/lecture-specific)

**Agents:** beamer-translator, quarto-critic, quarto-fixer, slide-auditor, tikz-reviewer, pedagogy-reviewer
**Rules:** beamer-quarto-sync, no-pause-beamer, single-source-of-truth, tikz-visual-quality, meta-governance, knowledge-base-template, pdf-processing, verification-protocol
**Skills:** compile-latex, create-lecture, deploy, devils-advocate, extract-tikz, pedagogy-review, qa-quarto, slide-excellence, translate-to-quarto, validate-bib, visual-audit

## Verification

1. After installation, run `ls -R .claude/` in a target repo to confirm file structure
2. Open Claude Code in a target repo and verify skills appear in `/help`
3. Test that hooks fire (edit a file, check for verify-reminder)
4. Test that CLAUDE.md loads (check Claude's system prompt references it)
5. Confirm existing AGENTS.md and .codex/ are untouched

## Execution order

1. Create portable kit (generalize files, build templates)
2. Create install script
3. Test on one repo (referenda — richest existing config)
4. Roll out to remaining 12 repos
5. Per-repo CLAUDE.md customization pass (can be incremental)
