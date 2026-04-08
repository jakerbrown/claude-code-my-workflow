#!/usr/bin/env python3
"""Nudge Codex to checkpoint plans/logs before a turn fully stops."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import time
from pathlib import Path
from typing import Any


RECENT_SECONDS = 30 * 60


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


def git_dirty(repo_root: Path) -> bool:
    try:
        out = subprocess.check_output(
            ["git", "status", "--porcelain"],
            cwd=repo_root,
            stderr=subprocess.DEVNULL,
            text=True,
        )
        return bool(out.strip())
    except Exception:
        return False


def latest_md(path: Path) -> Path | None:
    if not path.exists():
        return None
    candidates = [p for p in path.rglob("*.md") if p.is_file()]
    if not candidates:
        return None
    return max(candidates, key=lambda p: p.stat().st_mtime)


def modified_recently(path: Path | None, seconds: int) -> bool:
    if not path or not path.exists():
        return False
    return (time.time() - path.stat().st_mtime) <= seconds


def changed_production_files(repo_root: Path) -> bool:
    try:
        out = subprocess.check_output(
            ["git", "status", "--porcelain"],
            cwd=repo_root,
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except Exception:
        return False
    for raw in out.splitlines():
        line = raw.strip()
        if not line:
            continue
        # path is usually after the two-column status
        path = line[3:] if len(line) > 3 else line
        if path.endswith((".tex", ".qmd", ".R", ".py", ".md")):
            return True
    return False


def block(reason: str) -> None:
    print(json.dumps({"decision": "block", "reason": reason}))


def warn(message: str) -> None:
    print(json.dumps({"systemMessage": message}))


def main() -> None:
    try:
        payload: dict[str, Any] = json.load(sys.stdin)
    except Exception:
        payload = {}

    cwd = payload.get("cwd") or os.getcwd()
    repo_root = find_repo_root(cwd)

    if not git_dirty(repo_root):
        print(json.dumps({"continue": True}))
        return

    session_log = latest_md(repo_root / "quality_reports" / "session_logs")
    plan = latest_md(repo_root / "quality_reports" / "plans")

    if changed_production_files(repo_root) and not session_log:
        block(
            "Before stopping, create or update a session log in "
            "`quality_reports/session_logs/` summarizing what changed, what was verified, "
            "and what remains open."
        )
        return

    if changed_production_files(repo_root) and not plan:
        block(
            "Before stopping, write or refresh a task plan in "
            "`quality_reports/plans/` so the next session can resume cleanly."
        )
        return

    if not modified_recently(session_log, RECENT_SECONDS):
        warn(
            "There are still uncommitted changes. Update the session log with the latest decisions "
            "and verification status before you leave the turn."
        )
        return

    if not modified_recently(plan, RECENT_SECONDS * 4):
        warn(
            "The plan on disk looks stale relative to current changes. Refresh it if the task scope shifted."
        )
        return

    print(json.dumps({"continue": True}))


if __name__ == "__main__":
    main()
