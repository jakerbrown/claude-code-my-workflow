# Master Prompt: Empirical Philip Roth Similarity Project

Paste or adapt the prompt below in a fresh Codex task when you want Codex to
run the full research project.

---

You are working inside `/Users/jacobbrown/Documents/GitHub/codex-my-workflow`.
This is an exploratory but high-standards research task. Your objective is to
conduct a serious, reproducible empirical project and draft a blog post that
answers the question:

**Which modern authors write the most like Philip Roth?**

The user does **not** want a conventional "critics say X" essay. The core of
the post must come from original empirical analysis using modern text-analysis
methods. Reviews, listicles, and common wisdom can be used only as a secondary
validation layer or contrast case, not as the main engine of the conclusion.

## Working style and repo rules

Follow this repository's workflow rules strictly:

1. Read the active `AGENTS.md` guidance, `MEMORY.md`, `KNOWLEDGE_BASE.md`, and
   any relevant nested `AGENTS.md` before doing substantial work.
2. Because this is a non-trivial task, create or refresh:
   - `quality_reports/plans/YYYY-MM-DD_roth-author-similarity.md`
   - `quality_reports/session_logs/YYYY-MM-DD_roth-author-similarity.md`
3. Work under a self-contained exploration folder:
   - `explorations/philip-roth-author-similarity/`
4. Use the contractor loop:
   - implement -> verify -> review -> fix -> re-verify -> score -> summarize
5. Leave a concise breadcrumb in:
   - `quality_reports/codex_activity/YYYY-MM-DD_roth-author-similarity.md`
6. Treat the minimum acceptable quality level for the final exploratory package
   as **80**, even though `explorations/` normally permits 60.
7. Use explicit subagents. Do not assume specialist review happens
   automatically in Codex.

## Top-level objective

Produce a blog-ready draft that identifies the modern authors whose writing is
most similar to Philip Roth, using a transparent multi-method empirical design.
The final piece should be compelling to an intelligent general audience but
credible to a methods-oriented reader.

The analysis must examine similarity along several dimensions, not just one:

- writing topics and thematic preoccupations
- prose style and stylometry
- character types and relationship structures
- narrative stance and point of view
- dialogue, interiority, and confession/self-justification
- social world and institutional settings
- any other measurable dimensions that prove interesting and defensible

You should end with:

- a ranked or tiered list of the best Philip Roth analogues
- a discussion of *why* they resemble Roth and along which dimensions
- a personalized section on which of those Roth-adjacent authors the user has
  already read
- a short comparison between your results and the usual "common wisdom"

## Non-negotiable standards

1. Do not fake access to texts, private accounts, or data.
2. Do not infer results from reviews alone.
3. Do not present similarity as one scalar unless you also show the component
   dimensions underneath it.
4. Do not cherry-pick only a few authors because they are famous Roth
   comparisons. Build a defensible candidate pool.
5. Do not rely on one method. Use several complementary methods and compare
   them.
6. Do not hide uncertainty. Show where results are stable versus fragile.
7. Do not use copyrighted text in ways that require unauthorized scraping or
   redistribution. Be explicit about what corpus you are legally able to use.
8. Do not stop after implementation plus light verification. This prompt
   expects specialist review and at least one adversarial review loop.

## Research questions

Answer the following:

1. Which modern authors are most similar to Philip Roth overall?
2. Which authors are closest specifically in:
   - topic
   - style
   - character ecology
   - narrative voice
   - emotional and moral texture
3. Are there authors who match Roth on one dimension but diverge strongly on
   others?
4. Which candidate authors remain near Roth across multiple methods and
   robustness checks?
5. Which of those authors has the user already read, based on their Goodreads
   history?
6. How do the empirical findings compare with the standard critical consensus?

## Scope decisions you must make early

Make and justify explicit scope choices on:

- what counts as "modern"
- whether the analysis is limited to fiction
- whether you are limiting to novels or allowing short stories
- whether translated authors are included
- whether the candidate pool is global or primarily Anglophone
- whether you are measuring author-level similarity, book-level similarity, or
  both

Do not bury these choices. Put them in the plan and methods memo.

## Deliverables

Create as many of these as feasible, with concise but real content:

