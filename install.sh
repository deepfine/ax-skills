#!/usr/bin/env bash
# ax-skills 설치 스크립트
# skills/ 아래 각 스킬을 Claude Code(~/.claude/skills)와 Codex(~/.agents/skills)에 심볼릭 링크로 연결한다.
# 사용법: ./install.sh            설치·갱신
#         ./install.sh --uninstall 제거 (이 저장소가 만든 링크만)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
TARGETS=("$HOME/.claude/skills" "$HOME/.agents/skills")

mode="install"
[[ "${1:-}" == "--uninstall" ]] && mode="uninstall"

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"
  for skill in "$SKILLS_DIR"/*/; do
    name="$(basename "$skill")"
    src="${skill%/}"
    dest="$target/$name"

    if [[ "$mode" == "uninstall" ]]; then
      if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        rm "$dest"
        echo "제거: $dest"
      fi
      continue
    fi

    if [[ -L "$dest" ]]; then
      if [[ "$(readlink "$dest")" == "$src" ]]; then
        echo "유지: $dest"
        continue
      fi
      echo "건너뜀: $dest 가 다른 위치($(readlink "$dest"))를 가리킵니다. 확인 후 직접 지워 주세요." >&2
      continue
    fi
    if [[ -e "$dest" ]]; then
      echo "건너뜀: $dest 에 같은 이름의 폴더가 이미 있습니다. 확인 후 직접 지워 주세요." >&2
      continue
    fi

    ln -s "$src" "$dest"
    echo "설치: $dest"
  done
done

if [[ "$mode" == "install" ]]; then
  echo
  echo "완료. Claude Code·Codex를 새로 시작하면 스킬이 보입니다."
  echo "업데이트: cd \"$REPO_DIR\" && git pull"
fi
