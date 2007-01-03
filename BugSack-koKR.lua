-- 우리말 작업 - damjau
local L = AceLibrary("AceLocale-2.2"):new("BugSack")

L:RegisterTranslations("koKR", function()
	return {
		-- Bindings
		["Show Current Error"] = "현재 오류 메세지 표시",
		["Show Session Errors"] = "현 접속중 오류 메세지 표시",

		-- Command descriptions
		["Show sack"] = "자루 표시",
		["Show errors in the sack."] = "자루 안에 오류 메세지를 표시합니다",
		["Current error"] = "현재 오류",
		["Show the current error."] = "현재 발생한 오류 메세지를 표시합니다",
		["Current session"] = "현 접속",
		["Show errors from the current session."] = "현 접속중에 발생한 오류 메세지를 표시합니다",
		["Previous session"] = "이전 접속",
		["Show errors from the previous session."] = "이전 접속 중에 발생한 오류 메세지를 표시합니다",
		["By session number"] = "접속 횟수에 따라서",
		["Show errors by session number."] = "지정된 횟수의 접속 중에 발생한 오류 메세지를 표시합니다",
		["All errors"] = "모든 오류",
		["Show all errors."] = "모든 오류 메세지를 표시합니다",

		["List errors"] = "오류 목록",
		["List errors to the chat frame."] = "대화창에 오류 목록을 표시합니다",
		["List the current error."] = "현재발생한 오류 목록을 표시합니다",
		["List errors from the current session."] = "현재 접속중에 발생한 오류 목록을 표시합니다",
		["List errors from the previous session."] = "이전 접속중에 발생한 오류 목록을 표시합니다",
		["List errors by session number."] = "지정된 횟수의 접속중에 발생한 오류 목록을 표시합니다",
		["List all errors."] = "모든 오류 목록을 표시합니다",

		["Auto popup"] = "자동 표시",
		["Toggle auto BugSack frame popup."] = "벌레 자루 팝업창 자동 표시 기능을 토글합니다",
		["Chatframe output"] = "대화창 출력",
		["Print a warning to the chat frame when an error occurs."] = "오류 발생시에 대화창에 경고를 출력합니다",
		["Errors to chatframe"] = "대화창 오류 출력",
		["Print the full error message to the chat frame instead of just a warning."] = "오류 발생시에 대화창에 경고 대신에 오류 메세지 전체를 출력합니다",
		["Mute"] = "무음",
		["Toggle an audible warning everytime an error occurs."] = "오류가 발생할 시에 경고음 사용기능을 토글합니다",
		["Save errors"] = "오류 저장",
		["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = "SaveVariables\\!BugGrabber.lua 파일에 모든 오류를 저장할지 아닐지 토글합니다",
		["Limit"] = "제한",
		["Set the limit on the nr of errors saved."] = "저장된 오류의 갯수를 제한합니다",
		["Filter addon mistakes"] = "잘못된 애드온 필터",
		["Filters common mistakes that trigger the blocked/forbidden event."] = "막히고 금지된 이벤트를 일으키는 공통의 실수를 필터합니다" ,

		["Generate bug"] = "오류 생성",
		["Generate a fake bug for testing."] = "시험용으로 거짓 오류를 생성합니다",
		["Script bug"] = "스크립트 오류",
		["Generate a script bug."] = "스크립트 오류를 생성합니다",
		["Addon bug"] = "애드온 오류",
		["Generate an addon bug."] = "애드온 오류를 생성합니다",

		["Clear errors"] = "오류 삭제",
		["Clear out the errors database."] = "데이터베이스에 저장된 오류를 초기화합니다",

		-- Chat messages
		["You have no errors, yay!"] = "오류가 발생하지 않았습니다, 유훗~!",
		["List of errors:"] = "오류 목록:",
		["An error has been generated."] = "1개의 오류가 발생했습니다",
		["BugSack generated this fake error."] = "벌레자루가 이 거짓 오류를 생성해냈습니다",
		["All errors were wiped."] = "모든 오류가 삭제되었습니다",
		["An error has been recorded."] = "1개의 오류가 기록되었습니다",
		["%d errors have been recorded."] = "%d개의 오류가 기록되었습니다.",

		-- Frame messages,
		[" (... more ...)"] = " (... 이상 ...)",
		["No errors found"] = "오류를 찾을 수 없습니다",
		["Error %d of %d"] = "%d개의 오류 중 %d번째 오류",
		[" (viewing last error)"] = " (마지막 오류)",
		[" (viewing session errors)"] = " (현 접속중 발생한 오류)",
		[" (viewing previous session errors)"] = " (이전 접속중 발생한 오류)",
		[" (viewing all errors)"] = " (모든 오류)",
		[" (viewing errors for session %d)"] = " (%d번째 접속중 발생한 오류)",

		-- FuBar plugin
		["|cffeda55fClick|r to open the BugSack frame with the last error."] = "|cffeda55f클릭|r하여 벌래자루 창을 열어 마지막 오류를 볼 수 있습니다",
		["|cffeda55fShift-Click|r to Reload the UI"] = "|cffeda55fShift-클릭|r하여 UI를 재실행 할 수 있습니다",
	["|cffeda55fAlt-Click|r to Clear Errors"] = "|cffeda55fAlt 클릭|r하면 오류를 삭제합니다",
} end)

if GetLocale() == "koKR" then
	BugSackNextButton:SetText("다음")
	BugSackLastButton:SetText("마지막")
	BugSackPrevButton:SetText("이전")
	BugSackFirstButton:SetText("처음")
end
