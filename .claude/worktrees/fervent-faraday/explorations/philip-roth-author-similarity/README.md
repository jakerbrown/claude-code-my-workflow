# Exploration: Philip Roth author similarity

- **Date started:** 2026-04-08
- **Status:** active
- **Target quality floor:** 80

## Goal

Run a serious, reproducible empirical project that asks which modern authors
write most like Philip Roth, then turn the findings into a blog-ready draft.

## Scope choices

- Primary object of study: fiction in English.
- Preferred unit of analysis: both book-level and author-level similarity.
- Planned text source hierarchy:
  - legally accessible local full texts first
  - authorized public excerpts and previews second
  - criticism only for secondary validation, not core ranking
- Candidate pool design: broad modern literary-fiction longlist with explicit
  inclusion and exclusion rules, plus negative controls.

## Current feasibility posture

- Goodreads looks feasible because a fresh local export exists at
  `/Users/jacobbrown/Downloads/goodreads_library_export.csv`, though sandbox
  access may require approval.
- Corpus access is the key risk. Early local searches found no Philip Roth full
  texts and only a very small Calibre library.
- The project therefore begins with a formal feasibility audit before any deep
  modeling claims.

## Deliverable intent

- Build a self-contained exploration package with reproducible scripts, output
  tables, methods notes, results notes, and a blog draft.
- If the corpus proves too weak for a fully persuasive answer, produce the
  strongest defensible partial analysis plus a clear acquisition memo rather
  than bluffing.

## Package contents

- `src/run_pipeline.py`: downloads the legally accessible source pages, parses
  article text, computes the feature sets, and writes the main outputs.
- `src/make_figures.py`: turns the output tables into the blog-ready figures.
- `output/`: reproducible derived artifacts used in the write-up.
- `CODEX_PROMPT.md`: original project prompt.

## Public-safe replication notes

- The committed package includes executable code and derived outputs.
- It does **not** include the cached source HTML or the raw Goodreads export.
- Re-running `src/run_pipeline.py` will rebuild the corpus cache from the
  public URLs listed in the script.

## How to run

From the repo root:

```bash
python3 explorations/philip-roth-author-similarity/src/run_pipeline.py
python3 explorations/philip-roth-author-similarity/src/make_figures.py
```

The scripts expect a Python environment with:

- `beautifulsoup4`
- `lxml`
- `matplotlib`
- `numpy`
- `pandas`
- `scikit-learn`
- `seaborn`

## Planned promotion path

If the workflow stabilizes and the corpus is strong enough, promote the best
pieces into reusable analysis code, a publishable essay, and possibly a
reusable computational-literature skill.
