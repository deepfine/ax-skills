# ax-skills

딥파인 AX TF가 관리하는 **Claude Code·Codex 공용 스킬** 모음입니다.
모든 팀원이 같은 스킬을 쓰게 해서 AI로 만드는 문서의 구조와 기준을 맞추는 것이 목적입니다.

## 포함된 스킬

| 스킬 | 하는 일 | 이렇게 요청 |
|---|---|---|
| `notion-project-page` | 저장소 코드와 기획서를 읽어 Notion 프로젝트 페이지를 팀 공통 양식대로 작성·갱신 | "이 프로젝트 노션 정리해줘" |
| `weekly-report` | Linear 이슈 변화와 Notion 회의록 결정을 모아 주간 보고 초안 작성 | "Unity팀 지난주 주간 보고 써줘" |
| `release-notes` | Git 태그·커밋·PR과 Linear 이슈로 릴리즈 노트 작성 (내부용/고객용) | "v1.2 릴리즈 노트 써줘" |
| `meeting-to-linear` | Notion 회의록의 후속 작업을 Linear 이슈로 만들고 회의록에 링크 연결 | "이 회의록 액션아이템 리니어로 옮겨줘" |

### 필요한 연결

| 스킬 | Notion MCP | Linear MCP | 저장소(git) |
|---|---|---|---|
| `notion-project-page` | 필수 | 선택 | 필수 |
| `weekly-report` | 권장 | 필수 | — |
| `release-notes` | 선택 | 권장 | 필수 |
| `meeting-to-linear` | 필수 | 필수 | — |

모든 스킬은 **미리보기를 보여주고 승인받은 뒤에만** Notion·Linear에 씁니다.

## 설치 (처음 한 번)

```bash
git clone https://github.com/deepfine/ax-skills.git ~/ax-skills
~/ax-skills/install.sh
```

`install.sh`는 `skills/` 아래 스킬을 다음 두 곳에 링크합니다.
- Claude Code: `~/.claude/skills/`
- Codex: `~/.agents/skills/`

같은 이름의 폴더가 이미 있으면 덮어쓰지 않고 건너뜁니다.
설치 후 Claude Code·Codex를 새로 시작하세요.

## 업데이트

```bash
cd ~/ax-skills && git pull
```

링크로 연결되어 있어 다시 설치할 필요가 없습니다. 새 스킬이 추가된 경우에만 `./install.sh`를 한 번 더 실행합니다.

## 제거

```bash
~/ax-skills/install.sh --uninstall
```

## 사전 준비: Notion·Linear MCP 연결

| 서비스 | MCP 주소 |
|---|---|
| Notion | `https://mcp.notion.com/mcp` |
| Linear | `https://mcp.linear.app/mcp` |

- **Claude Code**: claude.ai 계정의 커넥터를 연결하거나, 터미널에서
  `claude mcp add --transport http notion https://mcp.notion.com/mcp`
  `claude mcp add --transport http linear https://mcp.linear.app/mcp`
  실행 후 `/mcp`에서 각각 로그인
- **Codex**: `~/.codex/config.toml`에 위 두 MCP 서버를 추가하고 로그인

연결이 없으면 스킬은 쓰기를 하지 않고 초안이나 후보 목록만 보여줍니다.
Notion·Linear 접근은 **본인 권한**으로 이뤄집니다. 권한이 없는 팀스페이스·비공개 Linear 팀은 읽거나 쓸 수 없습니다.

## 사용 예: notion-project-page

1. 대상 프로젝트 저장소 폴더에서 Claude Code 또는 Codex를 엽니다.
2. "이 프로젝트 노션 정리해줘. 기획서는 `docs/기획서.pdf`야"처럼 요청합니다. 기획서는 파일 경로, Notion PRD 링크, Figma 링크 모두 됩니다.
3. 에이전트가 보여주는 **변경 미리보기**를 확인하고 승인합니다. 승인 전에는 Notion에 쓰지 않습니다.
4. 마지막에 남은 `확인 필요` 항목을 채웁니다.

에이전트가 하지 않는 것:
- 근거 없는 담당자·일정·진척 추측
- `.env`·키·계정 정보 옮기기
- 저장소 파일 수정, 섹션 구조 변경

양식(섹션 구성)의 원본은 Notion의 **프로젝트 시작 템플릿** 페이지입니다. 양식을 바꾸려면 스킬이 아니라 그 페이지를 고칩니다.

## 기여 규칙

- 스킬 수정은 **PR로만** 받습니다. 리뷰어는 AX TF입니다.
- 새 팀에 적용할 때는 `skills/<스킬>/references/`에 팀별 조사 항목을 추가합니다.
- 스킬 안에 비밀값, 개인 정보, 특정 개인 전용 경로를 넣지 않습니다.
