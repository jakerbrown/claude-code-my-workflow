# Workflow Integration Overlay Template

Use this template when a repository already has its own specialized agents,
planning documents, and domain workflows, but you want to layer this workflow's
methods on top without replacing what already works.

## Integration principle

Treat this workflow as an **overlay**, not a rewrite.

For serious existing projects, this starter pack should usually be integrated in
phases rather than copied wholesale on day one.

Preserve:

- existing specialized agents
- existing plan documents and folders
- existing domain-specific review and verification steps
- existing project structure that already works

Add:

- root orchestration guidance
- durable memory files if missing
- a clearer completion standard
- explicit verification and review expectations
- a default multi-agent review mapping
- a scoped adversarial-review rule for high-stakes work
- a durable session-log habit if the repo lacks one

## Minimal files to add

If missing, add only these first:

- `AGENTS.md`
- `KNOWLEDGE_BASE.md`
- `MEMORY.md`
- one durable place for plans
- one durable place for session logs or equivalent progress notes

You do not need to force the repo into `quality_reports/` if it already has a
good durable location for plans and logs.

Common good host-native alternatives include:

- `memos/`
- `memos/session_logs/`
- `memos/reviews/`
- `docs/plans/`
- `docs/session_logs/`
- `docs/audits/`

## Default adoption model

For an existing repo, prefer this phased integration sequence:

### Milestone A: operational foundation

- add repo-local `.codex/` config, hooks, and rules
- add a small repo-local skill library for repeated workflows
- formalize default multi-agent review mappings
- add a scoped adversarial-review rule for high-stakes changes

### Milestone B: structure and consistency

- add nested `AGENTS.md` files for the highest-risk paths
- add a repo-specific workflow guide
- add lightweight templates that support the repo's existing planning system

### Milestone C: deeper specialization

- add repo-local reviewer role files under `.codex/agents/`
- add a lightweight review or audit surface that fits the host repo
- add further automation only where repeated use clearly justifies it

## Direct port vs adapt vs skip

Use this quick decision rule when integrating the starter pack into an existing
repo:

### Port directly

- `.codex/config.toml`
- `.codex/hooks.json`
- `.codex/hooks/*`
- `.codex/rules/*`
- repo-local skills under `.agents/skills/`
- repo-local reviewer role files under `.codex/agents/` when stable roles exist

### Adapt to the host repo

- plan locations
- session-log locations
- review-report or audit locations
- templates
- workflow docs
- review mappings and adversarial-review triggers

### Skip unless the host repo truly needs them

- slide or Quarto parity machinery
- lecture-authoring workflows
- LaTeX / TikZ tooling
- presentation-review workflows

## Root `AGENTS.md` overlay

Copy and adapt:

```md
# Workflow Guidance

This repository uses an overlay workflow layer. Preserve the repo's existing
agents, plans, and domain-specific procedures unless this file explicitly says
otherwise.

## Core operating mode

- For any non-trivial task, start with or refresh a plan in `[EXISTING PLAN PATH]`.
- Before substantial edits, read `KNOWLEDGE_BASE.md`, `MEMORY.md`, and any
  relevant domain guidance already used by this repo.
- After plan approval, use:

  `implement -> verify -> review -> fix -> re-verify -> summarize`

- Save important reasoning to disk rather than leaving it only in chat.
- Update `[EXISTING SESSION LOG PATH OR EQUIVALENT]` after plan approval, major
  decisions, and wrap-up.

## Existing infrastructure is authoritative

- Existing specialized agents remain the default specialists for this repo.
- Existing plan documents remain the default planning surface for this repo.
- Existing verification commands remain the default technical checks for this
  repo unless they are explicitly amended.

## Review expectations

- Use the repo's existing specialists when the task maps cleanly onto them.
- If multiple specialists apply, prefer parallel multi-agent review rather than
  a single generalist pass when the task is large enough to justify it.
- Keep the repo's existing specialists authoritative; map workflow roles onto
  them instead of renaming the repo to fit this workflow.
- Treat the mapping as a workflow default, not an automatic platform feature:
  explicitly request the relevant specialists when you want the full review
  pass.
- If specialist review is skipped, say why in the final summary.

## Verification expectations

- Match verification to the change:
  - code changes: run the narrowest relevant tests, linters, or scripts
  - docs changes: re-read the edited docs and verify referenced paths/commands
  - generated outputs: confirm artifacts exist and are current
- Record what was verified and what was not.

## Completion standard

Before declaring a task done, be explicit about:

- what changed
- what was verified
- what review agents or review steps were used
- what durable artifacts were updated
- any remaining blockers, drift, or open questions
```

## Default multi-agent mapping

For a research or public-artifact repo such as referenda, start from a
copy-ready block like this and then replace each role with the repo's actual
specialists:

```md
## Default specialist mapping

- Data ingest / transformation / analysis changes: use `[analysis-reviewer]`,
  `[domain-reviewer]`, and `[verifier]`
- Result tables / figures / maps / released artifacts: use
  `[artifact-reviewer]`, `[domain-reviewer]`, and `[verifier]`
- Workflow / automation / repo-governance changes: use `[workflow-reviewer]`
  and `[verifier]`
- Documentation or methods changes that make substantive claims: use
  `[docs-reviewer]` and `[domain-reviewer]`
- Exploratory work proposed for promotion into production paths: use
  `[implementation-reviewer]` and `[verifier]`
- Final verification: use `[verifier]` or `[repo-standard check suite]`
```

If a change crosses multiple surfaces, run the relevant specialists in
parallel and synthesize one durable report instead of treating review as a
single-role gate.

For referenda-style work, the default expectation is usually:

