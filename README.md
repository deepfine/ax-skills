# ax-skills

딥파인 AX TF가 관리하는 **Claude Code·Codex 공용 스킬** 모음입니다.
모든 팀원이 같은 스킬을 쓰게 해서 AI로 만드는 문서의 구조와 기준을 맞추는 것이 목적입니다.

## 포함된 스킬

| 스킬 | 하는 일 | 이렇게 요청 |
|---|---|---|
| `notion-project-page` | 기획서·WBS(와 저장소 코드)를 읽어 Notion 프로젝트 페이지를 팀 공통 양식대로 작성·갱신 | "이 프로젝트 노션 정리해줘" |
| `weekly-report` | Linear 이슈 변화와 Notion 회의록 결정을 모아 주간 보고 초안 작성 | "Unity팀 지난주 주간 보고 써줘" |
| `release-notes` | Git 태그·커밋·PR과 Linear 이슈로 릴리즈 노트 작성 (내부용/고객용) | "v1.2 릴리즈 노트 써줘" |
| `meeting-to-linear` | Notion 회의록의 후속 작업을 Linear 이슈로 만들고 회의록에 링크 연결 | "이 회의록 액션아이템 리니어로 옮겨줘" |
| `plan-to-linear` | 기획서·시나리오·WBS를 읽어 Linear 프로젝트·마일스톤·Epic·Task를 일괄 세팅 | "이 WBS로 리니어 프로젝트 세팅해줘" |

### 필요한 연결

| 스킬 | Notion MCP | Linear MCP | 저장소(git) |
|---|---|---|---|
| `notion-project-page` | 필수 | 선택 | 선택 (있으면 코드에서 기술 정보까지 채움) |
| `weekly-report` | 권장 | 필수 | — |
| `release-notes` | 선택 | 권장 | 필수 |
| `meeting-to-linear` | 필수 | 필수 | — |
| `plan-to-linear` | 선택 | 필수 | — |

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
| git | ax-skills **설치·업데이트**(`git clone`·`git pull`). 스킬 실행에는 `release-notes`, 저장소가 있는 `notion-project-page`에만 필요 | `git --version` |
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
| `notion-project-page` | 프로젝트 DB에 해당 프로젝트 행이 있음. 저장소가 있으면 **`Git` 속성에 저장소 URL**을 넣어 두면 자동으로 찾음 (없으면 프로젝트명으로 찾음) |
| `weekly-report` | 업무가 **Linear 이슈로 관리**되고 있고 상태값이 공통 6개(Backlog / Todo / In Progress / In Review / Done / Canceled)를 따름. 마감일이 있는 이슈는 마감일 입력 |
| `release-notes` | 릴리즈마다 **git 태그**를 붙임. 브랜치명·PR 제목·커밋 메시지에 **Linear 이슈 ID**(예: `UNI-123`)를 넣음. 커밋·PR 제목에 `feat`·`fix`·`perf` 같은 접두어를 씀 |
| `meeting-to-linear` | 회의록이 **회의록 DB에 행으로** 있고 `프로젝트` 관계가 지정됨. 그 프로젝트 행의 **`Linear` 속성에 Linear 프로젝트 URL**이 들어 있음 |
| `plan-to-linear` | 상위 **이니셔티브**(예: SI)가 있음. 대상 팀이 `shared/linear-rules.md`의 **팀별 값 표**에 있음 (없으면 실행 중에 prefix·라벨을 물어봄). WBS에 단계·작업·완료일이 있음 |

스킬에는 특정 팀의 Notion DB 주소가 들어 있지 않습니다. 실행하면 **어느 팀인지, 어느 DB·템플릿을 쓸지** 먼저 물어봅니다. URL을 바로 알려주면 질문이 줄고, 모르면 스킬이 Notion에서 찾아 후보를 보여줍니다. 팀 DB에 스킬이 쓰는 속성(예: `Git`, `Linear`, `프로젝트`)이 없으면 어느 속성으로 쓸지 물어봅니다.

### 5. 설치 확인

설치 후 Claude Code·Codex를 **새로 시작**하고 "사용 가능한 스킬 목록 보여줘"라고 물어봅니다. `notion-project-page`, `weekly-report`, `release-notes`, `meeting-to-linear`, `plan-to-linear`가 보이면 준비가 끝난 것입니다.

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

## 사용 방법: WBS로 시작하는 프로젝트

새 프로젝트는 보통 **WBS 엑셀 하나**에서 시작합니다. 아래 순서로 스킬을 쓰면 Linear·Notion이 회사 전체에서 같은 구조로 쌓입니다.

| 언제 | 스킬 | 결과 |
|---|---|---|
| ① 프로젝트 착수 | `plan-to-linear` | WBS → Linear 프로젝트·마일스톤·Epic·Task |
| ② 착수 직후 (저장소가 생기면 한 번 더) | `notion-project-page` | 기획서·WBS(+코드) → Notion 프로젝트 페이지 |
| ③ 회의가 끝날 때마다 | `meeting-to-linear` | 회의록 후속 작업 → Linear Task |
| ④ 매주 | `weekly-report` | Linear 변화 + 회의 결정 → 주간 보고 |
| ⑤ 배포할 때 | `release-notes` | 커밋·PR·이슈 → 릴리즈 노트 |

