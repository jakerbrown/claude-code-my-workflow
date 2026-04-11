#!/usr/bin/env python3
"""Provide resume context from on-disk workflow artifacts."""

from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path
from typing import Iterable


def find_repo_root(cwd: str) -> Path:
    try:
        out = subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=cwd,
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        if out:
            return Path(out)
    except Exception:
        pass
    return Path(cwd)


def newest_markdown(directory: Path) -> Path | None:
    if not directory.exists():
        return None
    candidates = [p for p in directory.rglob("*.md") if p.is_file()]
    if not candidates:
        return None
    return max(candidates, key=lambda p: p.stat().st_mtime)


def first_nonempty_lines(path: Path, limit: int = 12) -> list[str]:
    if not path or not path.exists():
        return []
    lines: list[str] = []
    for raw in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = raw.strip()
        if line:
            lines.append(line)
        if len(lines) >= limit:
            break
    return lines


def recent_learn_titles(memory_path: Path, limit: int = 3) -> list[str]:
    if not memory_path.exists():
        return []
    titles: list[str] = []
    for raw in memory_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = raw.strip()
        if line.startswith("[LEARN]"):
            titles.append(line)
    return titles[:limit] if limit and titles else titles


def summarize_context(repo_root: Path, source: str) -> str:
    plan = newest_markdown(repo_root / "quality_reports" / "plans")
    log = newest_markdown(repo_root / "quality_reports" / "session_logs")
    memory = repo_root / "MEMORY.md"

    parts: list[str] = []
    parts.append(
        "This repository uses a Codex-first contractor workflow. "
        "For non-trivial work, keep or refresh a plan on disk and write reports to quality_reports/."
    )
    parts.append(
        "Important: Codex subagents must be spawned explicitly when parallel review is needed."
    )

    if source == "resume":
        parts.append("This is a resumed session. Reconstruct state from on-disk artifacts before editing.")

    if plan and plan.exists():
        rel = plan.relative_to(repo_root)
        head = " | ".join(first_nonempty_lines(plan, limit=8))
        parts.append(f"Latest plan: `{rel}` — {head}")

    if log and log.exists():
        rel = log.relative_to(repo_root)
        head = " | ".join(first_nonempty_lines(log, limit=6))
        parts.append(f"Latest session log: `{rel}` — {head}")

    learn_titles = recent_learn_titles(memory)
    if learn_titles:
        parts.append("Recent durable lessons: " + " ; ".join(learn_titles))

    parts.append(
        "When working on slide or Quarto tasks, consult the layered AGENTS files plus "
        "`KNOWLEDGE_BASE.md`, `MEMORY.md`, and `docs/PORTING_MAP.md` if the task touches workflow infrastructure."
    )

    text = "\n\n".join(parts)
    # Keep hook context reasonably short.
    return text[:7000]


def main() -> None:
    try:
        payload = json.load(os.fdopen(0))
    except Exception:
        payload = {}

    cwd = payload.get("cwd") or os.getcwd()
    source = payload.get("source") or "startup"
    repo_root = find_repo_root(cwd)

    context = summarize_context(repo_root, source)
    result = {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": context,
        }
    }
    print(json.dumps(result))


if __name__ == "__main__":
    main()