- `explorations/philip-roth-author-similarity/README.md`
- `explorations/philip-roth-author-similarity/SESSION_LOG.md`
- `explorations/philip-roth-author-similarity/data/`
- `explorations/philip-roth-author-similarity/output/`
- `explorations/philip-roth-author-similarity/src/`
- `explorations/philip-roth-author-similarity/output/corpus_manifest.csv`
- `explorations/philip-roth-author-similarity/output/candidate_authors.csv`
- `explorations/philip-roth-author-similarity/output/book_level_features.csv`
- `explorations/philip-roth-author-similarity/output/author_level_scores.csv`
- `explorations/philip-roth-author-similarity/output/goodreads_overlap.csv`
- `explorations/philip-roth-author-similarity/output/methods_memo.md`
- `explorations/philip-roth-author-similarity/output/results_memo.md`
- `explorations/philip-roth-author-similarity/output/blog_post_draft.md`
- `explorations/philip-roth-author-similarity/output/bibliography.md`
- `quality_reports/review_r_roth-author-similarity.md`
- `quality_reports/review_domain_roth-author-similarity.md`
- `quality_reports/proofread_roth-blog-post.md`
- `quality_reports/verifier_roth-author-similarity.md`
- `quality_reports/adversarial_roth-blog_round1.md`
- `quality_reports/adversarial_roth-blog_round2.md`

If some deliverables are not feasible, explain exactly why in the results memo.

## Mandatory specialist workflow

This repository's workflow is strongest when specialist review is used
explicitly. For this project, you should treat the following as the default,
not optional polish.

### Required specialist agents

Use these repo agents explicitly when their scope exists:

- `r-reviewer`
  - Review any substantial R analysis code, feature-engineering code, or
    reproducibility logic you create.
- `domain-reviewer`
  - Review the literary interpretation, candidate-pool logic, substantive
    claims about Roth and comparison authors, and whether the prose conclusions
    outrun the evidence.
- `proofreader`
  - Review the final blog draft for writing quality, clarity, overstatement,
    awkward phrasing, and internal inconsistency.
- `verifier`
  - Run a final package-level verification pass checking that outputs exist,
    tables match text, rankings are consistent across files, and all "verified"
    claims are actually supported by the artifacts.

### Delegation rules

1. After the first serious implementation pass, explicitly launch the relevant
   specialist agents rather than doing only a self-review.
2. Run independent specialists in parallel when possible.
3. Save each specialist's findings into `quality_reports/` in a durable report.
4. Fix material findings before declaring the task complete.
5. In the final summary, say exactly which specialist agents were used, what
   they found, and what remains unresolved.

### Strongly encouraged extra delegation

If the task becomes large enough, also use Codex subagents beyond the repo
specialists. Good examples:

- a read-only methods skeptic focused on identification, robustness, and
  feature validity
- a corpus-acquisition worker focused on legal data sourcing and cleaning
- a blog-structure editor focused on narrative flow and audience readability

If you use generic subagents, give them narrow scopes and keep their outputs on
disk.

## Feasibility gate: do this before deep analysis

Before building the pipeline, run a feasibility audit and write down the result.
You must determine:

1. **Corpus access**
   - What full texts, excerpts, previews, essays, interviews, or other text
     sources are legally available for Philip Roth and the candidate authors?
   - Are there local text files, ebooks, PDFs, or notes already available in
     the workspace or on accessible mounted volumes?
   - Are the texts sufficient for serious empirical comparison?

2. **Goodreads access**
   - Can you identify the user's Goodreads profile publicly?
   - If not, is there a Goodreads export, shelf CSV, or scraped reading-history
     file already available locally?
   - If Goodreads access is blocked, continue with the rest of the project and
     mark the personalized overlap section as pending specific user input.

3. **Method feasibility**
   - Given the accessible corpus, which methods are truly defensible?
   - Which attractive methods are not actually supportable with the available
     text?

If the corpus is too weak for a serious answer, do **not** bluff. Instead:

- produce a strong acquisition memo
- specify the minimum additional inputs needed
- complete whatever partial analysis is still defensible

## Candidate-pool design

Construct a candidate pool that is broader than obvious Roth comparators.

The pool should be defensible, not arbitrary. For example:

- start from a broad universe of modern literary fiction authors
- use awards, syllabi, major-review coverage, publisher catalogs, literary
  histories, or curated lists to build the longlist
- include some obvious comparators and some plausible but less clichéd ones
- include a few negative controls that should not rank highly

Avoid building the pool by asking "who is like Roth?" and then reusing that as
the answer. The candidate universe should precede the similarity ranking.

Document:

- inclusion rules
- exclusion rules
- source of the longlist
- final sample size
- any sources of bias

## Text units and corpus design

Think carefully about unit of analysis. Consider using both:

- **book-level units** for rankings and robustness checks
- **passage-level units** for embeddings, style features, and internal variance

Preferred design:

- multiple Roth works spanning his career if possible
- multiple works per comparison author if possible
- segmentation into passages of a consistent approximate length
- removal of front matter, blurbs, copyright pages, and obvious non-authorial
  material

