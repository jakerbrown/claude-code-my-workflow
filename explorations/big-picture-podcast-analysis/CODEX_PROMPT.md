# Master Prompt: Big Picture Podcast Transcript Project

Paste or adapt the prompt below in a fresh Codex task when you want Codex to
run the full project.

---

You are working inside `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow`.
This is a high-standards exploratory research task that should be executed with
PhD-level statistical rigor, transparent workflow habits, and blog-quality
writing. Your objective is to build an end-to-end empirical analysis of *The
Big Picture* podcast transcripts and draft a publication-ready blog post with a
full code-only replication package.

The final output should answer three core questions:

1. How has sentiment evolved over the last few years as the hosts discuss
   movies and the state of the movie industry?
2. Which movies do they like and dislike, and what commonalities characterize
   the movies they praise or criticize?
3. What is their working Oscar-prediction model: what evidence do they cite,
   how often do predictions change, and how accurate are those predictions?

## Working style and repo rules

Follow this repository's workflow rules strictly:

1. Read the active `AGENTS.md` guidance, `MEMORY.md`, `KNOWLEDGE_BASE.md`, and
   any relevant nested `AGENTS.md` files before doing substantial work.
2. Because this is a non-trivial task, create or refresh:
   - `quality_reports/plans/YYYY-MM-DD_big-picture-podcast-analysis.md`
   - `quality_reports/session_logs/YYYY-MM-DD_big-picture-podcast-analysis.md`
3. Work under a self-contained exploration folder:
   - `explorations/big-picture-podcast-analysis/`
4. Use the contractor loop:
   - implement -> verify -> review -> fix -> re-verify -> score -> summarize
5. Leave a concise breadcrumb in:
   - `quality_reports/codex_activity/YYYY-MM-DD_big-picture-podcast-analysis.md`
6. Treat the minimum acceptable quality level for the final package as **90**.
7. Use explicit subagents. Do not assume specialist review happens
   automatically in Codex.
8. Save durable reasoning to files under `quality_reports/` and
   `explorations/big-picture-podcast-analysis/output/` instead of leaving
   important logic only in chat.

## Top-level objective

Produce a blog-ready empirical post on *The Big Picture* that combines:

- original transcript collection and cleaning
- time-series sentiment analysis
- movie-level preference inference
- a structured Oscar-prediction database
- statistical models, uncertainty statements, and robustness checks
- clear figures and tables suitable for a serious blog post
- prose that reads like an excellent methods-forward essay, not a generic media
  recap

The final post should be accessible to an intelligent general audience but
rigorous enough that a quantitative social-science PhD would respect the
empirical design, measurement choices, and caveats.

## Final deliverables

You are aiming to produce all of the following unless feasibility constraints
make a subset impossible:

- `explorations/big-picture-podcast-analysis/README.md`
- `explorations/big-picture-podcast-analysis/SESSION_LOG.md`
- `explorations/big-picture-podcast-analysis/CODEX_PROMPT.md`
- `explorations/big-picture-podcast-analysis/data/raw/`
- `explorations/big-picture-podcast-analysis/data/processed/`
- `explorations/big-picture-podcast-analysis/output/`
- `explorations/big-picture-podcast-analysis/output/source_memo.md`
- `explorations/big-picture-podcast-analysis/output/feasibility_memo.md`
- `explorations/big-picture-podcast-analysis/output/methods_memo.md`
- `explorations/big-picture-podcast-analysis/output/results_memo.md`
- `explorations/big-picture-podcast-analysis/output/blog_post_draft.qmd`
- `explorations/big-picture-podcast-analysis/output/blog_post_draft.md`
- `explorations/big-picture-podcast-analysis/output/blog_post_for_site.md`
- `explorations/big-picture-podcast-analysis/output/references.md`
- `explorations/big-picture-podcast-analysis/output/episode_manifest.csv`
- `explorations/big-picture-podcast-analysis/output/transcript_manifest.csv`
- `explorations/big-picture-podcast-analysis/output/movie_mentions.csv`
- `explorations/big-picture-podcast-analysis/output/movie_scores.csv`
- `explorations/big-picture-podcast-analysis/output/oscar_predictions.csv`
- `explorations/big-picture-podcast-analysis/output/oscar_prediction_evaluation.csv`
- `explorations/big-picture-podcast-analysis/output/fig_sentiment_timeseries.png`
- `explorations/big-picture-podcast-analysis/output/fig_movie_preference_clusters.png`
- `explorations/big-picture-podcast-analysis/output/fig_oscar_prediction_accuracy.png`
- `explorations/big-picture-podcast-analysis/output/tab_sentiment_model.csv`
- `explorations/big-picture-podcast-analysis/output/tab_movie_commonalities.csv`
- `explorations/big-picture-podcast-analysis/output/tab_oscar_evidence_weights.csv`
- `explorations/big-picture-podcast-analysis/replication/README.md`
- `explorations/big-picture-podcast-analysis/replication/run_all.sh`
- `explorations/big-picture-podcast-analysis/replication/requirements.txt`
- `explorations/big-picture-podcast-analysis/replication/src/`
- `quality_reports/review_r_big-picture-podcast-analysis.md`
- `quality_reports/review_domain_big-picture-podcast-analysis.md`
- `quality_reports/proofread_big-picture-podcast-analysis.md`
- `quality_reports/verifier_big-picture-podcast-analysis.md`
- `quality_reports/adversarial_big-picture-podcast-analysis_round1.md`
- `quality_reports/adversarial_big-picture-podcast-analysis_round2.md`