**공통 요령**
- 평소 말투로 요청하면 맞는 스킬이 자동으로 실행됩니다. 직접 고르려면 Claude Code에서는 `/plan-to-linear`, Codex에서는 `$plan-to-linear`처럼 스킬 이름을 앞에 붙입니다.
- 모든 스킬은 **미리보기를 먼저 보여주고, "승인"이라고 답하기 전에는 아무것도 만들지 않습니다.** 미리보기를 보고 말로 고치면 됩니다.
- 파일은 **전체 경로**로 알려 줍니다. 터미널 창에 파일을 끌어다 놓으면 경로가 들어갑니다. 엑셀은 **탭 이름**도 같이 적습니다.
- 정보가 빠지면 스킬이 물어봅니다. 처음부터 아래 예시처럼 다 적으면 질문 없이 바로 미리보기가 나옵니다.

### ① plan-to-linear: WBS로 Linear 세팅

**명령에 넣을 것**

| 항목 | 예 | 설명 |
|---|---|---|
| WBS 파일과 탭 | `~/Downloads/GDS3.0_..._WBS_0812.xlsx`, `SIS WBS` 탭 | 단계·작업·완료일이 있는 탭 |
| 이니셔티브 | `SI` | 사업 구분. 새로 만들지 않고 있는 것을 고릅니다 |
| 고객사 | `제일기획` | **프로젝트 라벨**이 됩니다. 프로젝트 이름 앞에도 붙습니다 |
| 프로젝트명 | `SIS AI Solution` | 최종 이름: `제일기획 - SIS AI Solution` |
| Linear 팀 | `Unity` | Task 접두어(`[Unity]`)와 라벨이 이 팀 기준으로 정해집니다 |
| 리드·담당자 | `명제원` | 프로젝트 리드, Task 기본 담당자(팀 대표 또는 프로젝트 담당자) |
| (선택) 기획서·시나리오 | `~/Downloads/SIS솔루션시나리오_수정.pptx` | Epic(기능 묶음)을 나누는 근거. 없으면 WBS 트랙·작업명으로 묶습니다 |
| (선택) 범위 | `M1~M3만` | 일부 단계만 먼저 올릴 때 |

**기본 명령**
```text
~/Downloads/GDS3.0_Integrated_AX_Solution_WBS_0812.xlsx 의 'SIS WBS' 탭으로 리니어 프로젝트 세팅해줘.
- 이니셔티브: SI
- 고객사: 제일기획
- 프로젝트명: SIS AI Solution
- 팀: Unity
- 리드와 Task 담당자: 명제원
기능 묶음은 ~/Downloads/SIS솔루션시나리오_수정.pptx 시나리오 기준으로 나눠줘.
```

**다른 상황**
```text
# 일부 단계만
같은 WBS에서 M1, M2 단계만 먼저 올려줘. 나머지는 다음 주에 할게.

# 이미 만든 프로젝트에 이어서
'제일기획 - SIS AI Solution' 프로젝트에 WBS 수정본(~/Downloads/..._WBS_0920.xlsx)에서 새로 생긴 작업만 추가해줘.

# 여러 팀이 나눠 맡는 WBS (예: 물류사업팀)
~/Downloads/한진_WBS.xlsx 'WBS' 탭으로 세팅해줘. 이니셔티브 SI, 고객사 한진, 프로젝트명 WMS 고도화.
트랙이 기획이면 Planning-Team, 디자인이면 Product Design, 백엔드·웹이면 Product Engineer, 앱이면 Android-Team에 Task를 만들어줘.
```

**미리보기를 보고 고칠 때**
```text
'웹 3D 에디터'와 'Planogram' Epic은 하나로 합쳐줘.
M5부터 Task 담당자는 홍길동으로 바꿔줘.
'통합 테스트 · 검증' Epic 이름을 'QA · 검증'으로 바꿔줘.
좋아, 이대로 만들어줘.
```

**이렇게 요청하면 스킬이 막거나 다시 물어봅니다**

| 요청 | 이유 / 스킬의 대응 |
|---|---|
| "이 WBS 리니어에 넣어줘" (정보 없이) | 이니셔티브·고객사·팀·담당자를 차례로 묻습니다 |
| "제일기획 이니셔티브를 SI 밑에 만들어줘" | 하위 이니셔티브는 Enterprise 요금제 전용이라 붙지 않습니다. **프로젝트 라벨 `제일기획`**로 대신합니다 |
| "트랙별로 System/APP/WEB 라벨 붙여줘" | 이슈 라벨은 `epic`/`task`만 씁니다. 트랙은 Task 본문에 적힙니다 |
| "날짜 지난 작업은 Done 처리해줘" | 진척은 추측하지 않습니다. 모두 Backlog로 만들고, 실제 상태는 담당자가 바꿉니다 |
| "잘못 만들었으니 다 지워줘" | 에이전트는 삭제하지 않습니다. Canceled 처리하고 **삭제 대상 목록**을 줍니다. 삭제는 사람이 합니다 |
| 팀별 값 표에 없는 팀 | Task 접두어와 Epic을 둘 팀을 묻습니다. 끝나면 AX TF에 팀 등록을 요청하세요 |

