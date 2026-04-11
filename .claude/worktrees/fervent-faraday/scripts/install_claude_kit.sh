#!/bin/bash
# install_claude_kit.sh — Install portable Claude Code workflow kit into a target repo
#
# Usage: ./scripts/install_claude_kit.sh /path/to/target/repo
#
# What it does:
#   1. Copies .claude/ infrastructure (agents, rules, hooks, skills, settings.json)
#   2. Creates CLAUDE.md (or CLAUDE.local.md if CLAUDE.md exists from coauthor)
#   3. Creates KNOWLEDGE_BASE.md and MEMORY.md if missing
#   4. Creates quality_reports/ directories if missing
#   5. Does NOT touch existing AGENTS.md, .codex/, or any other repo files
#
# Requires: This script must be run from the codex-my-workflow repo root.

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

KIT_DIR="templates/claude-code-kit"

if [ $# -lt 1 ]; then
    echo -e "${RED}Usage: $0 /path/to/target/repo${NC}"
    exit 1
fi

TARGET="$1"

if [ ! -d "$TARGET/.git" ]; then
    echo -e "${RED}Error: $TARGET is not a git repository${NC}"
    exit 1
fi

REPO_NAME=$(basename "$TARGET")

echo -e "${CYAN}Installing Claude Code kit into: ${GREEN}$REPO_NAME${NC}"
echo ""

# ─────────────────────────────────────────
# Step 1: Copy .claude/ infrastructure
# ─────────────────────────────────────────

echo -e "${YELLOW}[1/5] Copying .claude/ infrastructure...${NC}"

# Create .claude/ directory structure (preserve existing worktrees etc)
mkdir -p "$TARGET/.claude"/{agents,rules,hooks,skills}

# Copy agents
cp -n "$KIT_DIR/.claude/agents/"*.md "$TARGET/.claude/agents/" 2>/dev/null || true
echo "  Agents: $(ls "$TARGET/.claude/agents/"*.md 2>/dev/null | wc -l | tr -d ' ') files"

# Copy rules
cp -n "$KIT_DIR/.claude/rules/"*.md "$TARGET/.claude/rules/" 2>/dev/null || true
echo "  Rules: $(ls "$TARGET/.claude/rules/"*.md 2>/dev/null | wc -l | tr -d ' ') files"

# Copy hooks
cp -n "$KIT_DIR/.claude/hooks/"* "$TARGET/.claude/hooks/" 2>/dev/null || true
chmod +x "$TARGET/.claude/hooks/"*.sh 2>/dev/null || true
echo "  Hooks: $(ls "$TARGET/.claude/hooks/"* 2>/dev/null | wc -l | tr -d ' ') files"

# Copy skills (each in its own directory)
for skill_dir in "$KIT_DIR/.claude/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$TARGET/.claude/skills/$skill_name"
    cp -n "$skill_dir"SKILL.md "$TARGET/.claude/skills/$skill_name/" 2>/dev/null || true
done
echo "  Skills: $(ls -d "$TARGET/.claude/skills/"*/ 2>/dev/null | wc -l | tr -d ' ') directories"

# Copy settings.json (only if none exists)
if [ ! -f "$TARGET/.claude/settings.json" ]; then
    cp "$KIT_DIR/.claude/settings.json" "$TARGET/.claude/settings.json"
    echo "  Settings: created"
else
    echo "  Settings: already exists, skipped"
fi

# ─────────────────────────────────────────
# Step 2: Detect plan/log paths
# ─────────────────────────────────────────

echo -e "${YELLOW}[2/5] Detecting plan/log paths...${NC}"

PLANS_DIR=""
SESSION_LOGS_DIR=""

# Check common plan locations
for candidate in "memos" "plans" "logs/plans" "docs/plans" "quality_reports/plans"; do
    if [ -d "$TARGET/$candidate" ]; then
        PLANS_DIR="$candidate"
        break
    fi
done

# If no plan dir found, create quality_reports/plans/
if [ -z "$PLANS_DIR" ]; then
    PLANS_DIR="quality_reports/plans"
    mkdir -p "$TARGET/$PLANS_DIR"
fi
echo "  Plans: $PLANS_DIR"

# Check common session log locations
for candidate in "memos/session_logs" "plans/session_logs" "logs/session_logs" "quality_reports/session_logs"; do
    if [ -d "$TARGET/$candidate" ]; then
        SESSION_LOGS_DIR="$candidate"
        break
    fi
done

# If no session log dir found, create quality_reports/session_logs/
if [ -z "$SESSION_LOGS_DIR" ]; then
    SESSION_LOGS_DIR="quality_reports/session_logs"
    mkdir -p "$TARGET/$SESSION_LOGS_DIR"
fi
echo "  Session logs: $SESSION_LOGS_DIR"

# Also ensure quality_reports/ base exists
mkdir -p "$TARGET/quality_reports"

# ─────────────────────────────────────────
# Step 3: Create CLAUDE.md (or CLAUDE.local.md)
# ─────────────────────────────────────────

echo -e "${YELLOW}[3/5] Creating CLAUDE.md...${NC}"

# Detect project description from AGENTS.md or README
PROJECT_DESC=""
if [ -f "$TARGET/AGENTS.md" ]; then
    # Get first non-comment, non-empty, non-heading line
    PROJECT_DESC=$(grep -m1 -v '^#\|^$\|^<!--' "$TARGET/AGENTS.md" 2>/dev/null || echo "")
fi

if [ -f "$TARGET/CLAUDE.md" ]; then
    # Coauthor's CLAUDE.md exists — use CLAUDE.local.md
    CLAUDE_FILE="$TARGET/CLAUDE.local.md"
    echo "  Existing CLAUDE.md found — creating CLAUDE.local.md (gitignored)"
else
    CLAUDE_FILE="$TARGET/CLAUDE.md"
    echo "  Creating CLAUDE.md"
fi

if [ ! -f "$CLAUDE_FILE" ]; then
    cat > "$CLAUDE_FILE" << CLAUDEEOF
# CLAUDE.MD -- $REPO_NAME

**Project:** $REPO_NAME
**Branch:** main

---

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save plans to \`$PLANS_DIR\`
- **Verify after** -- run code and confirm output at the end of every task
- **Quality gates** -- nothing ships below 80/100
- **[LEARN] tags** -- when corrected, save \`[LEARN:category] wrong -> right\` to MEMORY.md

---

## Commands

\`\`\`bash
# R scripts
Rscript path/to/script.R

# Python scripts
python3 path/to/script.py

# Git workflow
git status && git diff --stat
\`\`\`

---

## Quality Thresholds

| Score | Gate | Meaning |
|-------|------|---------|
| 80 | Commit | Good enough to save |
| 90 | PR | Ready for review |
| 95 | Excellence | Aspirational |

---

## Skills Quick Reference

| Command | What It Does |
|---------|-------------|
| \`/commit [msg]\` | Stage, commit, PR, merge |
| \`/data-analysis [dataset]\` | End-to-end R analysis |
| \`/review-r [file]\` | R code quality review |
| \`/proofread [file]\` | Grammar/typo/consistency review |
| \`/deep-audit\` | Repository-wide consistency audit |
| \`/lit-review [topic]\` | Literature search + synthesis |
| \`/research-ideation [topic]\` | Research questions + strategies |
| \`/interview-me [topic]\` | Interactive research interview |
| \`/review-paper [file]\` | Manuscript review |
| \`/learn [skill-name]\` | Extract discovery into persistent skill |
| \`/context-status\` | Show session health + context usage |

---

## Specialist Mapping

| Workflow Role | Agent | When to Use |
|--------------|-------|-------------|
| Code reviewer | r-reviewer | R script changes |
| Domain reviewer | domain-reviewer | Substantive correctness |
| Proofreader | proofreader | Writing quality |
| Verifier | verifier | Pre-commit checks |
CLAUDEEOF
fi

# ─────────────────────────────────────────
# Step 4: Create KNOWLEDGE_BASE.md and MEMORY.md if missing
# ─────────────────────────────────────────

echo -e "${YELLOW}[4/5] Creating supporting files...${NC}"

if [ ! -f "$TARGET/KNOWLEDGE_BASE.md" ]; then
    cp "$KIT_DIR/KNOWLEDGE_BASE.md.template" "$TARGET/KNOWLEDGE_BASE.md"
    echo "  KNOWLEDGE_BASE.md: created"
else
    echo "  KNOWLEDGE_BASE.md: already exists, skipped"
fi

if [ ! -f "$TARGET/MEMORY.md" ]; then
    cp "$KIT_DIR/MEMORY.md.template" "$TARGET/MEMORY.md"
    echo "  MEMORY.md: created"
else
    echo "  MEMORY.md: already exists, skipped"
fi

# ─────────────────────────────────────────
# Step 5: Update .gitignore
# ─────────────────────────────────────────

echo -e "${YELLOW}[5/5] Updating .gitignore...${NC}"

GITIGNORE="$TARGET/.gitignore"
ENTRIES_ADDED=0

add_gitignore() {
    local entry="$1"
    if [ -f "$GITIGNORE" ]; then
        if ! grep -qxF "$entry" "$GITIGNORE" 2>/dev/null; then
            echo "$entry" >> "$GITIGNORE"
            ENTRIES_ADDED=$((ENTRIES_ADDED + 1))
        fi
    else
        echo "$entry" > "$GITIGNORE"
        ENTRIES_ADDED=$((ENTRIES_ADDED + 1))
    fi
}

add_gitignore ".claude/settings.local.json"
add_gitignore ".claude/state/"
add_gitignore ".claude/worktrees/"
add_gitignore "CLAUDE.local.md"

echo "  .gitignore: $ENTRIES_ADDED entries added"

# ─────────────────────────────────────────
# Summary
# ─────────────────────────────────────────

echo ""
echo -e "${GREEN}Done! Claude Code kit installed into $REPO_NAME${NC}"
echo ""
echo "Installed:"
echo "  4 agents, $(ls "$TARGET/.claude/rules/"*.md 2>/dev/null | wc -l | tr -d ' ') rules, 7 hooks, $(ls -d "$TARGET/.claude/skills/"*/ 2>/dev/null | wc -l | tr -d ' ') skills"
echo "  Plans dir: $PLANS_DIR"
echo "  Session logs: $SESSION_LOGS_DIR"
echo ""
echo "Next steps:"
echo "  1. Review and customize CLAUDE.md for this project"
echo "  2. Customize .claude/agents/domain-reviewer.md for your domain"
echo "  3. Update .claude/hooks/protect-files.sh with files to protect"
echo "  4. Open Claude Code in $TARGET to verify skills load"
