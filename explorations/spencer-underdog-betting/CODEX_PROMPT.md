# Master Prompt: Spencer Early-Season Underdog Betting Project

Paste or adapt the prompt below in a fresh Codex task when you want Codex to
run the full research project.

---

You are working inside `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow`.
This is an exploratory but high-standards research task. Your objective is to
conduct a serious, reproducible empirical project and draft a blog post that
answers the question:

**Has Spencer's strategy of betting on early-season underdogs in the major U.S.
professional sports leagues historically made money?**

The strategy to test is:

- bet on underdogs in the first 2-3 weeks of a season
- rationale: market participants may not yet know which teams are actually good
  or bad
- implication: some teams priced as underdogs may be underrated, while the
  bettor is paid more when they win

The user wants this treated as a real data-science and empirical-research
project, not a casual sports blog. Think ambitious, careful, and interesting.
The final output should feel like a PhD-level stats/econometrics blog post with
clear figures, tables, uncertainty discussion, and transparent replication.

## Working style and repo rules

Follow this repository's workflow rules strictly:

1. Read the active `AGENTS.md` guidance, `MEMORY.md`, `KNOWLEDGE_BASE.md`, and
   any relevant nested `AGENTS.md` before doing substantial work.
2. Because this is a non-trivial task, create or refresh:
   - `quality_reports/plans/YYYY-MM-DD_spencer-underdog-betting.md`
   - `quality_reports/session_logs/YYYY-MM-DD_spencer-underdog-betting.md`
3. Work under a self-contained exploration folder:
   - `explorations/spencer-underdog-betting/`
4. Use the contractor loop:
   - implement -> verify -> review -> fix -> re-verify -> score -> summarize
5. Leave a concise breadcrumb in:
   - `quality_reports/codex_activity/YYYY-MM-DD_spencer-underdog-betting.md`
6. Treat the minimum acceptable quality level for the final package as **90**.
7. Use explicit subagents. Do not assume specialist review happens
   automatically in Codex.
8. Save important reasoning, findings, and review outputs on disk rather than
   leaving them only in chat.

## Top-level objective

Produce a blog-ready empirical analysis of whether systematically betting on
underdogs at the very beginning of professional sports seasons would have been
profitable, robustly enough to survive serious statistical scrutiny.

The analysis must cover **at least** the big 4 U.S. men's professional leagues:

- NFL
- NBA
- NHL
- MLB

Use roughly the last decade at minimum if data allow, and go longer where
feasible.

The final post should answer:

1. Did a naive early-season underdog strategy make money historically?
2. Does performance vary by league?
3. Is the result concentrated in the first 2 weeks, first 3 weeks, or some
   other early-season window?
4. Does any apparent edge survive vig, uncertainty, multiple-testing concerns,
   and sensible benchmarks?
5. Are there more refined variants of Spencer's idea that look better than the
   naive rule?
6. If real odds data prove incomplete, what does a calibrated market-learning
   simulation imply about when such a strategy could work?

## Non-negotiable standards

1. Do not fake access to odds data, line history, or betting results.
2. Prefer real historical betting odds and game results over simulation.
3. Use simulation only as a supplement, robustness check, or explicit fallback.
4. Do not report raw ROI without also addressing variance, uncertainty, sample
   size, and the bookmaker hold.
5. Do not cherry-pick one league, one season range, or one early-season window
   because it happens to look best.
6. Do not present noisy positive ROI as evidence of a true edge unless it
   survives sensible statistical scrutiny.
7. Do not stop at descriptive tables if a richer modeling layer is feasible.
8. Do not stop after implementation plus light verification. This prompt
   expects specialist review and an adversarial critique cycle.

## Required research questions

Answer the following explicitly:

1. Across the NFL, NBA, NHL, and MLB, what is the realized ROI of betting every
   early-season underdog at closing odds?
2. How does that compare with:
   - betting all underdogs over the full season
   - betting favorites early in the season
   - betting random teams
   - betting underdogs later in the season
   - equal-stake versus Kelly-style or fractional-Kelly staking
3. Are any positive results strongest in leagues with shorter seasons, more
   roster continuity, or lower preseason information quality?
4. How much of the result is explained by:
   - implied probability miscalibration
   - upset frequency
   - payout asymmetry
   - regression to preseason priors
5. Is there a better operational definition of "early season" than a blunt
   2-3 week rule?