### ② notion-project-page: Notion 프로젝트 페이지

아무 폴더에서나 요청하면 됩니다. 저장소가 있는 프로젝트는 **저장소 폴더에서** 열면 코드에서 엔진 버전·개발 환경 같은 기술 정보까지 채웁니다.
```text
제일기획 SIS 프로젝트 노션 정리해줘.
기획서는 ~/Downloads/SIS솔루션시나리오_수정.pptx, 일정은 ~/Downloads/GDS3.0_Integrated_AX_Solution_WBS_0812.xlsx 'SIS WBS' 탭이야.
Linear는 '제일기획 - SIS AI Solution' 프로젝트야.
```
- 저장소가 있으면 `Git` 속성으로, 없으면 프로젝트명·Linear URL로 페이지를 찾습니다. 그래도 없으면 새 행을 만들지 확인합니다.
- 저장소가 없으면 기술 검토·개발 환경 칸은 `확인 필요`로 남습니다. 저장소가 생긴 뒤 저장소 폴더에서 다시 실행하면 그 칸만 채웁니다.
- 기능 표의 "관련 Linear 이슈"에는 Epic ID가 들어갑니다. 진행 상태는 쓰지 않고 Linear 링크로 대신합니다.
- 근거 없는 담당자·일정·진척은 쓰지 않고, `.env`·키·계정 정보는 옮기지 않습니다. 양식의 원본은 Notion의 **프로젝트 시작 템플릿** 페이지입니다.

### ③ meeting-to-linear: 회의 후속 작업

```text
이 회의록 후속 작업 리니어로 옮겨줘. https://app.notion.com/p/...
```
```text
지난주 제일기획 SIS 회의록 중에 아직 이슈로 안 옮긴 것들 정리해줘.
```
- 맞는 Epic을 골라 `[Unity] …` Task로 만들고, 회의록 '후속 작업' 표에 이슈 링크를 넣습니다.
- 회의록에 이름·날짜가 없으면 담당자·마감일을 묻습니다.

### ④ weekly-report: 주간 보고

```text
Unity팀 지난주 주간 보고 써줘.
```
```text
제일기획 SIS 프로젝트만 이번 주(10/19~10/23) 주간 보고 써주고, 노션 회의록 DB에 '주간 공유'로 저장해줘.
```
- Linear에서 상태가 바뀐 이슈와 회의록의 결정만 모읍니다. 사람별 비교는 하지 않습니다.

### ⑤ release-notes: 릴리즈 노트

저장소 폴더에서 요청합니다.
```text
v0.9 릴리즈 노트 써줘. 직전 태그부터.
```
```text
v1.0 고객용 릴리즈 노트로 써줘. 제일기획에 보낼 거야.
```
- 고객용은 내부 링크·이름·커밋 해시를 빼고, 사람이 검토하기 전에는 저장하거나 보내지 않습니다.

## 기여 규칙

- 스킬 수정은 **PR로만** 받습니다. 리뷰어는 AX TF입니다.
- 새 팀에 적용할 때는 `skills/<스킬>/references/`에 팀별 조사 항목을 추가합니다.
- 스킬 안에 비밀값, 개인 정보, 특정 개인 전용 경로를 넣지 않습니다.
- Linear 작성 규칙은 `shared/linear-rules.md`가 원본입니다. 고친 뒤 `./scripts/sync-shared.sh`로 각 스킬에 복사하고, PR 전에 `./scripts/check-skills.sh`가 통과해야 합니다.
- 새 팀이 Linear 스킬을 쓰려면 `shared/linear-rules.md`의 팀별 값 표(prefix, Epic을 둘 팀, `epic`·`task` 라벨 ID)에 행을 추가합니다.

## Linear 구조 기준

모든 Linear 스킬은 팀 Linear 가이드를 따릅니다. 요약:
- **Initiative → Project → Epic → Task.** 모든 Task는 Epic 밑, 모든 이슈는 Project에 연결
- **고객사 구분은 프로젝트 라벨**로 합니다: 이니셔티브 `SI` + 프로젝트 라벨 `제일기획` + 이름 `제일기획 - SIS AI Solution`
- 이슈 라벨은 `epic`/`task`만, 제목은 `<<Epic>>` / `[Unity]` 같은 팀 prefix
- 기준 예시: Linear의 **제일기획 - SIS AI Solution** 프로젝트
