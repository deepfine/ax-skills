#!/usr/bin/env bash
# shared/ 아래 공통 참조 파일을 각 스킬의 references/로 복사한다.
# 스킬 폴더는 ~/.claude/skills 등에 따로 링크되므로 references/ 안에 실제 파일이 있어야 한다.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/shared/linear-rules.md"
LINEAR_WRITERS=(meeting-to-linear plan-to-linear)

for name in "${LINEAR_WRITERS[@]}"; do
  dir="$REPO_DIR/skills/$name/references"
  mkdir -p "$dir"
  cp "$SRC" "$dir/linear-rules.md"
  echo "복사: skills/$name/references/linear-rules.md"
done
