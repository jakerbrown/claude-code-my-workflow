#!/usr/bin/env python3
"""Build a legal mini-corpus and estimate Roth-adjacent author similarity.

This pipeline intentionally uses only texts that appear publicly accessible from
The New Yorker archive pages we can fetch with ``curl -L`` in this environment.
Because local Apple Books EPUBs and the Goodreads CSV are blocked by OS-level
permissions from the agent runtime, this script treats those richer sources as
documented-but-unavailable inputs rather than pretending they were analyzed.
"""

from __future__ import annotations

import csv
import html
import json
import math
import re
import statistics
import subprocess
from collections import Counter, defaultdict
from pathlib import Path
from typing import Dict, Iterable, List

import numpy as np
import pandas as pd
from bs4 import BeautifulSoup
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import StandardScaler


ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data"
CACHE_DIR = DATA_DIR / "cache" / "html"
OUTPUT_DIR = ROOT / "output"
MIN_ANALYSIS_WORDS = 1500
MIN_DOCS_PER_CANDIDATE = 3


CORPUS = [
    # Roth anchor corpus
    {"author": "Philip Roth", "title": "The Ghost Writer I", "year": 1979, "url": "https://www.newyorker.com/magazine/1979/06/25/the-ghost-writer"},
    {"author": "Philip Roth", "title": "The Ghost Writer II", "year": 1979, "url": "https://www.newyorker.com/magazine/1979/07/02/the-ghost-writer-2"},
    {"author": "Philip Roth", "title": "Smart Money", "year": 1981, "url": "https://www.newyorker.com/magazine/1981/02/02/smart-money"},
    {"author": "Philip Roth", "title": "The Ultimatum", "year": 1995, "url": "https://www.newyorker.com/magazine/1995/06/26/the-ultimatum"},
    {"author": "Philip Roth", "title": "Drenka's Men", "year": 1995, "url": "https://www.newyorker.com/magazine/1995/07/10/drenkas-men"},
    {"author": "Philip Roth", "title": "Communist", "year": 1998, "url": "https://www.newyorker.com/magazine/1998/08/03/communist"},
    {"author": "Philip Roth", "title": "Novotny's Pain", "year": 1962, "url": "https://www.newyorker.com/magazine/1962/10/27/novotnys-pain"},
    {"author": "Philip Roth", "title": "Defender of the Faith", "year": 1959, "url": "https://www.newyorker.com/magazine/1959/03/14/defender-of-the-faith"},
    # Comparison pool
    {"author": "Don DeLillo", "title": "Baader-Meinhof", "year": 2002, "url": "https://www.newyorker.com/magazine/2002/04/01/baader-meinhof"},
    {"author": "Don DeLillo", "title": "Midnight in Dostoevsky", "year": 2009, "url": "https://www.newyorker.com/magazine/2009/11/30/midnight-in-dostoevsky"},
    {"author": "Don DeLillo", "title": "Sine Cosine Tangent", "year": 2016, "url": "https://www.newyorker.com/magazine/2016/02/22/sine-cosine-tangent"},
    {"author": "Jhumpa Lahiri", "title": "A Temporary Matter", "year": 1998, "url": "https://www.newyorker.com/magazine/1998/04/20/a-temporary-matter"},
    {"author": "Jhumpa Lahiri", "title": "The Third and Final Continent", "year": 1999, "url": "https://www.newyorker.com/magazine/1999/06/21/the-third-and-final-continent"},
    {"author": "Jhumpa Lahiri", "title": "Hell-Heaven", "year": 2004, "url": "https://www.newyorker.com/magazine/2004/05/24/hell-heaven"},
    {"author": "Jhumpa Lahiri", "title": "Brotherly Love", "year": 2013, "url": "https://www.newyorker.com/magazine/2013/06/10/brotherly-love-jhumpa-lahiri"},
    {"author": "Zadie Smith", "title": "Stuart", "year": 1999, "url": "https://www.newyorker.com/magazine/1999/12/27/stuart"},
    {"author": "Zadie Smith", "title": "The Embassy of Cambodia", "year": 2013, "url": "https://www.newyorker.com/magazine/2013/02/11/the-embassy-of-cambodia"},
    {"author": "Zadie Smith", "title": "Meet the President!", "year": 2013, "url": "https://www.newyorker.com/magazine/2013/08/12/meet-the-president"},
    {"author": "Zadie Smith", "title": "Two Men Arrive in a Village", "year": 2016, "url": "https://www.newyorker.com/magazine/2016/06/06/two-men-arrive-in-a-village-by-zadie-smith"},
    {"author": "Mary Gaitskill", "title": "The Nice Restaurant", "year": 1995, "url": "https://www.newyorker.com/magazine/1995/03/20/the-nice-restaurant"},
    {"author": "Mary Gaitskill", "title": "A Dream of Men", "year": 1998, "url": "https://www.newyorker.com/magazine/1998/11/23/a-dream-of-men"},
    {"author": "Mary Gaitskill", "title": "Don't Cry", "year": 2008, "url": "https://www.newyorker.com/magazine/2008/06/09/dont-cry"},
    {"author": "Mary Gaitskill", "title": "The Other Place", "year": 2011, "url": "https://www.newyorker.com/magazine/2011/02/14/the-other-place"},
    {"author": "Jennifer Egan", "title": "Found Objects", "year": 2007, "url": "https://www.newyorker.com/magazine/2007/12/10/found-objects"},
    {"author": "Jennifer Egan", "title": "Safari", "year": 2010, "url": "https://www.newyorker.com/magazine/2010/01/11/safari-3"},
    {"author": "Jennifer Egan", "title": "Ask Me If I Care", "year": 2010, "url": "https://www.newyorker.com/magazine/2010/03/08/ask-me-if-i-care"},
    {"author": "Jennifer Egan", "title": "Black Box", "year": 2012, "url": "https://www.newyorker.com/magazine/2012/06/04/black-box"},
    {"author": "Junot Diaz", "title": "Otravida, Otravez", "year": 1999, "url": "https://www.newyorker.com/magazine/1999/06/21/otravida-otravez"},
    {"author": "Junot Diaz", "title": "Nilda", "year": 1999, "url": "https://www.newyorker.com/magazine/1999/10/04/nilda"},
    {"author": "Junot Diaz", "title": "The Brief Wondrous Life of Oscar Wao", "year": 2000, "url": "https://www.newyorker.com/magazine/2000/12/25/the-brief-wondrous-life-of-oscar-wao"},
    {"author": "Junot Diaz", "title": "The Cheater's Guide to Love", "year": 2012, "url": "https://www.newyorker.com/magazine/2012/07/23/the-cheaters-guide-to-love"},
    {"author": "George Saunders", "title": "Jon", "year": 2003, "url": "https://www.newyorker.com/magazine/2003/01/27/jon"},
    {"author": "George Saunders", "title": "Escape from Spiderhead", "year": 2010, "url": "https://www.newyorker.com/magazine/2010/12/20/escape-from-spiderhead"},
    {"author": "George Saunders", "title": "Tenth of December", "year": 2011, "url": "https://www.newyorker.com/magazine/2011/10/31/tenth-of-december"},
    {"author": "George Saunders", "title": "Ghoul", "year": 2020, "url": "https://www.newyorker.com/magazine/2020/11/09/ghoul"},
    {"author": "Lorrie Moore", "title": "You're Ugly, Too", "year": 1989, "url": "https://www.newyorker.com/magazine/1989/07/03/youe-ugly-too"},
    {"author": "Lorrie Moore", "title": "Debarking", "year": 2003, "url": "https://www.newyorker.com/magazine/2003/12/22/debarking"},
    {"author": "Lorrie Moore", "title": "Canada Dry", "year": 2012, "url": "https://www.newyorker.com/magazine/2012/05/21/canada-dry"},
    {"author": "Lorrie Moore", "title": "Referential", "year": 2012, "url": "https://www.newyorker.com/magazine/2012/05/28/referential"},
    {"author": "Aleksandar Hemon", "title": "Szmura's Room", "year": 2004, "url": "https://www.newyorker.com/magazine/2004/06/14/szmuras-room"},
    {"author": "Aleksandar Hemon", "title": "Love and Obstacles", "year": 2005, "url": "https://www.newyorker.com/magazine/2005/11/28/love-and-obstacles"},
    {"author": "Aleksandar Hemon", "title": "The Conductor", "year": 2005, "url": "https://www.newyorker.com/magazine/2005/02/28/the-conductor"},
    {"author": "Aleksandar Hemon", "title": "The Aquarium", "year": 2011, "url": "https://www.newyorker.com/magazine/2011/06/13/the-aquarium"},
    {"author": "Tessa Hadley", "title": "Dido's Lament", "year": 2016, "url": "https://www.newyorker.com/magazine/2016/08/08/didos-lament-by-tessa-hadley"},
    {"author": "Tessa Hadley", "title": "Funny Little Snake", "year": 2017, "url": "https://www.newyorker.com/magazine/2017/10/16/funny-little-snake"},
    {"author": "Tessa Hadley", "title": "The Other One", "year": 2020, "url": "https://www.newyorker.com/magazine/2020/04/13/the-other-one"},
    {"author": "Tessa Hadley", "title": "Coda", "year": 2021, "url": "https://www.newyorker.com/magazine/2021/08/02/coda"},
]


