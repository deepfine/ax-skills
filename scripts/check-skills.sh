#!/usr/bin/env bash
# ax-skills 정적 검사
# - 모든 SKILL.md에 name/description frontmatter가 있는지
# - shared/linear-rules.md 복사본이 원본과 같은지
# - Linear에 쓰는 스킬이 linear-rules를 참조하는지
# - 가이드 금지 라벨로 분류하라는 문구가 남아 있지 않은지
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/shared/linear-rules.md"
LINEAR_WRITERS=(meeting-to-linear plan-to-linear)
fail=0

err() { echo "FAIL: $*" >&2; fail=1; }

for skill in "$REPO_DIR"/skills/*/; do
  f="$skill/SKILL.md"
  name="$(basename "$skill")"
  [[ -f "$f" ]] || { err "$name: SKILL.md 없음"; continue; }
  head -1 "$f" | grep -qx -- '---' || err "$name: frontmatter 시작 없음"
  grep -q "^name: $name\$" "$f" || err "$name: name 값이 폴더명과 다름"
  grep -q '^description:' "$f" || err "$name: description 없음"
done

[[ -f "$SRC" ]] || err "shared/linear-rules.md 없음"

for name in "${LINEAR_WRITERS[@]}"; do
  copy="$REPO_DIR/skills/$name/references/linear-rules.md"
  if [[ ! -f "$copy" ]]; then
    err "$name: references/linear-rules.md 없음 (scripts/sync-shared.sh 실행)"
  elif ! cmp -s "$SRC" "$copy"; then
    err "$name: references/linear-rules.md 가 원본과 다름 (scripts/sync-shared.sh 실행)"
  fi
  grep -q 'references/linear-rules.md' "$REPO_DIR/skills/$name/SKILL.md" 2>/dev/null \
    || err "$name: SKILL.md가 references/linear-rules.md를 참조하지 않음"
done

if grep -nE '라벨(로)? `(Feature|Bug|Improvement)`' "$REPO_DIR"/skills/*/SKILL.md "$REPO_DIR/README.md"; then
  err "가이드 금지 라벨(Feature/Bug/Improvement)을 분류 근거로 쓰는 문구가 남아 있음"
fi

[[ $fail -eq 0 ]] && echo "OK: 모든 검사 통과"
exit $fail
