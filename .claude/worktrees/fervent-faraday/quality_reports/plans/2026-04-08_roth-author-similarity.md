# Plan: roth author similarity

- **Date:** 2026-04-08
- **Status:** COMPLETED
- **Owner:** Codex
- **Quality target:** 80

## Goal

Produce a serious exploratory research package and blog-ready draft answering
which modern authors write most like Philip Roth, using transparent,
multi-method text analysis and a personalized Goodreads overlap layer. The work
must be reproducible, honest about corpus limits, and reviewed with explicit
specialists plus an adversarial critic loop.

## Scope

- In scope:
  - Run a feasibility audit before deep analysis.
  - Build a defensible candidate pool broader than common Roth-comparison
    clichés.
  - Create reproducible code and output artifacts under
    `explorations/philip-roth-author-similarity/`.
  - Compare similarity across multiple dimensions rather than one scalar.
  - Integrate Goodreads overlap from the local export if readable.
  - Write durable memos, review reports, and a blog draft.
- Out of scope:
  - Pretending copyrighted or private corpora are available when they are not.
  - Logging into private services.
  - Making claims stronger than the accessible corpus supports.

## Assumptions and clarifications

- CLEAR: The user wants execution, not just planning, and explicitly requested
  a feasibility audit first.
- CLEAR: Minimum acceptable completion quality is 80 despite the work living in
  `explorations/`.
- ASSUMED: "Modern" will initially mean post-1960 literary fiction, with
  author selection focused on writers whose major careers overlap or follow
  Roth's mature period.
- ASSUMED: The main analysis should prioritize novels and novel excerpts for
  comparability; short stories may be used only if corpus access forces it and
  the methods memo documents the compromise.
- ASSUMED: The first pass will be primarily Anglophone or English-available
  authors, because accessible English prose is necessary for direct comparison.
- ASSUMED: Both book-level and author-level scoring are desirable if the corpus
  allows them.
- BLOCKED: Reading `/Users/jacobbrown/Downloads/goodreads_library_export.csv`
  requires permission outside the sandbox.
- BLOCKED: A serious Roth prose corpus has not yet been located locally.

## Files likely to change

- `quality_reports/plans/2026-04-08_roth-author-similarity.md`
- `quality_reports/session_logs/2026-04-08_roth-author-similarity.md`
- `quality_reports/codex_activity/2026-04-08_roth-author-similarity.md`
- `explorations/philip-roth-author-similarity/README.md`
- `explorations/philip-roth-author-similarity/SESSION_LOG.md`
- `explorations/philip-roth-author-similarity/src/*`
- `explorations/philip-roth-author-similarity/output/*`
- `quality_reports/review_r_roth-author-similarity.md`
- `quality_reports/review_domain_roth-author-similarity.md`
- `quality_reports/proofread_roth-blog-post.md`
- `quality_reports/verifier_roth-author-similarity.md`
- `quality_reports/adversarial_roth-blog_round1.md`
- `quality_reports/adversarial_roth-blog_round2.md`

## Implementation approach

1. Complete the feasibility audit for corpus access, Goodreads access, and
   method support.
2. If enough text is accessible, build a candidate pool, corpus manifest, and
   reproducible feature-extraction pipeline under the exploration directory.
3. Generate method-specific rankings for topic, style, voice, social-world
   features, and composite similarity, with explicit uncertainty and
   sensitivity checks.
4. Merge in Goodreads overlap and draft a results memo plus blog-ready essay.
5. Run specialist review, adversarial critique, fixes, re-verification, and
   final scoring before wrap-up.
6. Publish a public-safe replication folder with portable paths and accurate
   blog links.

## Verification plan

- Compile / render:
  - Not applicable unless the package gains rendered figures requiring a
    specific command.
- Run scripts / tests:
  - Execute the analysis entry point(s) that generate the output tables and
    memos.
- Manual checks:
  - Confirm all claimed output files exist.
  - Confirm methods memo matches the implemented pipeline.
  - Confirm blog-post claims match the ranking outputs and robustness notes.
  - Confirm Goodreads claims are labeled verified or pending.
- Reports to write:
  - Session log updates.
  - Specialist review reports.
  - Adversarial review reports.
  - Codex activity breadcrumb.

## Review plan

- Specialists to spawn:
  - `r-reviewer`
  - `domain-reviewer`
  - `proofreader`
  - `verifier`
  - at least one additional skeptical subagent for adversarial critique
- Whether adversarial QA is needed:
  - Yes. Two explicit critic rounds are required.
- Final quality threshold:
  - 80

## Risks

- Risk: The legally accessible Roth corpus may be too thin for a confident
  multi-author ranking.
- Mitigation: Treat feasibility as binding, document blocked methods, and
  downgrade claims rather than bluff.
- Risk: Goodreads integration may be partially blocked by sandbox permissions.
- Mitigation: Request the minimum necessary approval for local export access and
  label any unresolved read-status claims as pending.
- Risk: Available tooling may not support the fanciest NLP methods locally.
- Mitigation: Prefer reproducible, interpretable methods that run with the
  installed Python and R packages, and explain what was not feasible.
