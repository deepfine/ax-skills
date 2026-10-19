# Unity 저장소 조사 항목

읽기 전용으로 조사한다. Unity 에디터나 빌드를 실행하지 않는다. 찾지 못한 항목은 비워 두지 말고 `확인 필요`로 둔다.

| 항목 | 근거 파일 | 뽑는 방법 |
|---|---|---|
| Unity 버전 | `ProjectSettings/ProjectVersion.txt` | `m_EditorVersion` 값 |
| 렌더 파이프라인 | `Packages/manifest.json` | `com.unity.render-pipelines.universal` → URP, `...high-definition` → HDRP, 둘 다 없으면 Built-in |
| 주요 패키지 | `Packages/manifest.json` | `com.unity.modules.*`와 기본 패키지는 빼고, XR·네트워크·입력·UI·외부 SDK 위주로 버전과 함께 정리 |
| 외부 SDK·플러그인 | `Assets/Plugins/`, `Assets/` 최상위 폴더 | 벤더 폴더명만 나열 (내부 코드 내용은 옮기지 않음) |
| 대상 플랫폼 | `ProjectSettings/ProjectSettings.asset`, `ProjectSettings/EditorBuildSettings.asset`, CI 설정 | 빌드 타깃·XR 설정. 확정할 수 없으면 후보와 `확인 필요` |
| XR 설정 | `Assets/XR/`, `ProjectSettings/XRSettings*`, `Packages/manifest.json`의 `com.unity.xr.*` | 사용하는 XR 플러그인(OpenXR, Oculus 등) |
| 시작 씬 | `ProjectSettings/EditorBuildSettings.asset` | 활성화된 첫 번째 씬 경로 |
| 빌드 씬 목록 | 같은 파일 | 활성화된 씬 경로 목록 |
| 실행·빌드 방법 | `README*`, `Assets/Editor/**/Build*.cs`, CI 파일(`.github/workflows/`, `Jenkinsfile` 등) | 자동 빌드 스크립트가 있으면 파일 링크와 메뉴·메서드 이름만. 없으면 `확인 필요` |
| 코드 구조 | `Assets/Scripts/` 등 최상위 폴더, `*.asmdef` | 어셈블리 정의 이름과 역할 추정은 폴더명 수준에서만. 추정이면 "추정"이라고 쓴다 |
| 대용량 에셋 관리 | `.gitattributes` | Git LFS 사용 여부와 대상 확장자 |

## 기술 검토·결정 표에 넣을 것

코드에서 확인되는 **선택**만 넣는다. 왜 그렇게 정했는지는 근거가 없으면 `확인 필요`로 둔다.

- 렌더 파이프라인
- XR 플러그인·입력 시스템(`com.unity.inputsystem` 유무)
- 네트워크·멀티플레이 패키지
- 빌드 자동화 방식

"근거 문서" 열에는 위 표의 파일 경로를 적는다.
