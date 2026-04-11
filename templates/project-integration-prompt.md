# Project Integration Prompt

Use this prompt when you want Codex to integrate the workflow from
`claude-codex-my-workflow` into another existing repository.

## Copy-ready prompt

```text
Use /Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow as the source workflow and integrate its functionality into the target repo at [TARGET_REPO_PATH].

Goals:
- Preserve the target repo’s existing project structure, safety rules, domain conventions, and active production workflows.
- Integrate as much of claude-codex-my-workflow as is appropriate without forcing a full starter-pack clone where that would be overkill.
- Prefer an overlay approach first, then add deeper infrastructure only where it is justified by stable repeated patterns.

What I want you to do:
1. Inspect both repos first:
   - Read the target repo’s `AGENTS.md`, `README.md`, `KNOWLEDGE_BASE.md`, `MEMORY.md`, plans/session-log structure, and any repo-specific workflow docs.
   - Read the relevant workflow files in `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow`, especially:
     - `AGENTS.md`
     - `docs/CODEX_WORKFLOW.md`
     - `templates/workflow-integration-overlay.md`
     - relevant `.codex/` files
     - relevant `.agents/skills/`
2. Compare the target repo against claude-codex-my-workflow and identify:
   - what is already integrated
   - what is partially integrated
   - what is missing
   - what should remain intentionally lighter-weight
3. Create a durable plan in the target repo before substantial edits.
4. Implement a high-value integration pass that, where appropriate, adds:
   - root workflow guidance
   - durable `KNOWLEDGE_BASE.md` and `MEMORY.md`
   - plan/session-log surfaces
   - explicit specialist review mappings
   - a scoped adversarial-review rule for high-stakes changes
   - a deeper `docs/CODEX_WORKFLOW.md` if justified
   - minimal safe `.codex/` infrastructure if justified
   - one or more repo-local skills if there is a stable repeated workflow
5. Keep safety constraints authoritative:
   - do not weaken existing data, infra, SCC/HPC, secrets, or external-path safety rules
   - do not add heavy automation casually
   - do not introduce custom subagents unless the reviewer pattern is stable enough to justify them
6. Verify the integration honestly:
   - re-read changed docs and infra files
   - verify referenced files and paths exist
   - run only the narrowest safe checks
   - if you add hooks or local workflow infrastructure, test them directly
7. Write durable session-log notes and summarize:
   - what changed
   - what was verified
   - what review structure was added
   - which claude-codex-my-workflow features are still intentionally not ported
   - current quality level
   - whether the repo is cleanly staged for commit

Important style guidance:
- Treat the target repo as authoritative.
- Do not replace good local conventions just to match claude-codex-my-workflow.
- Prefer minimal, high-value integration first.
- If there are multiple reasonable integration depths, choose the lightest one that still meaningfully improves workflow quality.
- If custom agents, hooks, or skills are not yet justified, say so explicitly and add only the next-best lightweight structure.
```

## Usage note

Replace `[TARGET_REPO_PATH]` with the absolute path to the repo you want to
integrate.

Use [workflow-integration-overlay.md](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/templates/workflow-integration-overlay.md)
as the main adaptation reference when the target repo already has its own
structure and conventions.
