# Methods Memo

## Research question

This project asks which modern authors write most like Philip Roth, but it does
so under an explicit access constraint: only legally accessible prose that was
actually available from the agent runtime could be analyzed. The result is an
honest, reproducible pilot rather than a bluffing full-corpus study.

## Scope choices

- **What counts as modern:** primarily post-1960 literary fiction.
- **Genre:** fiction only.
- **Unit of analysis:** magazine fiction pieces and novel excerpts, not full
  books, because the legally accessible corpus came from public archive pages.
- **Language:** English only in this pass.
- **Geography:** effectively Anglophone and U.S.-magazine mediated.
- **Level of comparison:** both document-level and author-level, aggregated from
  multiple texts per author where possible.

## Feasibility audit

### What was locally available

- The exploration scaffold, repo workflow materials, and standard Python/R
  tooling were locally available.
- A fresh Goodreads export existed at
  `/Users/jacobbrown/Downloads/goodreads_library_export.csv`.
- Apple Books metadata in
  `/Users/jacobbrown/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books/Books.plist`
  revealed a substantially richer fiction library than the first filesystem
  search suggested.

### What remained blocked

- The Goodreads CSV could not be read from the agent runtime because of
  OS-level permissions.
- The underlying Apple Books EPUB files were visible in metadata but not
  readable from the agent runtime.

### What made the project feasible anyway

- Public archive pages from *The New Yorker* were fetchable with `curl -L`.
- Those pages expose a machine-readable `articleBody` field inside
  `application/ld+json`, which made legal and reproducible text extraction
  possible.

## Corpus design

- **Primary source:** *The New Yorker* archive pages fetched directly by URL.
- **Included corpus:** 46 usable texts, 328,824 words, 11 authors.
- **Anchor author:** Philip Roth with 8 texts.
- **Candidate authors:** Don DeLillo, Jhumpa Lahiri, Zadie Smith, Mary
  Gaitskill, Jennifer Egan, Junot Diaz, George Saunders, Lorrie Moore,
  Aleksandar Hemon, and Tessa Hadley.
- **Inclusion rule for candidates:** at least 3 accessible fiction pieces or
  excerpts with extracted length at or above 1,500 words.
- **Exclusion rule:** shorter fragments were kept in the manifest but dropped
  from scoring.

## Candidate-pool logic

The candidate pool was not built by starting from “who is like Roth?” Instead,
it used a constrained but defensible universe:

1. modern literary-fiction authors with accessible *New Yorker* contributor
   archives and multiple fiction texts,
2. enough usable extracted text to support multi-text author centroids,
3. a mix of plausible Roth neighbors and stylistic contrasts.

This pool is still biased toward authors who publish in elite Anglophone
magazine culture. That bias is real and is part of the interpretation.

## Measurement families

### 1. Topic / semantic similarity

- Passage segmentation into roughly 350-word chunks.
- TF-IDF word-and-bigram vectors on passage text.
- Truncated SVD to build lower-dimensional latent semantic vectors.
- Author-level topic score from cosine similarity between each author’s passage
  centroid and Roth’s.

This is not a transformer embedding. It is more modest, but fully reproducible
in the local environment and still useful for detecting shared subject matter
and semantic fields.

### 2. Stylometric similarity

Features included:

- sentence-length and paragraph-length distributions
- lexical diversity and moving-window type-token richness
- punctuation density
- quote density as a proxy for dialogue share
- average word length
- function-word profile

Author-level style similarity is cosine similarity on those aggregated feature
vectors.

### 3. Social-world vocabulary proxy

This layer used interpretable lexicon proxies rather than full named-entity
networks, because a serious NER pipeline was not supportable with the installed
tooling and access constraints. Features included rates of:

- family and kinship terms
- sex and body terms
- politics vocabulary
- academia vocabulary
- urban and suburban setting markers
- religion and ethnicity markers
- illness and therapy markers
- work and money terms
- title-case density as a rough person / named-reference proxy

### 4. Confessional / argumentative marker similarity

This layer tried to operationalize “Roth-like narrative posture” with proxies
rather than a direct model of voice. It tracks:

- first-person versus third-person pressure
- interiority verbs
- hedging
- self-justification markers
- argumentative / essayistic connectors
- question density
- dash and parenthesis use

### 5. Emotional / moral vocabulary proxy

This layer used interpretable lexicons for:

- moral judgment
- anger / resentment
- affection / attachment
- mortality
- overlap with illness and body language

## Composite score

The composite score gives equal weight to:

- topic
- style
- social world
- narrative voice
- emotional / moral texture

Each family is first normalized to a 0-100 range across non-Roth candidates.
The overall score is then the weighted average.

That means the composite is best treated as an **ordinal ranking device** rather
than a literal distance metric. In a small sample, min-max scaling can make
modest raw differences look visually larger than they really are.

## Robustness checks

Implemented:

- alternative weighting schemes:
  - equal weights
  - topic-heavy
  - style-heavy
  - voice-heavy
  - no-topic
  - no-style
- rank dispersion across those alternative composites
- minimum-length filtering of texts

Partially implemented / discussed rather than fully solved:

- stability across different Roth works is partly addressed by using eight Roth
  texts spanning 1959-1998, but there is not yet a full leave-one-Roth-text-out
  report on disk.
- candidate-pool sensitivity is discussed, but not yet re-estimated for an
  entirely different publication universe.

## What this design can and cannot support

### Supportable claims

- Which authors in this legal *New Yorker* corpus are closest to Roth overall.
- Which authors resemble Roth along particular dimensions.
- Which matches look stable versus weight-sensitive inside this corpus.

### Claims this design does not justify

- Definitive “most like Roth in all of modern fiction” claims.
- Confident statements about authors absent from the accessible corpus, such as
  Bellow, Updike, Malamud, or Franzen.
- Verified Goodreads personalization from the blocked local export.
- Fine-grained entity-network claims that would need stronger NLP tooling or
  full-book corpora.

## Reproducibility

- Main script:
  `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/philip-roth-author-similarity/src/run_pipeline.py`
- Main outputs:
  `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/philip-roth-author-similarity/output/corpus_manifest.csv`
  `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/philip-roth-author-similarity/output/book_level_features.csv`
  `/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/philip-roth-author-similarity/output/author_level_scores.csv`
