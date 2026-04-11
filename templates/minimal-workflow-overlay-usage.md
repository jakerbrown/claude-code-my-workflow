# Minimal Workflow Overlay Usage

Use [minimal-workflow-overlay-kit.md](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/templates/minimal-workflow-overlay-kit.md) when rolling this workflow out across many repos.

## Recommended rollout order

For each repo:

1. Find the repo's existing plan path.
2. Find the repo's existing session-log or durable progress-note path.
3. Identify the repo's default specialists or review commands.
4. Identify the narrowest standard verification commands.
5. Pick the quality threshold.
6. Define which high-stakes changes should escalate to adversarial review.
7. Drop the copy-ready `AGENTS.md` overlay into the repo and fill in the six fields.

If the repo proves it needs more structure, expand in this order:

1. add repo-local `.codex/`
2. add repo-local skills
3. add explicit review mappings and high-stakes review governance
4. add nested `AGENTS.md`
5. add workflow docs and templates
6. add reviewer role files and a review/audit surface

## Fast fill-in worksheet

```text
PLAN_PATH=
SESSION_LOG_PATH=
SPECIALIST_MAP=
VERIFY_COMMANDS=
QUALITY_THRESHOLD=
HIGH_STAKES_RULE=
```

## Example

```text
PLAN_PATH=docs/plans/
SESSION_LOG_PATH=docs/session_logs/
SPECIALIST_MAP=Backend/code changes: use backend-reviewer + verifier; Docs changes: use docs-reviewer; Final verification: use verifier
VERIFY_COMMANDS=pytest -q; ruff check .
QUALITY_THRESHOLD=80
HIGH_STAKES_RULE=release-critical behavior, security-sensitive changes, and correctness-sensitive simulation or data logic
```

## When to use the broader overlay instead

Use [workflow-integration-overlay.md](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/templates/workflow-integration-overlay.md) instead when:

- the repo has unusual planning/reporting structure
- the repo needs a more explicit agent-role mapping table
- the repo needs default multi-agent review mappings by change type
- the repo needs a scoped adversarial-review rule for high-stakes changes
- the repo lacks `KNOWLEDGE_BASE.md` and `MEMORY.md`
- the repo needs more detailed orchestration guidance
- the repo is likely to absorb most of this starter pack over time

## Best practice

Start with the minimal kit in every repo, then only graduate a repo to the
broader overlay or starter pack if that repo proves it needs more structure.

For mature existing repos, "needs more structure" often means "wants almost all
of the workflow, but adapted to the repo's own planning and documentation
habits."
