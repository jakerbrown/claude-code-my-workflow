# Plan: generic workflow starter

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 90

## Goal

Create a cleaner project-agnostic starter pack that carries this repository's
workflow methodology into other repos without assuming slide, Quarto, or
academic-specific structure unless those project conventions are intentionally
added later.

## Scope

- In scope:
  - Refine starter-pack guidance and docs to emphasize reusable workflow
    principles.
  - Replace domain-specific placeholders in starter memory/knowledge files with
    generic project scaffolding.
  - Add clear installation and adaptation guidance for bringing the workflow to
    other repos.
- Out of scope:
  - Rewriting the main repository's domain-specific workflow.
  - Porting or validating every existing specialist skill for all project types.
  - Building a global installer outside the repo.

## Assumptions and clarifications

- CLEAR: The user wants a reusable workflow starter for other GitHub repos.
- ASSUMED: A repo-local starter pack is preferable to making other repos depend
  directly on this repository.
- ASSUMED: The starter should preserve the workflow's methods while removing
  slide-specific defaults where they are not broadly applicable.
- BLOCKED: None.

## Files likely to change

- `codex_port_starter/AGENTS.md`
- `codex_port_starter/README_CODEX_PORT_STARTER.md`
- `codex_port_starter/KNOWLEDGE_BASE.md`
- `codex_port_starter/MEMORY.md`
- `codex_port_starter/docs/CODEX_WORKFLOW.md`
- `codex_port_starter/docs/INSTALL_INSTRUCTIONS.md`
- `README_CODEX_PORT_STARTER.md`
- `docs/INSTALL_INSTRUCTIONS.md`

## Implementation approach

1. Keep the core workflow loop, durable-state model, and Codex packaging
   structure intact.
2. Rewrite starter guidance and documentation to speak in generic project terms.
3. Verify internal consistency by rereading edited docs and checking starter
   file inventory against the documented install path.

## Verification plan

- Compile / render: Not applicable for this infrastructure-doc task.
- Run scripts / tests: Use filesystem inspection and doc rereads.
- Manual checks:
  - Confirm the starter still documents required files and startup steps.
  - Confirm generic guidance no longer assumes slides or academic lectures as
    the default project shape.
  - Confirm optional domain-specific folders are framed as examples or add-ons.
- Reports to write:
  - Update session log with decisions and verification results.

## Review plan

- Specialists to spawn: None; this is a bounded infrastructure-doc packaging
  task and explicit subagent review is not necessary here.
- Whether adversarial QA is needed: No.
- Final quality threshold: 90

## Risks

- Risk: Over-generalizing could make the starter too vague to be useful.
- Mitigation: Keep concrete workflow rules, templates, and install steps.
- Risk: Docs may drift from the actual starter contents.
- Mitigation: Recheck file inventory and prompts after editing.