- one reviewer for implementation correctness
- one reviewer for substantive election or domain correctness
- one verification owner for reproducibility, artifact freshness, or command checks

## Existing-agent mapping table

Add a section like this to `AGENTS.md` or a local workflow doc:

```md
## Specialist mapping

| Workflow role | Existing repo agent / reviewer | When to use |
|---|---|---|
| Implementation specialist | `[agent-name]` | `[task types]` |
| Code reviewer | `[agent-name]` | `[task types]` |
| Domain reviewer | `[agent-name]` | `[task types]` |
| Verifier | `[agent-name or command suite]` | `[task types]` |
| Release / packaging reviewer | `[agent-name]` | `[task types]` |
```

This lets the methodology transfer even if agent names differ from this repo.

For a referenda-style repo, a practical mapping might look like:

```md
## Specialist mapping

| Workflow role | Existing repo agent / reviewer | When to use |
|---|---|---|
| Analysis-code reviewer | `[analysis-reviewer]` | Data prep, joins, transformations, statistical or tabulation code |
| Domain reviewer | `[elections-domain-reviewer]` | Ballot-measure logic, jurisdiction rules, interpretive claims |
| Workflow reviewer | `[workflow-reviewer]` | `AGENTS.md`, automation, release instructions, infra docs |
| Artifact reviewer | `[artifact-reviewer]` | Tables, figures, maps, exported outputs, public-facing docs |
| Verifier | `[qa-runner or command suite]` | Repro runs, artifact freshness, smoke checks |
| Adversarial critic | `[red-team reviewer]` | Scoped high-stakes surfaces |
| Fixer | `[implementation owner]` | Address critic findings without expanding scope |
```

## Scoped adversarial-review rule

Adversarial review should be **narrowly scoped**, not globally required.

Use a rule like this in the target repo:

```md
## High-stakes adversarial review

- Default rule:
  - Use the repo's standard specialist review path for normal changes.
- Escalate to an adversarial critic/fixer or red-team/rebuttal pass only when
  the change is high-stakes.
- Treat these as high-stakes by default:
  - transformation logic that can change released counts, classifications, or
    jurisdiction-level results
  - methods text, documentation, or release notes tied to published findings or
    public claims
  - workflow rules, automation, or verification logic that can silently weaken
    review, reproducibility, or artifact freshness
  - release or deployment commands that can overwrite, publish, or invalidate
    public artifacts
  - destructive or difficult-to-reverse data migrations, backfills, or archive
    rewrites
- If adversarial review is used, record:
  - why the change qualified as high-stakes
  - what exact files, commands, or claims were in scope
  - which critic/reviewer roles were used
  - what verification or rollback checks were added
- If the change is important but not high-stakes, use normal multi-agent review
  plus the repo's narrow verification suite instead of forcing a red-team loop.
```

This preserves the spirit of adversarial QA without accidentally making every
routine repo or docs change pay the cost of a heavyweight review loop.

## Existing-plan integration block

Document the repo's actual durable planning surfaces:

```md
## Durable state locations

- Plans live in: `[path]`
- Session logs live in: `[path]`
- Review reports live in: `[path]`
- Verification notes live in: `[path or "same as above"]`
```

If the repo already has ADRs, issue templates, runbooks, or milestone docs, use
them rather than creating duplicate planning systems.

If the repo already has strong durable planning habits, the right integration is
usually "preserve and reinforce," not "replace and migrate."

## `KNOWLEDGE_BASE.md` starter

Use this for stable repo truth:

```md
# Knowledge Base

## Canonical conventions

| Area | Convention | Example | Anti-pattern |
|---|---|---|---|
| Architecture | Fill in | Fill in | Fill in |
| Naming | Fill in | Fill in | Fill in |
| Verification | Fill in | Fill in | Fill in |

## Important artifacts

| Artifact | Purpose | Location | Notes |
|---|---|---|---|
| Fill in | Fill in | Fill in | Fill in |

## Known pitfalls

| Pitfall | Impact | Fix |
|---|---|---|
| Fill in | Fill in | Fill in |
```

## `MEMORY.md` starter

Use this for workflow lessons:

```md
# Workflow Memory

[LEARN] YYYY-MM-DD — short title
Context:
Lesson:
Action:
```

Good early entries:

- where Codex tends to stumble in this repo
- which existing specialists are most reliable for which tasks
- which specialist combinations are the default multi-agent review sets
- which change classes should trigger adversarial review
- which verification steps are easy to forget
- what should always be written to disk during longer tasks

## Integration checklist

Use this when adopting the overlay in a repo:

- Keep the repo's existing agents and planning docs.
- Decide which host-native directories will hold plans, session logs, and review artifacts.
- Add or update a root `AGENTS.md` with overlay orchestration rules.
- Document where plans, logs, and reports already live.
- Map existing agents to workflow roles and define the default multi-agent
  review combinations.
- Define which change classes count as high-stakes enough for adversarial
  review.
- Decide which starter-pack features will port directly, which will be adapted,
  and which will be skipped.
- Prefer phased adoption: Milestone A first, then B, then C.
- Add `KNOWLEDGE_BASE.md` and `MEMORY.md` if missing.
- Make verification and completion standards explicit.
- Do one pilot task and refine the overlay from what you learn.

## Anti-patterns to avoid

- Replacing good existing agents just to match another repo's names.
- Introducing a second planning system when the repo already has one.
- Copying slide- or domain-specific rules into unrelated repos.
- Making the overlay so broad that it overrides useful local conventions.
- Requiring adversarial review for routine changes that only need standard
  specialist review plus verification.
- Treating verification or review as optional once implementation is done.
