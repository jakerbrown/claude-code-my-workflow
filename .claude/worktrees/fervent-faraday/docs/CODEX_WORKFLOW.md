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

For existing repos, the preferred integration model is usually:

- preserve the repo's planning and domain-doc authority
- port the operational control plane and reusable workflow machinery
- adapt durable-state locations and review surfaces to the host repo
- skip slide- or lecture-specific features unless the host repo actually needs them

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
> the latest plan. Then summarize the task, the likely files to change, the
> verification steps, and the review strategy.

### Read-only reconnaissance mode

Sometimes the user wants understanding, planning, or gap analysis before any
files change.

In that case, Codex should still:

1. read the relevant guidance layers
2. inspect the repo state directly
3. summarize the current structure, gaps, and likely next actions

But Codex should defer writing the plan or session log until the user asks to
continue into implementation or explicitly authorizes file changes.

Once the task becomes execution-oriented, refresh or create the on-disk plan and
session log before doing substantial edits.

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

Specialist review is the default review mode in this repository whenever a task
maps cleanly onto the existing specialist set.

Codex only spawns subagents when explicitly asked at runtime.

That means the practical default is:

1. treat specialist review as expected, not optional, for serious work
2. use a repo skill that already encodes the specialist workflow when possible
3. otherwise explicitly request the relevant specialist agents in the prompt or
   plan
4. synthesize the outputs into a durable report or session-log entry

The parent agent should say things like:

> Spawn `slide-auditor`, `pedagogy-reviewer`, and `proofreader` in parallel on
> `Quarto/Lecture3.qmd`. Keep them read-only. When all three return, write their
> reports to `quality_reports/` and synthesize one combined summary.

Use this pattern whenever the work is naturally separable and the added token
cost is justified.

### Default specialist mapping

- Slides / Quarto review:
  - `proofreader`
  - `slide-auditor`
  - `pedagogy-reviewer`
- R / analysis code:
  - `r-reviewer`
- Substance / field correctness:
  - `domain-reviewer`
- Paired Beamer / Quarto parity work:
  - `quarto-critic`
  - `quarto-fixer`
- End-to-end verification:
  - `verifier` when the task is important enough to justify a dedicated final
    pass

## 6. Adversarial QA pattern

The original repo's most distinctive pattern is the critic/fixer loop.

In Codex, the workflow is:

1. parent resolves the Beamer/Quarto pair
2. parent explicitly spawns `quarto-critic`
3. if critic rejects, parent explicitly spawns `quarto-fixer`
4. parent re-runs the critic
5. loop until `APPROVED` or the round limit is reached

That pattern is encoded in the `qa-quarto` skill.

For substantial paired Beamer / Quarto work, this adversarial loop should be
treated as the default QA path rather than an exceptional extra step.

If the task is too small for a full loop, say so explicitly in the summary and
explain what lighter verification replaced it.

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

In this repo they function as default decision thresholds:

- below `80`: not ready for normal completion or commit
- below `90`: not PR-ready
- `95`: excellence target, not a universal requirement

If a task stops below the relevant threshold, the summary should explain why and
what remains.

## 10. Infrastructure verification

Verification should match the kind of change that was made.

For workflow infrastructure, use targeted checks such as:

- re-read changed guidance docs for internal consistency
- confirm referenced files, skills, agents, hooks, and directories exist
- inspect hook and rule files when docs describe their behavior
- run the narrowest relevant command if a script or wrapper changed
- record what was verified and what was not in the session log or report

Examples:

- `AGENTS.md`, `KNOWLEDGE_BASE.md`, `MEMORY.md`, `docs/*.md`
  - Re-read the edited docs and verify path references against the filesystem.
- `.codex/hooks/*`, `.codex/rules/*`, `.codex/config.toml`
  - Inspect the affected files directly and verify that the documented behavior
    matches the actual implementation and policy.
- `.agents/skills/*`
  - Read the skill body, verify any referenced support files exist, and if the
    task is high stakes, run one bounded pilot invocation or a dry-run style
    inspection.

The key rule is that infrastructure changes should not be declared done just
because they are syntactically valid; they should be checked against the repo's
actual operating behavior.

## 11. Context persistence by default

The original Claude workflow relied on a `PreCompact`-style context-preservation
mechanism. Codex does not expose a true equivalent, so this port makes durable
on-disk state the default survival mechanism.

Default expectations:

- non-trivial work gets an on-disk plan
- long or meaningful tasks get a session log
- important decisions and verification results are written to disk
- workflow lessons accumulate in `MEMORY.md`
- stable operating conventions accumulate in `KNOWLEDGE_BASE.md`

This is not a perfect runtime equivalent to Claude's compression lifecycle, but
it is the default persistence model for this repo and should be treated as part
of the workflow, not optional documentation.

## 12. Direct port vs adapt vs skip

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

The starter pack should be understood as an overlay kit for high-integration
adoption, not only as a standalone repo skeleton.

## 12. What differs from Claude

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

## 13. Suggested prompts

### General repo initialization
> Read `AGENTS.md`, `docs/PORTING_MAP.md`, and the existing `.claude/` folder.
> Propose the next smallest faithful Codex porting step.

### Full default workflow
> Read `AGENTS.md`, `MEMORY.md`, `KNOWLEDGE_BASE.md`, and the latest plan. Use
> the full repo workflow by default: durable plan, specialist review where it
> fits, adversarial QA for substantial Beamer/Quarto parity work, scoring
> against the repo thresholds, and a durable session-log update.

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

## 14. When to consider an external orchestrator

Most of the value can be captured with native Codex guidance + skills.

Consider adding an external orchestrator only if you need:

- deterministic multi-round routing logic
- stronger artifact bookkeeping
- richer cross-agent trace capture
- a reusable packaged workflow outside this single repository

At that point, the likely next step is an Agents SDK layer that talks to Codex
through `codex mcp-server`.