The final blog post must link clearly to the replication folder inside this
repo. The replication folder should be code-only, fully runnable, and include
the code that pulls transcripts or transcript metadata. If scraping, API use,
or downloading is blocked, include the best lawful pull pipeline you can build
and document exactly what inputs still need to be supplied manually.

## Non-negotiable standards

1. Do not fake access to transcripts, APIs, or private subscriptions.
2. Do not treat off-the-shelf sentiment scores as ground truth.
3. Do not infer movie liking from one quote or one episode if repeated evidence
   is available.
4. Do not present Oscar-prediction accuracy without defining what counts as a
   prediction, a revision, and an outcome.
5. Do not hide uncertainty, coder judgment, or ambiguous cases.
6. Do not stop after implementation plus light verification. This prompt
   requires specialist review and an adversarial review loop.
7. Do not let the post become a vibes-only essay. Claims must be tied to
   artifacts, models, or coded evidence.
8. Do not use copyrighted transcript text in ways that exceed lawful access or
   redistribution. Quote sparingly in the post and keep the replication folder
   code-only.

## Research agenda

Answer the following with real empirical work:

### 1. Sentiment over time

- Build an episode-level and, if feasible, segment-level time series of how the
  hosts talk about:
  - specific movies
  - the movie industry
  - theaters / box office / streaming / studios / awards ecosystem
- Distinguish:
  - sentiment toward a movie
  - sentiment toward the industry's health or direction
  - nostalgia, irony, and playful banter from genuine evaluation
- Show whether sentiment changes across:
  - calendar time
  - major industry shocks or award seasons
  - episode types such as rankings, drafts, interviews, Oscar coverage, or
    year-end episodes

### 2. Which movies they like and dislike

- Build a movie-level preference score from transcript evidence, not just raw
  adjective counts.
- Identify the movies they most consistently praise and most consistently
  criticize.
- Look for commonalities across liked and disliked movies, such as:
  - genre
  - director prestige
  - franchise status
  - budget / box office profile
  - release year / era
  - awards trajectory
  - critical reception
  - auteur status
  - whether the film is perceived as "movie movie" entertainment versus
    prestige / streaming / franchise product
- Separate host-specific preferences if the data permit.

### 3. Oscar-prediction model

- Build a structured dataset of Oscar predictions over time.
- Define what counts as:
  - an explicit prediction
  - a tentative lean
  - a revision
  - a rationale
  - a realized award outcome
- Code or extract the types of evidence they cite, such as:
  - precursor awards
  - box office
  - campaign strength
  - industry narrative
  - festival buzz
  - guild performance
  - release timing
  - star / director / studio reputation
  - "this is how the Academy thinks" priors
- Estimate a working theoretical model of their prediction process:
  - Which evidence types appear most often?
  - Which evidence types precede revisions?
  - How sticky are early predictions?
  - When are they contrarian versus consensus-following?
  - How accurate are predictions at different horizons before the Oscars?

