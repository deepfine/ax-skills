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

## 사용 전 준비

아래 항목이 갖춰져 있어야 스킬이 제대로 동작합니다. 처음 한 번만 하면 됩니다.

### 1. 계정과 권한

| 항목 | 필요한 상태 | 없으면 |
|---|---|---|
| **GitHub** | `deepfine` 조직 멤버이고 `deepfine/ax-skills` 읽기 권한이 있음 | 설치(clone) 불가. AX TF에 요청 |
| **Notion** | 딥파인 워크스페이스 멤버이고, 대상 팀스페이스(예: Unity Team)에 **편집 권한**이 있음 | 읽기만 되고 페이지 저장 불가 |
| **Linear** | 딥파인 워크스페이스 멤버이고, 대상 **팀의 멤버**임 (비공개 팀은 초대 필요) | 해당 팀 이슈 조회·생성 불가 |

Notion·Linear는 **본인 권한**으로 접근합니다. 스킬이 권한을 넓혀 주지 않습니다.

### 2. 프로그램

| 프로그램 | 용도 | 확인 명령 |
|---|---|---|
| Claude Code 또는 Codex | 스킬 실행 | `claude --version` / `codex --version` |
| git | 설치·업데이트, 저장소 분석 | `git --version` |
| GitHub CLI `gh` (선택) | `release-notes`가 병합된 PR 정보를 가져올 때 | `gh auth status` |

### 3. MCP 연결 (Notion·Linear)

| 서비스 | MCP 주소 |
|---|---|
| Notion | `https://mcp.notion.com/mcp` |
| Linear | `https://mcp.linear.app/mcp` |

**Claude Code**
```bash
claude mcp add --transport http --scope user notion https://mcp.notion.com/mcp
claude mcp add --transport http --scope user linear https://mcp.linear.app/mcp
```
그다음 Claude Code 안에서 `/mcp` → `notion`, `linear`를 각각 선택해 **Authenticate**로 로그인합니다.
claude.ai 계정에 Notion 커넥터를 이미 연결했다면 Notion은 건너뛰어도 됩니다.

**Codex**
```bash
codex mcp add notion --url https://mcp.notion.com/mcp
codex mcp add linear --url https://mcp.linear.app/mcp
codex mcp login notion   # 브라우저가 열리면 승인
codex mcp login linear
```

**연결 확인**
```bash
claude mcp list   # notion, linear가 ✔ Connected
codex mcp list    # notion, linear의 Auth가 OAuth, Status가 enabled
```

연결이 없으면 스킬은 Notion·Linear에 쓰지 않고, 초안이나 후보 목록만 보여줍니다.

### 4. Notion·Linear 데이터 준비

스킬은 이미 쌓인 기록을 읽어서 동작합니다. 아래가 비어 있으면 결과도 비거나 `확인 필요`가 많아집니다.

| 스킬 | 미리 갖춰야 할 것 |
|---|---|
| `notion-project-page` | 프로젝트 DB에 해당 프로젝트 행이 있고 **`Git` 속성에 저장소 URL**이 들어 있음 (저장소와 페이지를 이 값으로 연결) |
| `weekly-report` | 업무가 **Linear 이슈로 관리**되고 있고 상태값이 공통 6개(Backlog / Todo / In Progress / In Review / Done / Canceled)를 따름. 마감일이 있는 이슈는 마감일 입력 |
| `release-notes` | 릴리즈마다 **git 태그**를 붙임. 브랜치명·PR 제목·커밋 메시지에 **Linear 이슈 ID**(예: `UNI-123`)를 넣음. 이슈 라벨로 `Feature`·`Bug`·`Improvement`(또는 `기능`·`버그`·`개선`)를 씀 |
| `meeting-to-linear` | 회의록이 **회의록 DB에 행으로** 있고 `프로젝트` 관계가 지정됨. 그 프로젝트 행의 **`Linear` 속성에 Linear 프로젝트 URL**이 들어 있음 |

Unity팀 외의 팀은 아직 기준 DB가 스킬에 등록되어 있지 않습니다. 실행할 때 DB·템플릿 URL을 알려주거나, AX TF에 등록을 요청하세요.

### 5. 설치 확인

설치 후 Claude Code·Codex를 **새로 시작**하고 "사용 가능한 스킬 목록 보여줘"라고 물어봅니다. `notion-project-page`, `weekly-report`, `release-notes`, `meeting-to-linear`가 보이면 준비가 끝난 것입니다.

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
