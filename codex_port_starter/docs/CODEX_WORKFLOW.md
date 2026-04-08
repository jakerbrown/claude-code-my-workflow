# Codex Workflow Guide

This guide explains how to use the Codex starter pack as the working surface for
a Codex-first mirror of the original Claude academic workflow.

## 1. What this port is trying to preserve

The original workflow is valuable because it gives the model a disciplined
operating pattern:

- plan before significant work
- preserve context on disk
- use specialists instead of one general reviewer
- compare Quarto against Beamer with an adversarial critic/fixer cycle
- gate completion on verification and quality thresholds

This port keeps those outcomes, but uses Codex primitives:

- layered `AGENTS.md`
- `.codex/config.toml`
- `.codex/hooks.json`
- `.codex/agents/*.toml`
- `.agents/skills/*`
- on-disk plans, logs, reports, knowledge base, and memory

## 2. Recommended runtime

Use **Codex app** or **Codex CLI** as the main execution surface for repo work.

Use regular chat for:
- planning the next porting step
- reviewing the structure
- rewriting instructions
- discussing tradeoffs

Use Codex app / CLI for:
- reading the repo
- editing files
- running verification commands
- spawning parallel subagents
- working in worktrees

## 3. Start-of-task checklist

For any non-trivial task, Codex should:

1. read the relevant `AGENTS.md` layers
2. read `MEMORY.md`
3. read the relevant parts of `KNOWLEDGE_BASE.md`
4. draft or refresh a plan under `quality_reports/plans/`
5. wait for approval unless the user clearly wants execution to continue

A good first prompt is:

> Read the active `AGENTS.md` guidance, `MEMORY.md`, `KNOWLEDGE_BASE.md`, and
> the latest plan. Then summarize the task, the likely files to change, the
> verification steps, and the review strategy.

## 4. The contractor loop

After the plan is approved, the default loop is:

1. **Implement**
2. **Verify**
3. **Review**
4. **Fix**
5. **Re-verify**
6. **Score / summarize**

For exploratory work under `explorations/`, the loop is simpler and the quality
threshold is lower.

## 5. Parallel specialist review

Codex only spawns subagents when explicitly asked.

That means the parent agent should say things like:

> Spawn `slide-auditor`, `pedagogy-reviewer`, and `proofreader` in parallel on
> `Quarto/Lecture3.qmd`. Keep them read-only. When all three return, write their
> reports to `quality_reports/` and synthesize one combined summary.

Use this pattern whenever the work is naturally separable and the added token
cost is justified.

## 6. Adversarial QA pattern

The original repo's most distinctive pattern is the critic/fixer loop.

In Codex, the workflow is:

1. parent resolves the Beamer/Quarto pair
2. parent explicitly spawns `quarto-critic`
3. if critic rejects, parent explicitly spawns `quarto-fixer`
4. parent re-runs the critic
5. loop until `APPROVED` or the round limit is reached

That pattern is encoded in the `qa-quarto` skill.

## 7. Knowledge base maintenance

Use `KNOWLEDGE_BASE.md` for things that should remain true across sessions:

- notation
- recurring examples
- design principles
- lecture ordering
- empirical mapping
- known pitfalls

Use `MEMORY.md` for workflow lessons such as:

- where Codex tends to stumble
- which prompts or skills work reliably
- repo-specific conventions that were learned the hard way

A useful rule of thumb:

- **domain truth** goes into `KNOWLEDGE_BASE.md`
- **workflow truth** goes into `MEMORY.md`

## 8. Directory-specific behavior

The port uses nested `AGENTS.md` files instead of Claude `paths:` rule files.

### `Slides/`
Beamer is authoritative. User-facing content edits should usually be mirrored to
Quarto in the same task.

### `Quarto/`
Quarto is judged against Beamer. Fidelity matters more than improvisation.

### `scripts/`
Use production-quality reproducible code. If uncertain, prototype in
`explorations/` first.

### `explorations/`
Fast, lower-threshold sandbox. Document the result and then either graduate or
archive it.

### `master_supporting_docs/`
Read large PDFs selectively and keep evidence tracking explicit.

## 9. Quality thresholds

Recommended defaults:

- 60 = exploration
- 80 = production baseline / commit threshold
- 90 = PR-ready
- 95 = excellence

These are not laws of nature, but they should be used consistently unless a task
has a good reason to deviate.

## 10. What differs from Claude

Three differences matter operationally:

### A. No direct `PreCompact` port
The workflow depends more on on-disk plans and logs than on hook-time context
capture.

### B. Hook surface is smaller
The starter pack uses `SessionStart`, `PreToolUse`, `PostToolUse`, and `Stop`.
That is useful, but it is not the same as Claude's broader hook/event surface.

### C. Path-scoped rules become layered guidance
Folder-local `AGENTS.md` files do most of the work that Claude `paths:` rules
used to do.

## 11. Suggested prompts

### General repo initialization
> Read `AGENTS.md`, `docs/PORTING_MAP.md`, and the existing `.claude/` folder.
> Propose the next smallest faithful Codex porting step.

### Full slide review
> Use the `slide-excellence` skill on `Quarto/Lecture1_Topic.qmd`. Spawn the
> specialist reviewers explicitly, save all reports under `quality_reports/`,
> then give me one combined summary.

### Adversarial Quarto QA
> Use the `qa-quarto` skill for `Lecture2_Topic`. Treat Beamer as the benchmark,
> loop until APPROVED or the round limit is reached, and write all round reports.

### Next-wave skill porting
> Compare `.claude/skills/proofread` to this Codex starter pack. Draft a Codex
> repo skill that matches the original intent but uses Codex-native conventions.

## 12. When to consider an external orchestrator

Most of the value can be captured with native Codex guidance + skills.

Consider adding an external orchestrator only if you need:

- deterministic multi-round routing logic
- stronger artifact bookkeeping
- richer cross-agent trace capture
- a reusable packaged workflow outside this single repository

At that point, the likely next step is an Agents SDK layer that talks to Codex
through `codex mcp-server`.