Be careful to avoid leakage from:

- reviews of Roth
- introductions written by other people
- academic criticism
- jacket copy
- Wikipedia summaries or metadata being mixed into the text corpus

## Measurement families to implement

Use multiple families of measures. Do not rely on any single technique.

### 1. Topic and semantic similarity

Implement some combination of:

- document or passage embeddings
- nearest-neighbor search between Roth texts and candidate texts
- topic modeling or topic decomposition
- semantic field clustering
- keyphrase extraction

Goal: identify authors who write about similar subject matter, conflicts, and
social worlds.

### 2. Stylometric similarity

Implement a strong stylometric layer using features such as:

- sentence length distribution
- paragraph length distribution
- function-word frequencies
- punctuation patterns
- dialogue share
- lexical diversity
- type-token and moving-window richness measures
- part-of-speech distributions
- readability and syntactic complexity
- first-person versus third-person balance
- tense usage
- rhetorical questions, interruptions, dashes, parentheses, and other
  idiosyncratic habits if measurable

If feasible, also try a supervised or contrastive approach that asks whether
Roth passages are distinguishable from others and which authors confuse the
classifier most often.

### 3. Character and relationship structure

Measure the social and character world, for example with:

- named-entity extraction
- counts and distributions of person references
- kinship terms
- professional and institutional vocabulary
- age and gender markers where measurable
- relationship-network density
- frequency of family, marriage, sex, politics, academia, therapy, illness,
  ethnicity, class, and urban/suburban life markers

This layer should try to capture whether an author writes about a Roth-like
human world, not just Roth-like sentences.

### 4. Narrative stance and voice

Operationalize the extent to which texts feel Roth-like in narrative posture.
Possible measurable proxies:

- first-person confession or self-explanation
- interiority density
- self-justification and self-contradiction markers
- irony or hedging markers
- pronoun patterns
- direct address
- emotionally volatile shifts
- argumentative or essayistic intrusions into the narrative

You may need to invent a reasonable feature set here. If you do, explain and
justify it rather than hiding it.

### 5. Composite similarity

Create a transparent composite metric that combines the measurement families,
but only after showing each family separately.

Requirements:

- normalize within method
- justify weights rather than picking them arbitrarily
- run sensitivity checks under alternative weighting schemes
- show whether the top-ranked authors remain stable

## Cutting-edge methods

Use modern methods where they add real value, not just buzzwords. Candidate
approaches include:

- transformer embeddings at the passage level
- clustering and manifold visualization for books and authors
- zero-shot or weakly supervised feature extraction using language models
- contrastive ranking prompts to label a sample of passages for narrative voice
- topic decomposition using modern embedding-based methods
- network analysis on extracted character co-occurrence
- bootstrap uncertainty estimates

But keep one rule: the methods must remain interpretable enough for a blog post
and credible enough for a methods appendix.

## Validation and robustness

Treat this as a real empirical project, not a toy demo.

At a minimum, implement or discuss:

- stability across different Roth books
- stability across different passage lengths
- stability across candidate-pool definitions
- sensitivity to excluding one dominant feature family
- sensitivity to weighting choices in the composite score
- agreement and disagreement across methods
- negative controls
- sanity checks against obvious false positives
- checks for whether one or two books are driving an author's ranking

If any result is fragile, say so clearly.

## Goodreads integration

The user wants a personalized angle: among the authors who are empirically
similar to Roth, which ones has the user already read?

Known Goodreads profile:

- `https://www.goodreads.com/user/show/30002131-jacob`

Known local Goodreads export:

- `/Users/jacobbrown/Downloads/goodreads_library_export.csv`

The account email is `jacobrobertbrown@gmail.com`, but do not assume that gives
automatic access beyond the public profile.

Use the following hierarchy:

1. Start with the local Goodreads export above as the primary structured source
   for read-status, shelves, ratings, and dates when available.
2. Use the public Goodreads profile above as a secondary source for cross-checks
   or missing fields.
3. If a different Goodreads export, shelf CSV, or local reading-history file
   exists in the workspace and appears newer or richer, you may use it instead,
   but document the choice.
4. If Goodreads is still insufficient for some reason, continue the core
   project and produce a clean
   handoff note specifying the exact file or export you need from the user.

For the personalized section, produce:

- which top-ranked Roth-adjacent authors the user has already read
- which top-ranked authors appear unread or unverified
- optionally, a recommendation shortlist ordered by estimated Roth-similarity
  and whether the user has already read them

## Adversarial review requirement

