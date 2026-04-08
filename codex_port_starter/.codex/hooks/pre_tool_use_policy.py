#!/usr/bin/env python3
"""Deny obviously dangerous Bash commands and warn on infrastructure edits."""

from __future__ import annotations

import json
import os
import re
import sys
from typing import Any


DANGEROUS_PATTERNS = [
    (re.compile(r"\bsudo\b"), "Commands requiring sudo are blocked in this workflow."),
    (re.compile(r"\brm\s+-rf\s+(/|~)\b"), "Destructive recursive delete of a root-like path is blocked."),
    (re.compile(r"\bgit\s+reset\s+--hard\b"), "Hard reset is blocked; use targeted restores or a new worktree."),
    (re.compile(r"\bmkfs\b"), "Filesystem formatting commands are blocked."),
    (re.compile(r"\bdd\s+if="), "Raw disk write commands are blocked."),
    (re.compile(r"\bshutdown\b|\breboot\b"), "Host shutdown or reboot commands are blocked."),
    (re.compile(r":\(\)\s*\{\s*:\|\:&\s*\};:"), "Fork bombs are blocked."),
]


def deny(reason: str) -> None:
    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": reason,
                }
            }
        )
    )


def system_message(message: str) -> None:
    print(json.dumps({"systemMessage": message}))


def main() -> None:
    try:
        payload: dict[str, Any] = json.load(sys.stdin)
    except Exception:
        return

    command = (
        payload.get("tool_input", {}).get("command")
        if isinstance(payload.get("tool_input"), dict)
        else None
    ) or ""

    lowered = command.lower()

    for pattern, reason in DANGEROUS_PATTERNS:
        if pattern.search(lowered):
            deny(reason)
            return

    if any(token in command for token in [".codex/", ".agents/", "AGENTS.md", "KNOWLEDGE_BASE.md", "MEMORY.md"]):
        system_message(
            "You are touching workflow infrastructure or durable memory. "
            "Keep changes minimal, explain why, and prefer explicit reportable edits."
        )
        return

    if any(tool in lowered for tool in ["curl ", "wget ", "pip install", "npm install", "pnpm install", "brew install"]):
        system_message(
            "This command may require network access or widen the local environment. "
            "Prefer documented project scripts and keep the change justified."
        )
        return


if __name__ == "__main__":
    main()