## Feasibility gate: do this first

Before deep implementation, write `output/feasibility_memo.md` and determine:

1. What transcript sources are actually accessible and lawful to use.
2. Whether transcripts exist for enough episodes over the last few years to
   support the full analysis.
3. Whether episode descriptions, show notes, YouTube captions, podcast pages,
   or third-party transcript sources can supplement missing transcripts.
4. Whether Oscar-prediction history can be coded from transcripts alone or
   whether additional episode metadata are needed.
5. Which parts of the full project are strongly feasible, partially feasible,
   or blocked.

If transcript access is weak, do not bluff. Continue with the strongest
defensible subset and document the minimum additional inputs needed.

## Data acquisition and source realism

Build a transparent source memo covering:

- podcast RSS feeds, episode pages, YouTube uploads, transcript pages, or other
  lawful text sources
- what was downloaded automatically versus what required manual input
- coverage by year and episode type
- any de-duplication and transcript-quality screening
- missingness and how it may bias results

Create a reproducible pull pipeline inside:

- `explorations/big-picture-podcast-analysis/replication/src/`

The replication package should:

- download episode metadata
- attempt transcript retrieval where lawful and technically feasible
- save manifests describing success and failure
- avoid embedding copyrighted full transcript dumps if that would be improper
- make downstream processing reproducible from the accessible inputs

## Empirical design expectations

Use more than one measurement family where possible. Favor triangulation over
single-tool answers.

### Sentiment design

Use a layered approach such as:

- lexicon or transformer-based sentiment as a rough baseline
- custom dictionary or prompt-based coding for industry-state language
- supervised or hand-validated coding on a sampled subset
- host-level aggregation and episode-level aggregation
- robustness checks against sarcasm, joking, and quoted speech

Do not rely on a single NLP label. Validate on hand-coded examples.

### Movie preference design

Construct a movie-preference score from repeated mention contexts. Potential
inputs:

- explicitly evaluative statements
- rankings, top-five lists, year-end discussions
- "rewatchability" style praise
- negative dismissals, disappointment framing, mockery, or lukewarm hedging
- persistence of praise or criticism across episodes

Then test commonalities among liked and disliked movies using defensible
comparisons:

- descriptive comparisons
- penalized regression or tree-based models
- clustering / dimensionality reduction
- matched comparisons if helpful

Be explicit about the limits of causal interpretation.

### Oscar-prediction design

Treat this as a longitudinal belief-updating problem. Possible methods include:

- coded event-history style panels by category and contender
- state-transition summaries of how frontrunners change over time
- logistic or multinomial models for winner prediction
- text coding of cited evidence types
- accuracy by horizon: early season, post-festival, post-guild, final week

Distinguish consensus narration from personal prediction where possible.

## Statistical standards

This should feel like a serious applied statistics project.

Use the strongest methods the data support, but favor clarity and validity over
performative complexity. Where useful, include:

- uncertainty intervals
- model comparison tables
- sensitivity analyses
- train/test or temporal holdout logic for prediction exercises
- inter-coder agreement if hand-coding is used materially
- error analysis on the biggest misses
- clear definition of units, denominators, and samples

Every table and figure in the post should be backed by a saved artifact.

## Writing standards for the blog post

The final post should be a polished, public-facing essay with:

- a strong opening motivation
- clear methods and data sections
- visually clean figures and tables
- enough theory to unify the findings
- careful caveats without becoming timid or unreadable
- a conclusion that says what we learned about taste and Oscar reasoning on the
  show

Write with an academic researcher's discipline and a good cultural critic's
readability.

## Quarto and blog-output expectations

Author the final post in Quarto unless there is a strong repo-specific reason
not to. Suggested targets:

- `explorations/big-picture-podcast-analysis/output/blog_post_draft.qmd`
- `explorations/big-picture-podcast-analysis/output/blog_post_for_site.md`

If you create a secondary briefing deck or figure appendix to give the review
agents better surfaces, keep it inside the same exploration folder.

## Mandatory specialist workflow