This task should use an adversarial review loop, even though it is not a Quarto
task.

After you have:

- a methods memo
- a results memo
- a draft blog post
- at least one table or structured ranking output

run an explicit critic/fixer cycle.

### Round structure

Round 1:

1. Spawn or assign a **critic** whose job is to attack the work, not defend it.
2. The critic should look for:
   - overclaiming
   - weak corpus support
   - leakage or contamination
   - pseudo-rigor or decorative methods
   - instability in rankings
   - literary claims not grounded in the actual measurements
   - personalization errors in the Goodreads overlap section
   - places where the blog post becomes recommendation fluff
3. Save the critique to:
   - `quality_reports/adversarial_roth-blog_round1.md`
4. Apply fixes to the analysis, memos, and blog draft.

Round 2:

1. Re-run the critic or an equivalent skeptical reviewer on the revised work.
2. Save the re-audit to:
   - `quality_reports/adversarial_roth-blog_round2.md`
3. If major defects remain, keep iterating until the project reaches the target
   quality threshold or you hit a clearly documented blocker.

### Relationship to repo critic/fixer roles

The repository's named `quarto-critic` and `quarto-fixer` are designed for
Beamer/Quarto parity work, so they are not the natural primary reviewers here.
Do **not** force them onto this task mechanically. Instead, apply the same
adversarial workflow pattern to this literary-analysis package using an
appropriate critic/fixer pairing.

## Comparison to common wisdom

Only after the empirical ranking is complete, compare it to conventional
critical wisdom.

Use reviews, essays, publisher copy, reading lists, Reddit, Goodreads shelves,
or literary journalism only as a **secondary benchmark**. Ask:

- which authors are commonly said to resemble Roth?
- which of those does the empirical analysis confirm?
- which conventional comparisons look weak empirically?
- which empirically strong matches are under-discussed?

Do not let this comparison overwrite the main results.

## Blog post requirements

Write for a smart general audience, but keep the claims evidence-based.

The post should roughly include:

1. A strong opening framing the question.
2. A short explanation of why this is hard and what "similar" can mean.
3. A transparent description of the empirical strategy in plain English.
4. The main findings:
   - overall ranking or tiering
   - dimension-specific leaders
   - surprising cases
5. A personalized Goodreads section.
6. A short section comparing the results with common wisdom.
7. A candid limitations section.
8. A conclusion that distinguishes:
   - "closest overall"
   - "closest in style"
   - "closest in themes"
   - "closest for Jacob to read next"

The tone should be lively and essayistic without becoming hand-wavy.

## Suggested output structure for the final writeup

Use this as a starting structure, then improve it:

- headline options
- standfirst / dek
- main post
- methods appendix
- bibliography / data notes
- figure captions

If possible, also create a few simple but persuasive tables or charts such as:

- overall similarity leaderboard
- radar chart or heatmap by similarity dimension
- nearest-neighbor map of books or authors
- personalized "already read vs not yet read" table

## Preferred workflow sequence

1. Reconnaissance and feasibility audit.
2. Build the candidate pool and corpus manifest.
3. Implement feature extraction and embeddings.
4. Produce method-specific rankings.
5. Build the composite metric and robustness checks.
6. Add the Goodreads overlap layer.
7. Write results memo.
8. Draft the blog post.
9. Review your own work for overclaiming, leakage, and unsupported rhetoric.
10. Revisit and tighten the draft so the empirical claims match the evidence.

## Verification requirements

Before declaring success, verify:

- every output file you claim exists actually exists
- methods memo matches the implemented analysis
- blog-post claims are supported by the results memo
- personalized Goodreads claims are labeled as verified or pending
- all source links and citations are accurate

If you run code, save scripts in `src/` and write enough notes that another
person could reproduce the pipeline with the same inputs.

## Review expectations

This task is substantial enough that specialist review is expected by default.
At minimum, you must:

- run the required repo specialists that match the artifacts you created
- run the adversarial critic/fixer loop above
- do a serious final self-review focused on:

- empirical design quality
- text-data legality and access honesty
- reproducibility
- writing quality
- whether the main blog-post claims outrun the methods

If you skip specialist review, explain why.

## What good completion looks like

A successful run does **not** require perfect data access. It does require:

- intellectual honesty
- strong research design
- real measurable outputs
- a thoughtful blog draft
- durable specialist-review artifacts
- an adversarial re-audit after fixes
- explicit uncertainty and limitations

The best possible version of this project will feel like a serious digital
humanities / computational criticism piece rather than a glorified recommendation
list.

Start by reading the repo guidance, then create the plan and feasibility audit.

---
