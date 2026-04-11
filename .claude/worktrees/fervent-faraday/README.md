# Codex Workflow Starter Pack

This repository is a Codex-focused port of the original
[`claude-code-my-workflow`](https://github.com/pedrohcgs/claude-code-my-workflow)
project by Pedro Sant'Anna.

It keeps the core idea of the original repo: treat an AI coding assistant less
like a chat partner and more like a disciplined contractor for academic and
research work. The assistant should plan before non-trivial work, preserve
state on disk, default to specialist review when it fits, use adversarial QA
for substantial Beamer/Quarto parity work, verify outputs, and summarize what
actually happened.

What changed here is the execution surface. The original repo was built around
Claude Code. This version adapts that workflow to Codex by replacing
Claude-specific mechanisms with Codex-native guidance, skills, agents, hooks,
and durable artifacts.

## Credit And Provenance

The upstream source for this repo is Pedro Sant'Anna's
[`claude-code-my-workflow`](https://github.com/pedrohcgs/claude-code-my-workflow).
This repository is a cloned and adapted Codex-first port, not a claim of
authorship over the original workflow design.

The original project contributed the key workflow ideas:

- plan-first execution for non-trivial work
- specialized reviewers instead of one general reviewer
- adversarial critic/fixer loops for Quarto-vs-Beamer QA
- quality thresholds for deciding when work is ready
- durable workflow memory through plans, logs, and reusable guidance

This port keeps those ideas while translating them into the primitives Codex
actually exposes.

## What This Repo Is

This repo is a starter pack for running a disciplined Codex workflow on
academic, research, and documentation tasks. It is especially oriented around:

- slide decks in Beamer and Quarto
- reproducible R analysis
- literature and manuscript workflows
- infrastructure for persistent AI-assisted project work

The repo is both:

- a working Codex workflow environment
- a reference implementation for how to port a Claude-oriented repository to
  Codex without losing the important workflow behaviors

## How The Codex Port Works

The main conversion idea is simple: preserve workflow outcomes, not literal
tooling details.

In the original Claude workflow, behavior was driven by Claude-specific memory,
rule loading, and hook surfaces. In this Codex version, the same goals are
implemented through:

- root and nested `AGENTS.md` files for layered guidance
- `.codex/config.toml` for project-scoped Codex configuration
- `.codex/hooks.json` and `.codex/hooks/*` for startup, command-policy, review,
  and stop-time reminders
- `.codex/agents/*.toml` for specialist agents
- `.agents/skills/*` for reusable task workflows
- `KNOWLEDGE_BASE.md` and `MEMORY.md` for durable conventions and lessons
- `quality_reports/plans/` and `quality_reports/session_logs/` for on-disk task
  state

The result is a workflow that is intentionally explicit. Codex is expected to
read the repo guidance, create or refresh a plan, do the work, verify it,
review it, score it against the repo thresholds, and write down the outcome.

## What Is Included

The current port includes:

- root workflow guidance in [AGENTS.md](AGENTS.md)
- deeper workflow docs in [docs/CODEX_WORKFLOW.md](docs/CODEX_WORKFLOW.md)
- a detailed Claude-to-Codex mapping in [docs/PORTING_MAP.md](docs/PORTING_MAP.md)
- a populated durable knowledge base in [KNOWLEDGE_BASE.md](KNOWLEDGE_BASE.md)
- workflow memory in [MEMORY.md](MEMORY.md)
- 10 specialist Codex agents in `.codex/agents/`
- a matched skill library in `.agents/skills/`
- templates for plans, logs, and reports in `templates/`
- report scaffolding in `quality_reports/`

At the inventory level, the Codex-side specialist agents and skills currently
match the original Claude-side names one-for-one.

At the workflow level, the repo now defaults toward:

- specialist-first review for serious work
- adversarial critic/fixer QA for substantial Beamer/Quarto parity tasks
- blocking quality thresholds at `80 / 90 / 95`
- durable on-disk context through plans, session logs, `MEMORY.md`, and
  `KNOWLEDGE_BASE.md`

## How To Use It

### 1. Open The Repo In Codex

Use Codex app or Codex CLI as the main execution surface for work in this repo.
The terminal is still useful for shell commands, but the workflow is designed
around Codex reading repo guidance and operating with durable on-disk artifacts.

### 2. Start With The Repo Guidance

For any non-trivial task, tell Codex to read:

- `AGENTS.md`
- `MEMORY.md`
- `KNOWLEDGE_BASE.md`
- `docs/CODEX_WORKFLOW.md`
- the latest plan and session log when relevant

For folder-specific work, also have Codex read the relevant nested `AGENTS.md`
files such as `Slides/AGENTS.md`, `Quarto/AGENTS.md`, or `scripts/AGENTS.md`.

### 3. Let Codex Use The Contractor Loop

The default loop in this repo is:

`implement -> verify -> review -> fix -> re-verify -> score -> summarize`

For non-trivial work, Codex should create or refresh:

- `quality_reports/plans/YYYY-MM-DD_short-task.md`
- `quality_reports/session_logs/YYYY-MM-DD_short-task.md`

This is how the repo preserves state across long sessions and context changes.

### 4. Let Specialist Review Be The Default

In this repo, specialist review is the default expected review mode for serious
work when the task maps cleanly onto the reviewer set.

That means:

- slide or Quarto work should usually use `proofreader`,
  `slide-auditor`, and `pedagogy-reviewer`
- meaningful R work should usually use `r-reviewer`
- field-specific or substantive correctness checks should use
  `domain-reviewer`
- substantial Beamer/Quarto parity work should usually use the
  `quarto-critic` / `quarto-fixer` loop

Codex still does not spawn specialists automatically at the platform level, so
if you want to guarantee the full multi-agent workflow in a given session, say
so explicitly or invoke the relevant repo skill.

Useful entry points:

- `slide-excellence` for parallel slide review
- `qa-quarto` for the adversarial critic/fixer loop
- explicit instructions to spawn named specialists and synthesize their output

### 5. Verify Before Declaring Success

This repo expects verification to match the type of task:

- `Slides/*.tex`: compile or otherwise verify renderability
- `Quarto/*.qmd`: render or check fidelity against Beamer
- `scripts/**/*.R`: run the relevant script entry point and check outputs
- infrastructure/docs work: re-read docs, inspect referenced files, and verify
  that the described behavior matches the repo state

Then score the result against the repo thresholds:

- `80` = production-ready baseline and commit threshold
- `90` = PR-ready
- `95` = excellence target

### Example Starting Prompt

```text
Read AGENTS.md, MEMORY.md, KNOWLEDGE_BASE.md, docs/CODEX_WORKFLOW.md, and the latest plan/session log.

Then carry out this task using the repo's contractor workflow:
- draft or refresh the on-disk plan
- implement the task
- verify it
- use the full repo workflow by default, including specialist review where it
  fits and adversarial QA for substantial Beamer/Quarto parity work
- score the result against the repo thresholds
- update the session log
- summarize what changed, what was verified, and any remaining risks
```

## Where This Port Emulates The Original Claude Workflow Well

This Codex port does a strong job reproducing the important workflow outcomes:

- Plan-first execution:
  non-trivial work is expected to begin with a durable on-disk plan.
- Durable state:
  plans, session logs, quality reports, `KNOWLEDGE_BASE.md`, and `MEMORY.md`
  preserve context across sessions.
- Specialist review:
  the repo includes matched specialist agents and reusable skills, and now
  treats specialist-first review as the default expected mode for serious work.
- Adversarial QA:
  the critic/fixer pattern survives through the `qa-quarto` skill and is now
  documented as the default QA path for substantial paired Beamer/Quarto work.
- Quality gating:
  the same 60/80/90/95 threshold logic remains part of the workflow and is
  framed more explicitly as a blocking decision rule.
- Directory-aware behavior:
  nested `AGENTS.md` files provide local guidance similarly to the original
  Claude repo's path-sensitive rules.

In practice, the port is strongest when the task is explicit, bounded, and
benefits from durable process discipline.

## Where It Differs From Claude

This repo deliberately does not claim perfect feature parity with Claude Code.
Some differences are structural.

### Better Or Clearer In Codex

- The workflow is more explicit on disk.
  Because Codex relies heavily on plans, logs, and markdown docs, the working
  state is often easier to inspect directly from the repository.
- The guidance layers are easier to reason about.
  Root guidance, nested `AGENTS.md`, skills, and docs make the control surface
  visible instead of hiding as much behavior behind a single assistant surface.
- The port encourages deliberate orchestration.
  Parallel specialists and adversarial loops are invoked intentionally instead
  of being assumed.
- The default guidance is now stronger.
  The repo pushes harder toward specialist review, adversarial QA, scoring, and
  durable state even when the platform cannot enforce every step automatically.

### Weaker Or Less Native Than Claude

- No direct `PreCompact` equivalent.
  Claude's context-compression workflow is not reproduced exactly, so this port
  leans more heavily on plans and logs.
- Smaller hook surface.
  Codex hooks in this repo help with startup, shell policy, reminders, and stop
  checkpoints, but they do not mirror Claude's broader event model one-for-one.
- No automatic specialist spawning.
  In Codex, multi-agent behavior must be explicitly requested.
- No perfect automatic defaulting.
  The repo can make specialist review and adversarial QA the default expected
  workflow, but it still cannot force Codex to launch those subagents unless
  the runtime prompt allows it.
- Path-scoped rules are emulated rather than native.
  Nested `AGENTS.md` files work well, but they are still a different mechanism
  from Claude's original rule-loading model.

### Honest Bottom Line

This repo emulates the original Claude workflow well at the level that matters
most: disciplined execution, durable state, specialist review, adversarial QA,
and verification-centered completion.

It is less faithful at the exact runtime-mechanics level. Some Claude features
have no perfect Codex equivalent, so the port substitutes explicit artifacts and
habits where Claude offered more native automation. In other words: the repo
can make the Claude workflow the default expectation, but not every part of that
default can be platform-native or fully automatic.

## Who This Repo Is For

This repo is useful if you want:

- a serious Codex workflow for research or academic work
- a reusable starter pack for multi-step AI-assisted project execution
- a concrete example of how to port a Claude-first workflow to Codex
- a system that favors explicit planning, verification, and durable artifacts

It is less useful if you want:

- a minimal one-file setup
- a no-process chat experience
- a perfect drop-in replacement for every Claude Code runtime feature

## Suggested Reading Order

If you are new to the repo, read in this order:

1. [AGENTS.md](AGENTS.md)
2. [docs/CODEX_WORKFLOW.md](docs/CODEX_WORKFLOW.md)
3. [docs/PORTING_MAP.md](docs/PORTING_MAP.md)
4. [KNOWLEDGE_BASE.md](KNOWLEDGE_BASE.md)
5. [MEMORY.md](MEMORY.md)

Then open Codex in the repo and give it a bounded real task.

## Current Status

This repository is a working Codex-first port with matched skill and specialist
inventories and a documented workflow surface. The main remaining gap is not
missing scaffolding; it is behavioral hardening through more real end-to-end
pilot tasks.