This repo has a 10-agent specialist set documented in the workflow guide. For
this project, use **all 10 explicitly**, plus the adversarial critic/fixer
loop. Some are slide-oriented; for those, create the closest relevant artifact
if needed and document their marginal value honestly rather than skipping them.

### Required 10-agent set

1. `proofreader`
   - Review the final blog post prose for clarity, overstatement, structure, and
     copy quality.
2. `slide-auditor`
   - Review figures, tables, layout density, and visual presentation in the
     Quarto post or any companion briefing artifact.
3. `pedagogy-reviewer`
   - Review explanatory flow, whether the reader can follow the methods, and
     whether the statistical exposition is well scaffolded.
4. `r-reviewer`
   - Review any substantial R analysis, modeling, or reporting scripts.
5. `tikz-reviewer`
   - Review any custom diagrams, conceptual figures, or generated schematic
     visuals. If no TikZ is used, create or audit one conceptual workflow figure
     only if it materially helps the post.
6. `beamer-translator`
   - If you create a short Beamer or slide-style summary artifact for review or
     dissemination, use this agent on that artifact. If no Beamer artifact ends
     up being useful, document why this agent added little marginal value after
     at least a scoped attempt.
7. `quarto-critic`
   - Serve as the adversarial reviewer of the Quarto post and any paired
     artifacts.
8. `quarto-fixer`
   - Address `quarto-critic` findings in the adversarial loop.
9. `verifier`
   - Perform an end-to-end package verification pass.
10. `domain-reviewer`
   - Review the substantive interpretation of movie taste, industry sentiment,
     and Oscar-theory claims.

### How to use the specialists

Do not merely mention them. Actually invoke them in a serious workflow:

1. After the first substantial implementation pass, spawn the relevant
   read-only review agents in parallel where possible.
2. Save each report under `quality_reports/`.
3. Fix material findings.
4. Re-run verification.
5. Run the adversarial `quarto-critic` / `quarto-fixer` loop for at least one
   real round, and continue until `APPROVED` or until additional rounds are no
   longer productive.
6. In the final summary, list each of the 10 agents and what concrete value it
   added.

If one of the 10 agents is only weakly relevant, do not silently skip it.
Instead:

- make a scoped attempt to use it on the nearest plausible artifact
- record the outcome
- explain briefly why its contribution was limited

## Concrete workflow sequence

Execute roughly in this order:

1. Read repo instructions and create plan/session log.
2. Build the exploration scaffold and replication scaffold.
3. Run the feasibility audit and source memo.
4. Pull episode metadata and transcripts where lawful.
5. Build cleaned datasets for episodes, mentions, movies, and Oscar
   predictions.
6. Run exploratory analysis and diagnostics.
7. Build the sentiment analysis pipeline and validate it.
8. Build the movie-preference inference pipeline and commonality analysis.
9. Build the Oscar-prediction database and theoretical model.
10. Draft the post with figures and tables.
11. Run all 10 specialist agents plus the adversarial loop.
12. Fix issues, re-verify, and score the package.

## Replication-folder requirements

The replication package must be code-only and independent of the narrative
draft. It should contain:

- data-pull code
- transcript / metadata manifests
- processing scripts
- analysis scripts
- figure/table generation scripts
- environment requirements
- one-click or near-one-click orchestration via `run_all.sh`

If some inputs cannot be redistributed, the replication README should explain:

- which files are generated automatically
- which files the user must supply
- where to place them
- how the pipeline behaves when they are absent

## Figure and table expectations

At minimum, produce:

- one clear time-series figure on sentiment over time
- one movie-level figure showing liked versus disliked clusters or dimensions
- one Oscar-prediction figure showing accuracy or revision dynamics
- one methods / sample coverage table
- one table on movie commonalities
- one table on Oscar evidence usage or predictive weight

Make the visuals publication-ready, readable, and captioned.

## Honesty and uncertainty

If you cannot fully answer one of the three core questions, say so cleanly and
show the strongest partial answer. It is better to produce an honest,
well-bounded result than a falsely comprehensive one.

## Completion standard

Do not declare the task complete until you can state clearly:

- what changed
- what data were pulled and from where
- what was verified
- which of the 10 agents ran and what each contributed
- whether the adversarial reviewer approved the final post
- where the replication folder lives
- current quality score
- remaining limitations or blockers
