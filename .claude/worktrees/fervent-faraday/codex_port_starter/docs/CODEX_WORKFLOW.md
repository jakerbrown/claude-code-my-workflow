# Codex Workflow Guide

This guide explains how to use the starter pack as a reusable Codex workflow
layer inside another repository.

## 1. What this starter is trying to preserve

The workflow is valuable because it gives the model a disciplined operating
pattern:

- plan before significant work
- preserve context on disk
- use specialists instead of one general reviewer
- gate completion on verification and quality thresholds

This starter keeps those outcomes, but uses Codex primitives:

- layered `AGENTS.md`
- `.codex/config.toml`
- `.codex/hooks.json`
- `.codex/agents/*.toml`
- optional `.agents/skills/*`
- on-disk plans, logs, reports, knowledge base, and memory

For existing repos, the preferred integration model is usually:

- preserve the repo's planning and domain-doc authority
- port the operational control plane and reusable workflow machinery
- adapt durable-state locations and review surfaces to the host repo
- skip slide- or lecture-specific features unless the host repo actually needs them

## 2. Recommended runtime

Use **Codex app** or **Codex CLI** as the main execution surface for repo work.

Use regular chat for:
- planning
- reviewing structure
- rewriting instructions
- discussing tradeoffs

Use Codex app / CLI for:
- reading the repo
- editing files
- running verification commands
- spawning parallel subagents
- working in worktrees

## 2.1 Existing-repo adoption model

When integrating this starter pack into an existing serious repo, do not default
to copying every file or directory literally.

Default sequence:

### Milestone A

- repo-local `.codex/` config, hooks, and rules
- repo-local skills for repeated workflows
- explicit review mappings
- scoped adversarial review for high-stakes changes

### Milestone B

- nested `AGENTS.md` files for high-risk paths
- a repo-specific workflow guide
- lightweight templates that support the host repo's existing planning system

### Milestone C

- repo-local reviewer role files under `.codex/agents/`
- a lightweight review or audit surface that fits the host repo
- further automation only where repeated use justifies it

The key idea is that existing repos should usually absorb **most** of the
starter pack, but not by replacing their own good planning, domain-doc, or
durable-state systems.

## 3. Start-of-task checklist

For any non-trivial task, Codex should:

1. read the relevant `AGENTS.md` layers
2. read `MEMORY.md`
3. read the relevant parts of `KNOWLEDGE_BASE.md`
4. draft or refresh a plan under `quality_reports/plans/`
5. wait for approval unless the user clearly wants execution to continue

A good first prompt is:

> Read the active `AGENTS.md` guidance, `MEMORY.md`, `KNOWLEDGE_BASE.md`, and
> the latest plan. Then summarize this repo's workflow setup, the likely files
> to tailor first, the verification steps, and the review strategy.

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

> Spawn the relevant reviewers in parallel on the files touched by this task.
> Keep them read-only. When they return, write their findings to
> `quality_reports/` and synthesize one combined summary.

Use this pattern whenever the work is naturally separable and the added token
cost is justified.

## 6. Optional adversarial QA pattern

Some domains benefit from a critic/fixer loop.

In Codex, the workflow is:

1. parent completes an initial implementation pass
2. parent explicitly spawns a critic
3. if critic rejects, parent explicitly spawns a fixer
4. parent re-runs the critic
5. loop until `APPROVED` or the round limit is reached

Use this pattern for high-stakes parity or quality-sensitive work when a simple
review pass is not enough.

## 7. Knowledge base maintenance

Use `KNOWLEDGE_BASE.md` for things that should remain true across sessions:

- domain definitions
- architecture decisions
- naming conventions
- recurring examples or patterns
- design principles
- known pitfalls

Use `MEMORY.md` for workflow lessons such as:

- where Codex tends to stumble
- which prompts or skills work reliably
- repo-specific conventions that were learned the hard way

A useful rule of thumb:

- **domain truth** goes into `KNOWLEDGE_BASE.md`
- **workflow truth** goes into `MEMORY.md`

## 8. Directory-specific behavior

The starter uses nested `AGENTS.md` files instead of Claude `paths:` rules.

Only keep the nested guidance folders that match the target repo. Common
patterns include:

### `scripts/`
Use production-quality reproducible code. If uncertain, prototype in
`explorations/` first.

### `explorations/`
Fast, lower-threshold sandbox. Document the result and then either graduate or
archive it.

### `master_supporting_docs/`
Read large source documents selectively and keep evidence tracking explicit.

### `Slides/` and `Quarto/`
These are optional examples for slide-heavy repos. Remove them if they do not
match the target project.

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
> Read `AGENTS.md`, `KNOWLEDGE_BASE.md`, and `MEMORY.md`. Propose the next
> smallest step to tailor this workflow to the current repo.

### Implementation pass with durable state
> Refresh the plan and session log for this task, implement the requested
> change, verify it, then summarize what changed and what remains.

### Parallel review
> Spawn the relevant reviewers for the files changed in this task, keep them
> read-only, save the findings under `quality_reports/`, and synthesize one
> combined review summary.

### Repo-local workflow extraction
> Turn this repeated process into a repo-local skill under `.agents/skills/`
> and document when it should be used.

## 12. When to consider an external orchestrator

Most of the value can be captured with native Codex guidance, plans, logs, and
optionally repo-local skills.

Consider adding an external orchestrator only if you need:

- deterministic multi-round routing logic
- stronger artifact bookkeeping
- richer cross-agent trace capture
- a reusable packaged workflow outside this single repository

At that point, the likely next step is an Agents SDK layer that talks to Codex
through `codex mcp-server`.

## 13. Direct port vs adapt vs skip

When applying this starter pack to another repo, use this decision rule:

### Port directly

- `.codex/config.toml`
- `.codex/hooks.json`
- `.codex/hooks/*`
- `.codex/rules/*`
- `.agents/skills/*` when the workflows are relevant
- `.codex/agents/*` when stable repeated reviewer roles exist

### Adapt to the host repo

- plan and session-log locations
- review or audit artifact locations
- templates
- workflow docs
- review mappings
- adversarial-review triggers

### Skip unless relevant

- `Slides/` / `Quarto/` parity machinery
- lecture-authoring skills
- LaTeX / TikZ tooling
- presentation-review workflows
