## Goal

Rename the repository's working name from `codex-my-workflow` to
`claude-codex-my-workflow` across the repo-facing documentation, prompts,
templates, and generated artifacts that should follow the current project name.

## Plan

1. Inventory current name usage in docs, templates, workflow prompts, and
   generated markdown that reference the repo or its local absolute path.
2. Update the repo-facing references to `claude-codex-my-workflow`, including
   absolute local paths and GitHub links where the new name should become the
   canonical reference.
3. Preserve clearly historical upstream references to
   `claude-code-my-workflow` where they describe the source project rather than
   this repo.
4. Verify the remaining matches with targeted search and record any intentional
   exceptions.
5. Write a breadcrumb and wrap-up summary so the rename rationale and limits
   are durable on disk.

## Assumptions

- The user wants the current repo's name updated for dual-model usage.
- Historical references to the upstream source repo may remain when they are
  describing provenance rather than this repo's current identity.
- Renaming the enclosing filesystem directory is a separate step because it
  changes the live workspace path and may require permission outside the current
  writable root.

## Quality Target

90 = repo-facing naming is internally consistent, verification is documented,
and any intentionally unchanged references are explicit.
