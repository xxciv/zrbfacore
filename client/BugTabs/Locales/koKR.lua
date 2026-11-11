local _, AddonNamespace = ...

if GetLocale() ~= "koKR" then return end

local L = AddonNamespace.L

-- Korean Translations
L["LOADED_DB"] = "데이터베이스를 불러왔습니다."
L["READY_CATCH"] = "오류를 감지할 준비가 되었습니다."
L["CAPTURE_ACTIVE"] = "오류 캡처 활성화됨 (기본 UI 숨김)."
L["CUSTOM_FONT_RELOAD"] = "사용자 지정 코드 글꼴 설정이 변경되었습니다. 적용하려면 UI를 다시 불러오세요 (/reload)."

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "파일"
L["MENU_EDIT"] = "편집"
L["MENU_OPTIONS"] = "옵션"

L["OPTION_SAVE_HISTORY"] = "기록 저장"
L["OPTION_SELECT_ALL"] = "전체 선택"
L["OPTION_CLEAR_TAB"] = "탭 지우기"
L["OPTION_CLOSE_WINDOW"] = "창 닫기"

L["OPTION_ENABLE_BANNER"] = "배너 활성화"
L["OPTION_ENABLE_SOUND"] = "소리 활성화"
L["OPTION_ENABLE_FONT"] = "사용자 지정 글꼴 사용"

L["SOUND_RAID_WARNING"] = "소리: 공격대 경고"
L["SOUND_DING"] = "소리: 딩"
L["SOUND_EXPLOSION"] = "소리: 폭발"
L["SOUND_LEVEL_UP"] = "소리: 레벨 업"

L["HISTORY_PREFIX"] = "[기록 %s]"
L["NO_ERRORS"] = "%s에 대한 오류가 없습니다"
L["UNKNOWN_ADDON"] = "알 수 없음"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00좌클릭|r으로 BugTabs 열기"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Shift + 좌클릭|r으로 세션 오류 지우기"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00우클릭|r으로 기록 저장 전환"
L["MINIMAP_ERRORS_COUNT"] = "현재 오류: |cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "전투 중 오류가 발생했습니다."
L["HISTORY_ENABLED_MSG"] = "기록 저장: |cFF00FF00활성화됨|r"
L["HISTORY_DISABLED_MSG"] = "기록 저장: |cFFFF0000비활성화됨|r"
L["SESSION_CLEARED_MSG"] = "세션 오류가 지워졌습니다."
L["VERSION_AVAILABLE"] = "새 버전을 사용할 수 있습니다 (%s)!"
L["DOWNLOAD_UPDATE"] = "CurseForge에서 업데이트를 다운로드하세요."
L["SIDEBAR_ADDONS"] = "애드온"
L["SEVERITY_ERROR"] = "오류"
L["SEVERITY_WARNING"] = "경고"
L["ACTION_COPY"] = "모두 복사"
L["ACTION_CLEAR"] = "탭 지우기"
L["STACK_TRACE"] = "스택 추적"
L["SETTINGS_TITLE"] = "설정"
L["OPTION_ENABLE_TOAST"] = "토스트 활성화"
L["OPTION_SHOW_MINIMAP"] = "미니맵 버튼 표시"
L["MENU_SOUND"] = "소리"
L["ERRORS_COUNT"] = "오류 %d개"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "지역 변수 캡처"
L["LOCALS_HEADER"] = "지역 변수"
