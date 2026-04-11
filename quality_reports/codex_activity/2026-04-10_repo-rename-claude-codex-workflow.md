Renamed the local workflow repo from `codex-my-workflow` to
`claude-codex-my-workflow` so the name matches the fact that the workflow now
uses both Claude and Codex. I updated the repo-facing local paths and working
name references in templates, prompts, and a few generated artifacts, then
renamed the actual local folder so those updated paths are real. This mattered
because the repo had drifted into an awkward state where the folder name,
internal references, and remote naming all disagreed. Verified the new local
path and confirmed the old absolute path no longer appears in the repo. Left
public GitHub links on the current live slug because the GitHub repo itself was
not renamed in this session.
