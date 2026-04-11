# Results Memo

## Bottom line

Within this legal, excerpt-based *New Yorker* corpus, the authors who stay
closest to Philip Roth across multiple measurement families are:

1. **Junot Diaz**
2. **Mary Gaitskill**
3. **Aleksandar Hemon**

Those are the most persistent overall matches in the current run's weighting
checks. A second tier is
led by **Tessa Hadley** and **Don DeLillo**. DeLillo remains high across the
alternative weighting schemes used here, but his dimensional profile is uneven,
so “stable ranking” should not be confused with “uniform likeness.”

## Overall leaderboard

| Rank | Author | Overall score | Median alt-rank | Rank SD | Stability read |
|---|---|---:|---:|---:|---|
| 1 | Junot Diaz | 81.96 | 1.0 | 0.37 | strongest in current checks |
| 2 | Mary Gaitskill | 78.64 | 2.0 | 0.58 | strongest in current checks |
| 3 | Aleksandar Hemon | 72.75 | 3.0 | 0.94 | strong in current checks |
| 4 | Tessa Hadley | 66.99 | 5.5 | 1.26 | good but weight-sensitive |
| 5 | Don DeLillo | 64.80 | 4.5 | 1.63 | strong but uneven |
| 6 | George Saunders | 64.63 | 6.0 | 0.82 | medium |
| 7 | Lorrie Moore | 62.02 | 7.5 | 2.36 | fragile |
| 8 | Jhumpa Lahiri | 60.55 | 7.5 | 1.15 | dimension-specific |
| 9 | Jennifer Egan | 50.01 | 9.0 | 1.11 | dimension-specific |
| 10 | Zadie Smith | 34.16 | 10.0 | 0.00 | weak in this corpus |

## Dimension leaders

### Topic / semantic

- Don DeLillo
- Lorrie Moore
- Mary Gaitskill
- Junot Diaz

Interpretation:
DeLillo is the strongest topical neighbor in this corpus, especially on urban
American life, institutions, public events, and intellectually charged social
settings.

### Style

- Jhumpa Lahiri
- George Saunders
- Jennifer Egan
- Aleksandar Hemon

Interpretation:
Lahiri looks unexpectedly Roth-adjacent in sentence management and function-word
profile, even though her social world diverges sharply.

### Social-world vocabulary proxy

- Junot Diaz
- Aleksandar Hemon
- Lorrie Moore
- Jennifer Egan
- Tessa Hadley

Interpretation:
Diaz and Hemon rise here because the proxy measures keep picking up family
strain, ethnic identity, immigration or displacement, and intimate social
negotiation under institutional pressure.

### Confessional / argumentative marker similarity

- Mary Gaitskill
- Don DeLillo
- Jhumpa Lahiri
- Aleksandar Hemon
- Junot Diaz

Interpretation:
Gaitskill is the closest match on the proxy bundle for confessional posture,
self-explanation, argumentative turns, and interior pressure.

### Emotional / moral vocabulary proxy

- Junot Diaz
- Aleksandar Hemon
- Tessa Hadley
- Lorrie Moore
- Mary Gaitskill

Interpretation:
Diaz and Hemon stay near Roth when the analysis looks for shame, resentment,
attachment, mortality, and moral pressure rather than just sentence mechanics.

## What looks strongest in the current checks

- **Junot Diaz** is the strongest all-around analogue in this corpus.
  He is not just a one-dimension match. He stays near Roth on topic,
  social-world vocabulary, confessional markers, and emotional-moral
  vocabulary, and his rank barely moves under the weighting schemes
  implemented here. That is stronger than a one-off result, though not the same
  thing as a full robustness proof.
- **Mary Gaitskill** is the strongest voice-adjacent match.
  She remains especially Roth-adjacent once confession, self-justification, and
  intimate moral friction matter.