NEGATIVE_CONTROLS = {"George Saunders", "Ben Marcus", "Karen Russell"}

FUNCTION_WORDS = {
    "a", "about", "after", "all", "also", "am", "an", "and", "any", "are", "as",
    "at", "be", "been", "but", "by", "can", "could", "do", "for", "from", "had",
    "has", "have", "he", "her", "him", "his", "i", "if", "in", "into", "is",
    "it", "its", "just", "me", "more", "my", "no", "not", "of", "on", "one",
    "or", "our", "she", "so", "than", "that", "the", "their", "them", "there",
    "they", "this", "to", "up", "was", "we", "were", "what", "when", "who",
    "with", "would", "you", "your",
}

LEXICONS = {
    "family_terms": {"mother", "father", "mom", "dad", "son", "daughter", "wife", "husband", "marriage", "married", "family", "child", "children", "brother", "sister"},
    "sex_body_terms": {"sex", "sexual", "desire", "body", "breast", "penis", "lover", "bed", "naked", "kiss", "flesh", "porn", "erotic"},
    "politics_terms": {"president", "party", "politics", "government", "state", "war", "election", "committee", "policy", "republic", "democracy", "public"},
    "academia_terms": {"college", "campus", "class", "teacher", "student", "professor", "school", "university", "lecture", "study", "book"},
    "urban_suburban_terms": {"city", "street", "apartment", "suburb", "suburban", "town", "neighborhood", "newark", "york", "manhattan", "house"},
    "religion_ethnicity_terms": {"jew", "jewish", "catholic", "irish", "black", "white", "ethnic", "immigrant", "god", "church", "rabbi"},
    "illness_therapy_terms": {"ill", "doctor", "hospital", "therapy", "therapist", "psychiatrist", "sick", "pain", "dying", "death", "diagnosis"},
    "work_money_terms": {"money", "job", "office", "work", "business", "boss", "salary", "rich", "poor", "bank", "career"},
    "interiority_terms": {"think", "thought", "feel", "felt", "remember", "wonder", "wish", "wanted", "fear", "afraid", "dream", "imagined"},
    "hedge_terms": {"maybe", "perhaps", "seems", "seemed", "almost", "sort", "kind", "probably", "apparently", "possibly"},
    "self_justify_terms": {"because", "actually", "really", "honestly", "after all", "of course", "i mean", "in fact", "anyway"},
    "argument_terms": {"should", "ought", "must", "therefore", "however", "though", "although", "yet", "instead", "rather"},
    "moral_terms": {"wrong", "right", "guilty", "innocent", "ashamed", "shame", "duty", "sin", "moral", "honor", "dishonor"},
    "anger_terms": {"angry", "anger", "rage", "furious", "hate", "resent", "resentment", "bitter"},
    "affection_terms": {"love", "loved", "tender", "affection", "care", "caring", "beloved"},
    "mortality_terms": {"death", "dead", "dying", "grave", "funeral", "mortality", "corpse", "cemetery"},
}


