# Repo Integration Roadmap Template

Use this when an existing repo is likely to absorb most of this workflow over
time, but should do so in phases.

## Goal

State what "integrated enough" should mean for the host repo.

## Host-repo constraints to preserve

- authoritative planning surface:
- authoritative domain docs:
- existing review or verification conventions:
- durable state locations to keep:

## Phase plan

### Milestone A: operational foundation

- repo-local `.codex/` config, hooks, and rules
- first-pass `.agents/skills/`
- explicit review mappings
- scoped adversarial review for high-stakes changes

### Milestone B: structure and consistency

- nested `AGENTS.md` files for high-risk paths
- repo-specific workflow guide
- lightweight templates that support the host planning system

### Milestone C: deeper specialization

- reviewer role files under `.codex/agents/`
- lightweight review or audit surface
- additional automation only where repeated use justifies it

## Direct port vs adapt vs skip

### Port directly

- Fill in:

### Adapt

- Fill in:

### Skip unless relevant

- Fill in:

## Recommended first sprint

List the narrowest high-leverage first implementation pass.

## Success criteria

- what will be true after Milestone A:
- what will be true after Milestone B:
- what will be true after Milestone C:
