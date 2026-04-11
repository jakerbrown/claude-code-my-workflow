#!/usr/bin/env python3
"""Generate presentation-ready figures for the Roth similarity exploration."""

from __future__ import annotations

import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "output"
MPL_DIR = ROOT / "data" / "cache" / "mplconfig"
MPL_DIR.mkdir(parents=True, exist_ok=True)
os.environ["MPLCONFIGDIR"] = str(MPL_DIR)

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns


sns.set_theme(style="whitegrid", context="talk")


def load_data():
    scores = pd.read_csv(OUTPUT_DIR / "author_level_scores.csv")
    overlap = pd.read_csv(OUTPUT_DIR / "goodreads_overlap.csv")
    scores = scores.merge(overlap[["author", "goodreads_status", "read_count"]], on="author", how="left")
    non_roth = scores.loc[scores["author"] != "Philip Roth"].copy()
    non_roth = non_roth.sort_values("overall_rank")
    return non_roth


def wrap_label(text: str) -> str:
    return text.replace("Aleksandar Hemon", "Aleksandar\nHemon").replace("Mary Gaitskill", "Mary\nGaitskill")


def savefig(path: Path):
    plt.tight_layout()
    plt.savefig(path, dpi=220, bbox_inches="tight")
    plt.close()


def make_heatmap(df: pd.DataFrame):
    cols = [
        "topic_score",
        "style_score",
        "social_world_score",
        "narrative_voice_score",
        "emotional_moral_score",
    ]
    labels = [
        "Topic",
        "Style",
        "Social World\nProxy",
        "Confessional\nMarkers",
        "Emotional-Moral\nProxy",
    ]
    heat = df.set_index("author")[cols].copy()
    heat.index = [wrap_label(x) for x in heat.index]
    plt.figure(figsize=(10, 7.5))
    ax = sns.heatmap(
        heat,
        cmap=sns.color_palette("YlOrRd", as_cmap=True),
        annot=True,
        fmt=".0f",
        linewidths=0.7,
        cbar_kws={"label": "Similarity score (0-100 within corpus)"},
    )
    ax.set_xticklabels(labels, rotation=0)
    ax.set_title("Philip Roth Similarity by Dimension")
    ax.set_xlabel("")
    ax.set_ylabel("")
    savefig(OUTPUT_DIR / "figure_heatmap_by_dimension.png")


def make_leaderboard(df: pd.DataFrame):
    colors = {
        "verified_read": "#1b9e77",
        "not_found_in_export": "#d95f02",
        "mixed_read_and_dnf": "#7570b3",
        "unknown": "#666666",
    }
    plot = df.copy().sort_values("overall_score")
    plot["status_color"] = plot["goodreads_status"].fillna("unknown").map(colors)
    plt.figure(figsize=(10, 7.5))
    ax = plt.gca()
    ax.barh(plot["author"], plot["overall_score"], color=plot["status_color"])
    ax.set_title("Overall Roth Similarity Leaderboard")
    ax.set_xlabel("Composite similarity score")
    ax.set_ylabel("")
    legend_handles = [
        plt.Line2D([0], [0], color=colors["verified_read"], lw=8, label="Already read"),
        plt.Line2D([0], [0], color=colors["not_found_in_export"], lw=8, label="Not found in Goodreads export"),
        plt.Line2D([0], [0], color=colors["mixed_read_and_dnf"], lw=8, label="Mixed / did-not-finish"),
    ]
    ax.legend(handles=legend_handles, loc="lower right", frameon=True)
    savefig(OUTPUT_DIR / "figure_overall_leaderboard_goodreads.png")


def make_profile_chart(df: pd.DataFrame):
    top = df.head(5).copy()
    dims = [
        "topic_score",
        "style_score",
        "social_world_score",
        "narrative_voice_score",
        "emotional_moral_score",
    ]
    dim_labels = ["Topic", "Style", "Social", "Voice", "Emotion"]
    angles = np.linspace(0, 2 * np.pi, len(dims), endpoint=False).tolist()
    angles += angles[:1]
    plt.figure(figsize=(9, 9))
    ax = plt.subplot(111, polar=True)
    palette = sns.color_palette("Dark2", n_colors=len(top))
    for color, (_, row) in zip(palette, top.iterrows()):
        values = [row[d] for d in dims]
        values += values[:1]
        ax.plot(angles, values, linewidth=2.5, label=row["author"], color=color)
        ax.fill(angles, values, alpha=0.08, color=color)
    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(dim_labels)
    ax.set_yticks([20, 40, 60, 80, 100])
    ax.set_yticklabels(["20", "40", "60", "80", "100"])
    ax.set_ylim(0, 100)
    ax.set_title("Top Roth-Adjacent Authors: Dimensional Profiles", pad=24)
    ax.legend(loc="upper right", bbox_to_anchor=(1.25, 1.15), frameon=True)
    savefig(OUTPUT_DIR / "figure_top_author_profiles.png")


def make_recommendation_table(df: pd.DataFrame):
    subset = df.head(7).copy()
    subset["Goodreads"] = subset["goodreads_status"].map({
        "verified_read": "Read",
        "not_found_in_export": "Not found",
        "mixed_read_and_dnf": "Mixed / DNF",
    }).fillna("Unknown")
    subset["Best match on"] = subset[
        ["topic_score", "style_score", "social_world_score", "narrative_voice_score", "emotional_moral_score"]
    ].idxmax(axis=1).map({
        "topic_score": "Topic",
        "style_score": "Style",
        "social_world_score": "Social proxy",
        "narrative_voice_score": "Voice proxy",
        "emotional_moral_score": "Emotion proxy",
    })
    table = subset[["overall_rank", "author", "overall_score", "Best match on", "Goodreads"]].copy()
    table["overall_score"] = table["overall_score"].map(lambda x: f"{x:.1f}")
    table.columns = ["Rank", "Author", "Score", "Strongest dimension", "Goodreads"]
    fig, ax = plt.subplots(figsize=(11, 3.8))
    ax.axis("off")
    mpl_table = ax.table(
        cellText=table.values,
        colLabels=table.columns,
        cellLoc="left",
        colLoc="left",
        loc="center",
    )
    mpl_table.auto_set_font_size(False)
    mpl_table.set_fontsize(11)
    mpl_table.scale(1, 1.5)
    for (row, col), cell in mpl_table.get_celld().items():
        if row == 0:
            cell.set_text_props(weight="bold", color="white")
            cell.set_facecolor("#2f4858")
        elif row % 2 == 0:
            cell.set_facecolor("#f3f5f7")
    ax.set_title("Roth-Adjacent Authors: Who Matches, and Who's Already Been Read", pad=16)
    savefig(OUTPUT_DIR / "figure_read_unread_recommendation_table.png")


def write_caption_file():
    text = """# Figure Notes

- `figure_heatmap_by_dimension.png`: Heatmap of similarity to Roth across topic, style, social-world proxy, confessional markers, and emotional-moral proxy.
- `figure_overall_leaderboard_goodreads.png`: Overall composite leaderboard colored by Goodreads status.
- `figure_top_author_profiles.png`: Radar chart of the top five Roth-adjacent authors across the five similarity families.
- `figure_read_unread_recommendation_table.png`: Compact table linking rank, strongest dimension, and verified Goodreads status.
"""
    (OUTPUT_DIR / "figure_notes.md").write_text(text, encoding="utf-8")


def main():
    df = load_data()
    make_heatmap(df)
    make_leaderboard(df)
    make_profile_chart(df)
    make_recommendation_table(df)
    write_caption_file()


if __name__ == "__main__":
    main()