6. Can a hierarchical or partial-pooling model identify whether any league has
   a persistent edge rather than noise?
7. Under a stylized market-learning model, when should early underdogs be
   mispriced, and do observed data resemble that pattern?

## Scope decisions you must make early

Make and justify explicit scope choices on:

- regular season only versus including playoffs
- closing lines versus opening lines versus consensus lines
- moneyline only versus moneyline plus spread/puckline/runline variants
- what counts as "week" for MLB and NBA, where teams play many games quickly
- whether "first 2-3 weeks" should be translated into:
  - calendar weeks from opening day
  - first N games per team
  - first X percent of the season
- minimum data completeness required for a league-season to be included

Do not bury these choices. Put them in the plan and the methods memo.

## Data-acquisition priority order

Prioritize public, documented, and legally accessible data sources. Start by
building a source memo and feasibility audit before committing to the final
pipeline.

### Preferred data types

- game-level historical moneylines, ideally closing odds
- opening odds if available for comparison
- game results and metadata
- season calendars and team identifiers
- if available, sportsbook consensus or multi-book snapshots

### Strong source preference

1. Official or well-documented public APIs
2. Public historical odds datasets with reproducible access
3. Public GitHub repositories or Kaggle datasets with clear provenance
4. Public archive pages that can be scraped legally and reproducibly
5. Simulation only where real-data coverage fails

### Source memo requirements

Write a durable memo that records:

- each candidate source
- coverage by league and year
- whether moneyline, spread, totals, or line history exist
- access method
- terms or practical limitations
- why the source was accepted or rejected

If a single harmonized odds source is not available across all leagues and
years, assemble the best defensible composite dataset and document the seams.

## Feasibility gate: do this before deep analysis

Before building the final pipeline, write down the answer to:

1. Can you obtain at least one reproducible public historical odds source for
   each of the big 4 leagues?
2. For each league, what years are covered well enough for a serious analysis?
3. Do you have actual moneyline odds, only spreads, or some mixed structure?
4. What is the cleanest defensible definition of underdog in the available
   data?
5. Which parts of the ideal design are blocked by missing public data?

If the data are weaker than hoped, do not bluff. Instead:

- complete the strongest defensible real-data analysis possible
- add a clearly labeled simulation or hybrid extension
- separate observed facts from model-based extrapolation

## Core empirical design

At minimum, build a game-level panel with:

- league
- season
- game date
- home team
- away team
- game outcome
- underdog indicator
- favorite indicator
- closing moneyline for each side if available
- implied probability from odds
- sportsbook or source identifier if relevant
- early-season window indicators

Use a transparent baseline strategy:

- stake a fixed amount, such as $100, on every qualifying underdog

Then expand to richer strategy definitions:

- first 2 calendar weeks
- first 3 calendar weeks
- first 5 games per team
- first 10 percent of the season
- only road underdogs
- only underdogs below or above a payout threshold
- only underdogs whose implied probability looks especially suspicious under
  your model

## Required analyses

### 1. Descriptive baseline

For each league and pooled across leagues, report:

- number of bets
- win rate
- average odds
- realized profit
- ROI
- drawdown or volatility metric
- confidence interval

### 2. Benchmark comparison

Compare Spencer's rule against:

- all underdogs, all season
- favorites in the same early-season windows
- random-team benchmark
- random-underdog timing benchmark created by permuting dates within season
- placebo windows later in the season

### 3. Market-calibration analysis

Test whether underdogs are systematically underpriced early in the season:

- compare realized win frequency with implied win probability
- plot calibration curves
- estimate deviations with uncertainty bands
- test whether miscalibration is strongest in early weeks

### 4. Regression / hierarchical modeling

Estimate models that ask whether early-season underdogs outperform after
controlling for league and season structure. Suitable options include:

- logistic models for outright win probability
- profit-per-bet or ROI regressions
- hierarchical Bayesian or partial-pooling models by league and season
- meta-analytic summaries across leagues

If you use Bayesian methods, keep priors reasonable and explain them.

### 5. Simulation or hybrid extension

If real data exist but the identification story is still weak, add a calibrated
market-learning simulation. The simulation should model:

- preseason priors about team strength
- information arrival from early games
- bookmaker updating
- bettor sentiment or public bias toward favorites

Use the simulation to answer:

- under what conditions should early underdogs be mispriced?
- are those conditions plausible?
- do observed patterns resemble the simulated mechanism?

This simulation is not a substitute for real data. It is a complement.

## Statistical standards

The final post should feel rigorous. Include as many of the following as are
appropriate:

- bootstrap confidence intervals
- cluster-robust uncertainty at the season or team level where sensible
- multiple-testing caution if many windows or variants are screened
- out-of-sample validation if you build predictive refinements
- shrinkage / partial pooling rather than over-reading league-by-league noise
- discussion of survivorship bias, selection on available odds data, and line
  availability bias

Be explicit that a strategy can look profitable in-sample without being a real
edge.

## Required figures and tables

Create clear, publication-quality figures and tables. At minimum:

- pooled ROI by early-season window and league
- cumulative profit trajectories for the baseline strategy
- calibration plot: implied probability versus realized win rate
- forest plot or coefficient plot for league-specific estimates
- table of data coverage by league and year
- table of main strategy results and benchmark comparisons

If the visuals become crowded, split them across the blog post and a methods
appendix.

## Required deliverables

Create as many of these as feasible, with real content:

- `explorations/spencer-underdog-betting/README.md`
- `explorations/spencer-underdog-betting/SESSION_LOG.md`
- `explorations/spencer-underdog-betting/data/`
- `explorations/spencer-underdog-betting/src/`
- `explorations/spencer-underdog-betting/output/`
- `explorations/spencer-underdog-betting/replication/`
- `explorations/spencer-underdog-betting/output/source_memo.md`
- `explorations/spencer-underdog-betting/output/data_coverage_table.csv`
- `explorations/spencer-underdog-betting/output/game_level_panel.parquet`
- `explorations/spencer-underdog-betting/output/strategy_results.csv`
- `explorations/spencer-underdog-betting/output/benchmark_results.csv`
- `explorations/spencer-underdog-betting/output/model_results.csv`
- `explorations/spencer-underdog-betting/output/methods_memo.md`
- `explorations/spencer-underdog-betting/output/results_memo.md`
- `explorations/spencer-underdog-betting/output/blog_post_draft.md`
- `explorations/spencer-underdog-betting/output/blog_post_for_site.md`
- `explorations/spencer-underdog-betting/output/references.md`
- `explorations/spencer-underdog-betting/output/fig_roi_by_window.png`
- `explorations/spencer-underdog-betting/output/fig_cumulative_profit.png`
- `explorations/spencer-underdog-betting/output/fig_calibration.png`
- `explorations/spencer-underdog-betting/output/fig_forest_plot.png`
- `explorations/spencer-underdog-betting/output/research_brief.tex`
- `explorations/spencer-underdog-betting/output/research_brief.qmd`
- `explorations/spencer-underdog-betting/replication/README.md`
- `explorations/spencer-underdog-betting/replication/requirements.txt`
- `explorations/spencer-underdog-betting/replication/run_all.sh`
- `explorations/spencer-underdog-betting/replication/src/`
- `quality_reports/review_r_spencer-underdog-betting.md`
- `quality_reports/review_domain_spencer-underdog-betting.md`
- `quality_reports/proofread_spencer-underdog-betting.md`
- `quality_reports/verifier_spencer-underdog-betting.md`
- `quality_reports/review_slides_spencer-underdog-betting.md`
- `quality_reports/review_pedagogy_spencer-underdog-betting.md`
- `quality_reports/review_tikz_spencer-underdog-betting.md`
- `quality_reports/review_beamer_translation_spencer-underdog-betting.md`
- `quality_reports/qa_critic_spencer-underdog-betting_round1.md`
- `quality_reports/qa_fixer_spencer-underdog-betting_round1.md`
- `quality_reports/qa_critic_spencer-underdog-betting_round2.md`
- `quality_reports/adversarial_spencer-underdog-betting_round1.md`
- `quality_reports/adversarial_spencer-underdog-betting_round2.md`

If some deliverables are not feasible, explain exactly why in the results memo.

## Code-only replication requirement

The user explicitly wants a code-only replication folder in this repo that is
linked from the post.

You must:

1. Populate `explorations/spencer-underdog-betting/replication/` with only:
   - code
   - dependency declarations
   - manifests
   - download instructions
   - build instructions
2. Include the code that pulls the public data.
3. Avoid committing proprietary or non-redistributable raw data unless the
   license clearly permits it.
