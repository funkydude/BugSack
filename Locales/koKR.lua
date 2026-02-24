local addonName, addon = ...
if GetLocale() ~= "koKR" then return end

local L = {}

-- General
L["General.AllBugs"] = "모든 버그"
L["General.BugsExterminated"] = "저장된 모든 버그는 고통스럽게 박멸되었습니다."
L["General.CurrentSession"] = "현재 세션"
L["General.Filter"] = "필터"
L["General.Local"] = "로컬 (%s)"
L["General.Next"] = "다음 >"
L["General.Previous"] = "< 이전"
L["General.PreviousSession"] = "이전 세션"
L["General.Send"] = "보내기"
L["General.SendBugs"] = "버그 보내기"
L["General.SentBy"] = "%s님에게 보냄 (%s)"
L["General.Today"] = "오늘"
L["General.NoBugs"] = "버그가 없습니다. 야호!"
L["General.BugInSoup"] = "수프에 벌레가 있습니다!"
L["General.QuickTipsTitle"] = "빠른 팁"
L["General.QuickTipsDesc"] = "더블-클릭하여 버그 보고서를 필터링합니다. 검색 결과를 모두 확인한 후에는 아래의 탭을 선택하여 전체 자루로 돌아갑니다. 왼쪽-클릭을 하고 드래그하면 창을 이동합니다. 오른쪽-클릭을 하면 자루를 닫고 BugSack의 인터페이스 옵션을 엽니다."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack은 %s 애드온을 필요로 하며, BugSack을 다운로드한 같은 곳에서 다운로드할 수 있습니다. 그럼 즐거운 버그 사냥되세요!"
L["ErrorMessage.DeserializeFail"] = "%s|1으로;로;부터 들어오는 데이터의 역직렬화에 실패했습니다."
L["ErrorMessage.InvalidPlayer"] = "플레이어는 올바른 이름이어야 합니다."
L["ErrorMessage.BugsSent"] = "%d개의 버그를 %s님에게 보냈습니다. 버그를 검사하려면 BugSack이 설치되어 있어야 합니다."
L["ErrorMessage.SendPrompt"] = "현재 표시된 세션(%d)의 모든 버그를 아래에 지정된 플레이어에게 보냅니다."
L["ErrorMessage.BugsReceived"] = "%s님으로부터 %d개의 버그를 받았습니다."

-- Options
L["Options.RestoreDefaults"] = "기본값 복원"
L["Options.RestoreDefaultsDesc"] = "모든 BugSack 설정을 기본값으로 복원합니다."
L["Options.EnablePopup"] = "자동 팝업"
L["Options.EnablePopupDesc"] = "오류가 발생하면 자동으로 BugSack을 열지만, 전투 중에는 열지 않습니다."
L["Options.EnablePrintMessages"] = "대화창 출력"
L["Options.EnablePrintMessagesDesc"] = "오류가 발생하면 대화창에 알림을 출력합니다. 전체 오류를 출력하지 않고 알림만 출력합니다!"
L["Options.EnableSoundEffects"] = "소리 효과 활성화"
L["Options.EnableSoundEffectsDesc"] = "버그를 감지했을 때 BugSack이 소리를 재생하도록 허용합니다."
L["Options.Sound"] = "소리"
L["Options.SoundPreview"] = "소리 미리듣기"
L["Options.UseMaster"] = "'주' 음성 채널 사용"
L["Options.UseMasterDesc"] = "선택한 오류 소리를 기본 음성 채널 대신 '주' 음성 채널을 통해 재생합니다."
L["Options.EraseBugs"] = "저장된 버그 지우기"
L["Options.EraseBugsDesc"] = "데이터베이스에 저장된 모든 버그를 박멸합니다."
L["Options.EnableMinimapButton"] = "미니맵 아이콘"
L["Options.EnableMinimapButtonDesc"] = "미니맵 주위에 BugSack 아이콘을 표시합니다."
L["Options.AddonCompartment"] = "애드온 보관함 아이콘"
L["Options.AddonCompartmentDesc"] = "'애드온 보관함'에 BugSack 메뉴 항목을 생성합니다."
L["Options.BugWindowFontSize"] = "버그 창 글꼴 크기"
L["Options.FontSize"] = "글꼴 크기"

-- Font sizes
L["FontSize.Small"] = "작게"
L["FontSize.Medium"] = "중간"
L["FontSize.Large"] = "크게"
L["FontSize.XLarge"] = "매우 크게"

-- Minimap
L["Minimap.Click"] = "클릭"
L["Minimap.ClickAction"] = "열기"
L["Minimap.RightClick"] = "오른쪽-클릭"
L["Minimap.RightClickAction"] = "옵션"
L["Minimap.MiddleClick"] = "가운데-클릭"
L["Minimap.MiddleClickAction"] = "소리 전환"
L["Minimap.ShiftClick"] = "Shift-클릭"
L["Minimap.ShiftClickAction"] = "인터페이스 새로고침"
L["Minimap.ShiftMiddleClick"] = "Shift-가운데 클릭"
L["Minimap.ShiftMiddleClickAction"] = "버그 지우기"

addon.L = L