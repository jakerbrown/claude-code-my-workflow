#!/usr/bin/env python3
"""Emit lightweight reminders after verification or workflow-relevant Bash commands."""

from __future__ import annotations

import json
import re
import sys
from typing import Any


VERIFY_PATTERNS = [
    r"\bxelatex\b",
    r"\blatexmk\b",
    r"\bquarto\s+render\b",
    r"sync_to_docs\.sh",
    r"\brscript\b",
    r"\bpytest\b",
    r"\bmake\s+test\b",
]

GIT_PATTERNS = [
    r"\bgit\s+add\b",
    r"\bgit\s+commit\b",
    r"\bgit\s+push\b",
    r"\bgh\s+pr\s+(create|merge)\b",
]


def emit(message: str) -> None:
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

    if any(re.search(p, lowered) for p in VERIFY_PATTERNS):
        emit(
            "Verification-like command completed. Record the result in the session log or quality report, "
            "including warnings, missing outputs, hard-gate failures, the current quality score, and whether specialist review or adversarial QA still needs to run."
        )
        return

    if any(re.search(p, lowered) for p in GIT_PATTERNS):
        emit(
            "Git/PR workflow command completed. Make sure the quality threshold, verification summary, "
            "specialist-review status, and relevant reports are all on disk before considering the task finished."
        )
        return


if __name__ == "__main__":
    main()