- **Aleksandar Hemon** is the least clichéd strong result.
  He is not the obvious conversational comp for Roth, but the model repeatedly
  pulls him near Roth on social-world vocabulary, confessional markers, and
  emotional-moral density.

## What looks dimension-specific rather than fully Roth-like

- **Don DeLillo**:
  very close in topic and narrative stance, but the current emotional-moral
  layer places him far from Roth. This is the clearest “close in one dimension,
  distant in another” case.
- **Jhumpa Lahiri**:
  close in style and voice, far in social world. She looks like a structural
  or tonal cousin more than a full ecological match.
- **George Saunders**:
  close in style, but not especially Roth-like in voice or social world.
- **Lorrie Moore**:
  semantically and socially close, but style similarity is weak and her current
  weighting-check profile is fragile.

## Negative-control and sanity-check read

George Saunders was included partly as a style-rich but not obviously
Roth-adjacent contrast case. He does rank mid-table rather than at the top,
which is reassuring. The model is not simply rewarding every sharp, ironic
American prose stylist.

## Personalized Goodreads section

Status: **verified from local export**

After the Goodreads export was copied into the exploration output folder, I was
able to match the ranked authors against the export directly.

### Top-ranked Roth-adjacent authors already read

- **Junot Diaz**:
  3 matched books, including *Drown*, *This Is How You Lose Her*, and
  *The Brief Wondrous Life of Oscar Wao*
- **Mary Gaitskill**:
  6 matched books, including *Veronica*, *The Mare*, and *Bad Behavior*
- **Don DeLillo**:
  3 matched books, including *White Noise* and *The Silence*

### Top-ranked authors not found in the export

- **Aleksandar Hemon**
- **Tessa Hadley**

Those are the clearest high-similarity authors who appear unread or at least
unrecorded in the current Goodreads export.

### Other ranked overlap notes

- **George Saunders** appears in the export with 3 read books.
- **Jennifer Egan** appears in the export with 3 read books.
- **Zadie Smith** appears with one completed read (*White Teeth*) and one
  did-not-finish (*On Beauty*).

## Comparison with common wisdom

The standard critical conversation around Roth often points toward:

- Saul Bellow
- John Updike
- Don DeLillo
- Jonathan Franzen
- Bernard Malamud

This project cannot directly adjudicate Bellow, Updike, Franzen, or Malamud in
the current run because those authors were not present in the legal comparison
corpus. So this is a **secondary context note, not a head-to-head benchmark**
for those writers. What the current corpus **does** confirm is one conventional
instinct: **Don DeLillo** really is Roth-adjacent on topic and confessional
markers. What the empirical run adds is that DeLillo is not the best all-around
match once the analysis also cares about family and sexual vocabulary,
confession, and emotional-moral pressure.

The strongest under-discussed findings are:

- Junot Diaz
- Mary Gaitskill
- Aleksandar Hemon

Those names feel less canonical in “Roth-like authors” chatter, but they are
the ones that remain near Roth across more than one family of measures.

## Main limitations

- The corpus is restricted to accessible *New Yorker* fiction and excerpts.
- This is not a full-book or full-career stylometric study.
- The candidate pool is publication-biased toward elite Anglophone magazine
  culture.
- Goodreads verification is now complete from the local export copied into the
  exploration output folder.
- The topic layer uses TF-IDF plus SVD rather than transformer embeddings.
- The normalized 0-100 family scores are best read as ranking aids. Their exact
  spacing should not be overinterpreted as literal distance.
- The current “stability” read comes from weighting checks and length filtering,
  not from a full leave-one-Roth-text-out or candidate-pool perturbation suite.

## Quality read

Current package quality: **80**

Why not higher:

- The strongest remaining gap is not personalization but robustness depth: the
  Goodreads overlap is now verified, while the robustness appendix is still
  lighter than ideal.
- The common-wisdom comparison is necessarily partial.
- A full leave-one-Roth-text-out robustness appendix has not yet been written.
