# Existing Repo Migration Checklist

Use this checklist before integrating the starter pack into an existing repo.

## Planning and durable state

- What planning surface already exists?
- Where should session logs or progress notes live?
- Where should deeper review or audit artifacts live?
- Should the starter pack adapt to `memos/`, `docs/`, ADRs, or another host-native surface?

## Domain and authority

- Which docs are authoritative for domain truth?
- Which rules must the workflow overlay never weaken?
- What verification conventions already exist and should be preserved?

## Repeated workflows

- Which tasks repeat often enough to justify repo-local skills?
- Which review roles are stable enough to justify reviewer role files?
- Which parts of the repo need nested `AGENTS.md` files first?

## Integration strategy

- Which starter-pack pieces should port directly?
- Which should be adapted to the host repo?
- Which should be skipped because they solve the wrong problem class?
- Is the right rollout Milestone A first, then B, then C?

## Documentation honesty

- Does the repo README document only what actually exists on disk?
- Are new templates clearly subordinate to the host repo's existing plan format?
- Are review and adversarial-QA defaults explicit without overclaiming automation?