def slugify(text: str) -> str:
    return re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")


def clean_text(text: str) -> str:
    text = html.unescape(text)
    text = text.replace("\u2019", "'").replace("\u2018", "'")
    text = text.replace("\u201c", '"').replace("\u201d", '"')
    text = text.replace("\u2014", " -- ").replace("\u2013", " - ")
    text = text.replace("\xa0", " ")
    text = re.sub(r"\n{3,}", "\n\n", text)
    text = re.sub(r"[ \t]+", " ", text)
    return text.strip()


def fetch_html(url: str, destination: Path) -> str:
    if not destination.exists():
        subprocess.run(["curl", "-L", url, "-o", str(destination)], check=True)
    return destination.read_text(encoding="utf-8", errors="ignore")


def extract_article_text(html_text: str) -> str:
    soup = BeautifulSoup(html_text, "lxml")
    for script in soup.find_all("script", attrs={"type": "application/ld+json"}):
        raw = script.get_text(strip=True)
        if not raw:
            continue
        try:
            payload = json.loads(raw)
        except json.JSONDecodeError:
            continue
        if isinstance(payload, dict) and "articleBody" in payload:
            return clean_text(payload["articleBody"])
    match = re.search(r'"articleBody":"(.*?)","author"', html_text)
    if match:
        return clean_text(match.group(1).encode("utf-8").decode("unicode_escape"))
    raise ValueError("Could not find articleBody in HTML.")


