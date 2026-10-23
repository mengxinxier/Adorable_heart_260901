#!/usr/bin/env python3
"""为当前 clone 启用仓库内共享的 .githooks。"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8")
    except (AttributeError, ValueError, OSError):
        pass


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    try:
        subprocess.run(
            ["git", "config", "core.hooksPath", ".githooks"],
            cwd=root,
            check=True,
        )
    except (OSError, subprocess.CalledProcessError) as exc:
        print(f"安装 git hooks 失败：{exc}", file=sys.stderr)
        return 1
    print("已启用 .githooks/prepare-commit-msg")
    print("请确保已设置环境变量 LLM_API_KEY（以及可选的 LLM_BASE_URL、LLM_MODEL）。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
