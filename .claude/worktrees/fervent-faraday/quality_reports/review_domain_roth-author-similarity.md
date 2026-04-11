# Domain Review: roth author similarity

- **Date:** 2026-04-08
- **Reviewer role:** domain-reviewer
- **Status:** findings addressed

## Primary findings

1. The blog draft initially read too much like a general answer about “modern
   authors” rather than a claim bounded to the actual *New Yorker*-based corpus.
2. The common-wisdom section named canonical Roth comparators that were not
   directly tested in the legal comparison corpus, which risked implying a
   broader benchmark than the analysis supports.
3. The Goodreads section looked more complete than it really was, because the
   draft paired a pending-verification note with a recommendation list that
   could be mistaken for verified personalization.
4. The results memo described Don DeLillo as more weight-sensitive than the
   actual stability flag in `author_level_scores.csv` suggested.

## Fixes applied

- Reframed the headline, standfirst, opening, and conclusion to keep the
  corpus boundary explicit.
- Recast the common-wisdom section as background contrast rather than a tested
  benchmark for Bellow, Updike, Franzen, or Malamud.
- Split the Goodreads material into a clearly pending overlap section and a
  separate provisional read-next shortlist.
- Updated the results memo so DeLillo is described as ranking relatively
  stably but with an uneven dimensional profile.

## Residual risk

The package is now honest about its corpus boundary, but the core limitation
remains structural: this is a serious corpus-bounded pilot, not a final answer
about all of modern fiction.