def tokenize(text: str) -> List[str]:
    return re.findall(r"[A-Za-z']+", text.lower())


def split_sentences(text: str) -> List[str]:
    return [s.strip() for s in re.split(r"(?<=[.!?])\s+", text) if s.strip()]


def split_paragraphs(text: str) -> List[str]:
    return [p.strip() for p in re.split(r"\n{2,}", text) if p.strip()]


def moving_ttr(tokens: List[str], window: int = 100) -> float:
    if len(tokens) < 2:
        return 0.0
    if len(tokens) <= window:
        return len(set(tokens)) / len(tokens)
    values = []
    for i in range(0, len(tokens) - window + 1, max(1, window // 2)):
        chunk = tokens[i : i + window]
        values.append(len(set(chunk)) / len(chunk))
    return float(np.mean(values))


def lexicon_rate(tokens: List[str], vocab: Iterable[str]) -> float:
    vocab = set(vocab)
    if not tokens:
        return 0.0
    count = sum(1 for tok in tokens if tok in vocab)
    return 1000.0 * count / len(tokens)


def phrase_rate(text: str, phrases: Iterable[str], token_count: int) -> float:
    if token_count == 0:
        return 0.0
    text_l = text.lower()
    count = sum(text_l.count(phrase) for phrase in phrases)
    return 1000.0 * count / token_count


def segment_text(text: str, words_per_segment: int = 350, min_words: int = 175) -> List[str]:
    words = text.split()
    segments = []
    for start in range(0, len(words), words_per_segment):
        chunk = words[start : start + words_per_segment]
        if len(chunk) >= min_words:
            segments.append(" ".join(chunk))
    return segments


def extract_features(text: str) -> Dict[str, float]:
    tokens = tokenize(text)
    sentences = split_sentences(text)
    paragraphs = split_paragraphs(text)
    token_count = len(tokens)
    sentence_lengths = [len(tokenize(s)) for s in sentences] or [0]
    paragraph_lengths = [len(tokenize(p)) for p in paragraphs] or [0]
    char_count = max(len(text), 1)
    quote_chars = text.count('"')
    titlecase_words = re.findall(r"\b[A-Z][a-z]+\b", text)

    feats = {
        "word_count": token_count,
        "sentence_count": len(sentences),
        "paragraph_count": len(paragraphs),
        "avg_sentence_len": float(np.mean(sentence_lengths)),
        "sd_sentence_len": float(np.std(sentence_lengths)),
        "avg_paragraph_len": float(np.mean(paragraph_lengths)),
        "sd_paragraph_len": float(np.std(paragraph_lengths)),
        "avg_word_len": float(np.mean([len(t) for t in tokens])) if tokens else 0.0,
        "type_token_ratio": len(set(tokens)) / token_count if token_count else 0.0,
        "moving_ttr": moving_ttr(tokens),
        "dialogue_quote_density": 1000.0 * quote_chars / char_count,
        "comma_density": 1000.0 * text.count(",") / char_count,
        "semicolon_density": 1000.0 * text.count(";") / char_count,
        "colon_density": 1000.0 * text.count(":") / char_count,
        "dash_density": 1000.0 * (text.count("--") + text.count("-")) / char_count,
        "paren_density": 1000.0 * (text.count("(") + text.count(")")) / char_count,
        "question_density": 1000.0 * text.count("?") / char_count,
        "exclamation_density": 1000.0 * text.count("!") / char_count,
        "titlecase_density": 1000.0 * len(titlecase_words) / max(token_count, 1),
        "first_person_density": lexicon_rate(tokens, {"i", "me", "my", "mine", "myself", "we", "us", "our", "ours"}),
        "third_person_density": lexicon_rate(tokens, {"he", "him", "his", "she", "her", "hers", "they", "them", "their", "theirs"}),
        "present_tense_density": lexicon_rate(tokens, {"is", "are", "am", "do", "does", "have", "has"}),
        "past_tense_density": lexicon_rate(tokens, {"was", "were", "had", "did"}),
    }

    for func_word in sorted(FUNCTION_WORDS):
        feats[f"fw_{func_word}"] = tokens.count(func_word) / max(token_count, 1)

    for name, vocab in LEXICONS.items():
        if name == "self_justify_terms":
            feats[name] = phrase_rate(text, vocab, token_count)
        else:
            feats[name] = lexicon_rate(tokens, vocab)

    return feats


def cosine_to_roth(frame: pd.DataFrame, feature_cols: List[str]) -> pd.Series:
    author_means = frame.groupby("author")[feature_cols].mean()
    roth_vec = author_means.loc["Philip Roth"].to_numpy().reshape(1, -1)
    other = author_means.to_numpy()
    sims = cosine_similarity(other, roth_vec).reshape(-1)
    return pd.Series(sims, index=author_means.index)


def build_semantic_scores(doc_frame: pd.DataFrame, words_per_segment: int = 350) -> pd.Series:
    records = []
    for _, row in doc_frame.iterrows():
        for idx, segment in enumerate(segment_text(row["text"], words_per_segment=words_per_segment)):
            records.append({
                "author": row["author"],
                "title": row["title"],
                "segment_id": idx,
                "segment_text": segment,
            })
    seg = pd.DataFrame(records)
    vectorizer = TfidfVectorizer(
        stop_words="english",
        lowercase=True,
        ngram_range=(1, 2),
        min_df=2,
        max_df=0.85,
        max_features=6000,
    )
    matrix = vectorizer.fit_transform(seg["segment_text"])
    n_components = max(2, min(50, matrix.shape[1] - 1, matrix.shape[0] - 1))
    if n_components < 2:
        dense = matrix.toarray()
    else:
        dense = TruncatedSVD(n_components=n_components, random_state=42).fit_transform(matrix)
    dense = dense / np.maximum(np.linalg.norm(dense, axis=1, keepdims=True), 1e-12)
    seg_vectors = pd.DataFrame(dense)
    seg_vectors["author"] = seg["author"].values
    author_means = seg_vectors.groupby("author").mean()
    roth_vec = author_means.loc["Philip Roth"].to_numpy().reshape(1, -1)
    sims = cosine_similarity(author_means.to_numpy(), roth_vec).reshape(-1)
    return pd.Series(sims, index=author_means.index)


def rank_with_weights(score_frame: pd.DataFrame, weights: Dict[str, float]) -> pd.Series:
    total = None
    for col, weight in weights.items():
        component = score_frame[col] * weight
        total = component if total is None else total + component
    return total.rank(ascending=False, method="min")


def build_outputs() -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    manifest_rows = []
    docs = []

    for row in CORPUS:
        file_name = f"{row['year']}_{slugify(row['author'])}_{slugify(row['title'])}.html"
        html_path = CACHE_DIR / file_name
        html_text = fetch_html(row["url"], html_path)
        article_text = extract_article_text(html_text)
        words = tokenize(article_text)
        manifest_rows.append({
            **row,
            "source": "The New Yorker",
            "unit_type": "magazine_fiction_or_excerpt",
            "html_cache": str(html_path),
            "word_count": len(words),
            "paragraphs": len(split_paragraphs(article_text)),
            "sentences": len(split_sentences(article_text)),
            "fetch_status": "ok",
        })
        docs.append({
            **row,
            "text": article_text,
        })

    manifest = pd.DataFrame(manifest_rows).sort_values(["author", "year", "title"])
    manifest["included_in_analysis"] = manifest["word_count"] >= MIN_ANALYSIS_WORDS
    included_counts = manifest.groupby("author")["included_in_analysis"].sum().rename("included_doc_count")
    manifest = manifest.merge(included_counts, on="author", how="left")
    manifest["author_included"] = manifest["author"].eq("Philip Roth") | (manifest["included_doc_count"] >= MIN_DOCS_PER_CANDIDATE)
    manifest.to_csv(OUTPUT_DIR / "corpus_manifest.csv", index=False)

    candidate_authors = (
        manifest.groupby("author")
        .agg(
            doc_count=("title", "count"),
            included_doc_count=("included_in_analysis", "sum"),
            years=("year", lambda x: f"{int(min(x))}-{int(max(x))}"),
        )
        .reset_index()
    )
    candidate_authors["is_roth_anchor"] = candidate_authors["author"].eq("Philip Roth")
    candidate_authors["negative_control"] = candidate_authors["author"].isin(NEGATIVE_CONTROLS)
    candidate_authors["author_included"] = candidate_authors["is_roth_anchor"] | (candidate_authors["included_doc_count"] >= MIN_DOCS_PER_CANDIDATE)
    candidate_authors["inclusion_rule"] = np.where(
        candidate_authors["is_roth_anchor"],
        "Anchor author with >= 6 accessible New Yorker fiction pieces or excerpts.",
        f"Modern literary fiction author with >= {MIN_DOCS_PER_CANDIDATE} accessible New Yorker fiction pieces or excerpts and each analysis text >= {MIN_ANALYSIS_WORDS} words.",
    )
    candidate_authors.to_csv(OUTPUT_DIR / "candidate_authors.csv", index=False)

    doc_frame = pd.DataFrame(docs)
    doc_frame = doc_frame.merge(
        manifest[["author", "title", "included_in_analysis", "author_included"]],
        on=["author", "title"],
        how="left",
    )
    doc_frame = doc_frame.loc[doc_frame["included_in_analysis"] & doc_frame["author_included"]].copy()
    feature_rows = []
    for _, row in doc_frame.iterrows():
        feats = extract_features(row["text"])
        feature_rows.append({**row, **feats})
    feature_frame = pd.DataFrame(feature_rows)

    style_cols = [
        "avg_sentence_len", "sd_sentence_len", "avg_paragraph_len", "sd_paragraph_len",
        "avg_word_len", "type_token_ratio", "moving_ttr", "dialogue_quote_density",
        "comma_density", "semicolon_density", "colon_density", "dash_density",
        "paren_density", "question_density", "exclamation_density",
    ] + [c for c in feature_frame.columns if c.startswith("fw_")]
    social_cols = [
        "family_terms", "sex_body_terms", "politics_terms", "academia_terms",
        "urban_suburban_terms", "religion_ethnicity_terms", "illness_therapy_terms",
        "work_money_terms", "titlecase_density",
    ]
    voice_cols = [
        "first_person_density", "third_person_density", "present_tense_density",
        "past_tense_density", "interiority_terms", "hedge_terms",
        "self_justify_terms", "argument_terms", "question_density",
        "dash_density", "paren_density",
    ]
    emotion_cols = [
        "moral_terms", "anger_terms", "affection_terms", "mortality_terms",
        "illness_therapy_terms", "sex_body_terms",
    ]

    semantic_scores = build_semantic_scores(doc_frame, words_per_segment=350)
    style_scores = cosine_to_roth(feature_frame, style_cols)
    social_scores = cosine_to_roth(feature_frame, social_cols)
    voice_scores = cosine_to_roth(feature_frame, voice_cols)
    emotion_scores = cosine_to_roth(feature_frame, emotion_cols)

    author_scores = pd.DataFrame({
        "author": sorted(set(feature_frame["author"])),
    }).set_index("author")
    author_scores["topic_semantic_score_raw"] = semantic_scores
    author_scores["style_score_raw"] = style_scores
    author_scores["social_world_score_raw"] = social_scores
    author_scores["narrative_voice_score_raw"] = voice_scores
    author_scores["emotional_moral_score_raw"] = emotion_scores
    author_scores = author_scores.reset_index()

    candidate_mask = author_scores["author"] != "Philip Roth"
    scaled_cols = []
    for raw_col, scaled_col in [
        ("topic_semantic_score_raw", "topic_score"),
        ("style_score_raw", "style_score"),
        ("social_world_score_raw", "social_world_score"),
        ("narrative_voice_score_raw", "narrative_voice_score"),
        ("emotional_moral_score_raw", "emotional_moral_score"),
    ]:
        vals = author_scores.loc[candidate_mask, raw_col].to_numpy()
        if np.allclose(vals.max(), vals.min()):
            scaled = np.repeat(50.0, len(vals))
        else:
            scaled = 100 * (vals - vals.min()) / (vals.max() - vals.min())
        author_scores.loc[candidate_mask, scaled_col] = scaled
        author_scores.loc[~candidate_mask, scaled_col] = 100.0
        scaled_cols.append(scaled_col)

    weights_equal = {
        "topic_score": 0.20,
        "style_score": 0.20,
        "social_world_score": 0.20,
        "narrative_voice_score": 0.20,
        "emotional_moral_score": 0.20,
    }
    author_scores["overall_score"] = sum(author_scores[k] * v for k, v in weights_equal.items())
    author_scores["overall_rank"] = author_scores.loc[candidate_mask, "overall_score"].rank(ascending=False, method="min")
    author_scores.loc[~candidate_mask, "overall_rank"] = 0

    robustness_weights = {
        "equal": weights_equal,
        "topic_heavy": {"topic_score": 0.35, "style_score": 0.15, "social_world_score": 0.20, "narrative_voice_score": 0.15, "emotional_moral_score": 0.15},
        "style_heavy": {"topic_score": 0.15, "style_score": 0.35, "social_world_score": 0.20, "narrative_voice_score": 0.20, "emotional_moral_score": 0.10},
        "voice_heavy": {"topic_score": 0.15, "style_score": 0.20, "social_world_score": 0.15, "narrative_voice_score": 0.35, "emotional_moral_score": 0.15},
        "no_topic": {"style_score": 0.25, "social_world_score": 0.25, "narrative_voice_score": 0.25, "emotional_moral_score": 0.25},
        "no_style": {"topic_score": 0.25, "social_world_score": 0.25, "narrative_voice_score": 0.25, "emotional_moral_score": 0.25},
    }
    robustness_ranks = {}
    candidate_scores = author_scores.loc[candidate_mask, ["author"] + scaled_cols].set_index("author")
    for label, weights in robustness_weights.items():
        ranks = rank_with_weights(candidate_scores, weights)
        robustness_ranks[label] = ranks

    author_scores["median_rank_alt"] = np.nan
    author_scores["rank_sd_alt"] = np.nan
    for idx, row in author_scores.loc[candidate_mask].iterrows():
        ranks = [float(series.loc[row["author"]]) for series in robustness_ranks.values()]
        author_scores.loc[idx, "median_rank_alt"] = float(statistics.median(ranks))
        author_scores.loc[idx, "rank_sd_alt"] = float(np.std(ranks))
    author_scores["stable_top_match"] = (
        candidate_mask
        & (author_scores["overall_rank"] <= 5)
        & (author_scores["median_rank_alt"] <= 5)
        & (author_scores["rank_sd_alt"] <= 2)
    )

    author_doc_counts = manifest.groupby("author")["title"].count().rename("doc_count")
    author_scores = author_scores.merge(author_doc_counts, on="author", how="left")
    author_scores = author_scores.sort_values(["overall_rank", "author"])
    author_scores.to_csv(OUTPUT_DIR / "author_level_scores.csv", index=False)

    # Keep the file name requested by the prompt, but record article-level units explicitly.
    feature_frame["unit_type"] = "article_excerpt"
    feature_frame.to_csv(OUTPUT_DIR / "book_level_features.csv", index=False)

    goodreads_rows = []
    for author in author_scores.loc[candidate_mask, "author"]:
        goodreads_rows.append({
            "author": author,
            "goodreads_status": "pending_local_permission",
            "verification_note": "Primary local Goodreads export path is known, but direct agent read access remains blocked by OS-level permissions.",
        })
    pd.DataFrame(goodreads_rows).to_csv(OUTPUT_DIR / "goodreads_overlap.csv", index=False)

    # Lightweight bibliography for the corpus sources.
    bib_lines = ["# Bibliography", "", "## Primary corpus", ""]
    for row in manifest.itertuples(index=False):
        bib_lines.append(f"- {row.author}. \"{row.title}.\" *The New Yorker* ({row.year}). {row.url}")
    bib_lines.extend([
        "",
        "## Data-access notes",
        "",
        "- Apple Books metadata was locally readable via `Books.plist`, but the underlying EPUB files in iCloud-protected locations were not readable from the agent runtime.",
        "- The primary Goodreads export path was known (`/Users/jacobbrown/Downloads/goodreads_library_export.csv`), but direct agent reads remained blocked by OS-level permissions during this run.",
    ])
    (OUTPUT_DIR / "bibliography.md").write_text("\n".join(bib_lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    build_outputs()