4. Ensure the blog draft includes an explicit link to the replication folder.
5. If a GitHub remote is available, include a repository URL version of the
   link in `blog_post_for_site.md`; otherwise use a repo-relative link in the
   draft and note the final publishing substitution.

## Mandatory specialist workflow

This repository's workflow is strongest when specialist review is used
explicitly. For this project, use **all ten repo agents** plus a separate
adversarial reviewer.

### Required repo agents and their explicit duties

1. `r-reviewer`
   - Even if the main pipeline is in Python, create at least one meaningful R
     robustness or meta-analysis script so `r-reviewer` has real work to audit.
   - Have it review statistical choices, reproducibility, and code quality.

2. `domain-reviewer`
   - Review betting-market logic, sports-specific assumptions, and whether the
     substantive conclusions outrun the evidence.

3. `proofreader`
   - Review the blog draft and methods memo for writing quality, clarity,
     overstatement, and awkward exposition.

4. `verifier`
   - Run a final package-level verification pass checking that outputs exist,
     figures and tables match text, and all headline claims are artifact-backed.

5. `slide-auditor`
   - Review a short Beamer research brief summarizing the project for layout,
     density, and technical slide quality.

6. `pedagogy-reviewer`
   - Review the same research brief for narrative flow, explanation order, and
     intelligibility to an informed but non-specialist audience.

7. `tikz-reviewer`
   - Review at least one custom TikZ or diagrammatic figure in the Beamer brief
     if you create one for the strategy workflow, data pipeline, or market
     updating mechanism.
   - If you do not use TikZ, create a small but meaningful TikZ diagram so this
     review is real rather than nominal.

8. `beamer-translator`
   - Translate the Beamer research brief into Quarto / RevealJS form so the
     web-facing slide version exists as a paired artifact.

9. `quarto-critic`
   - Critique the Quarto brief against the Beamer source and enforce parity.

10. `quarto-fixer`
   - Fix any material parity or layout findings from `quarto-critic`, then
     rerun the critic until approved or clearly blocked.

### Explicit delegation rules

1. After the first serious implementation pass, launch the relevant agents
   explicitly rather than relying on self-review.
2. Run independent specialists in parallel when possible.
3. Save each specialist's findings into `quality_reports/`.
4. Fix material findings before declaring the task complete.
5. In the final summary, say exactly which agents were used, what they found,
   and what remains unresolved.

## Mandatory adversarial reviewer

In addition to the ten repo agents, spawn a fresh-context adversarial reviewer
whose job is to attack the project as if they were a skeptical econometrician
and sports-betting columnist combined.

That reviewer should look for:

- data leakage or bad source provenance
- selection bias in available odds
- p-hacking through many window definitions
- overclaiming from noisy ROI
- confusion between mispricing and payout asymmetry
- poor communication of uncertainty
- blog rhetoric that sounds more certain than the estimates justify

Run at least two adversarial rounds if the first round finds material issues.
Save those reports to:

- `quality_reports/adversarial_spencer-underdog-betting_round1.md`
- `quality_reports/adversarial_spencer-underdog-betting_round2.md`

## Writing standards for the final post

The final blog post should be:

- analytically serious
- readable to an intelligent general audience
- explicit about methods and uncertainty
- visually clean
- not afraid to conclude "probably no edge" if that is where the evidence lands

Structure the post roughly as:

1. Hook: Spencer's theory and why it is plausible
2. Data: what you collected and what the coverage limits are
3. Strategy definitions: what exactly you tested
4. Main results: figures and tables first
5. Modeling and interpretation: why the pattern might or might not be real
6. Robustness and failure modes
7. Simulation extension, if used
8. Bottom line: should anyone actually believe in this edge?
9. Replication link and what is inside it

## Verification requirements

Before stopping, you must verify as much as possible:

- run the main data-pull and analysis pipeline end to end
- confirm expected outputs exist
- confirm the replication scripts can rebuild artifacts from public data or from
  clearly documented manual-download steps
- verify the Beamer brief compiles if created
- render the Quarto brief if created
- re-read the blog post against the tables and figures

If anything cannot be verified, say so explicitly and explain why.

## Completion standard

Before declaring the task done, be explicit about:

- what changed
- what data sources were used
- what was verified
- which specialist agents and adversarial reviews were used
- what the current quality score is
- whether the evidence supports, weakly supports, or rejects Spencer's theory
- what limitations remain

Do not end with a vague "analysis complete." End with a concrete, durable,
artifact-backed summary.
