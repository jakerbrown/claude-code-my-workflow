# Adversarial Review Round 1: roth blog package

- **Date:** 2026-04-08
- **Reviewer role:** adversarial critic
- **Status:** findings addressed in round-1 fix pass

## Main critique

1. The package overstated what the corpus could support by sounding like a
   general answer about “modern authors” rather than a bounded answer about the
   authors present in the legal *New Yorker* corpus.
2. Several feature families were proxy-based, but the prose described them too
   directly, especially around “character ecology,” “narrative voice,” and
   “emotional / moral texture.”
3. The normalized 0-100 family scores risked looking more precise than the raw
   separations justified.
4. The robustness language was stronger than the implemented robustness checks.
5. The Goodreads section still read as quasi-personalized despite blocked
   verification.

## Fixes applied after round 1

- Tightened the headline and lede to make the corpus boundary explicit.
- Renamed proxy-heavy dimensions more honestly:
  - `social-world vocabulary proxy`
  - `confessional / argumentative marker similarity`
  - `emotional / moral vocabulary proxy`
- Added a note that the normalized 0-100 scores are best treated as ranking
  aids rather than literal distance measures.
- Softened robustness language in the results memo and blog draft.
- Split the Goodreads material into a pending section and a provisional
  recommendation section.

