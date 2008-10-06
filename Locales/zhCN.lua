--Chinese  Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
--Update by CWDG 月色狼影 and biggates
--CWDG site: http://Cwowaddon.com

local L = LibStub("AceLocale-3.0"):NewLocale("BugSack", "zhCN")
if not L then return end

-- Command descriptions
L["Show sack"] = "显示记录"
L["Show errors in the sack."] = "显示错误记录"
L["Current error"] = "当前错误"
L["Show the current error."] = "显示当前错误"
L["Current session"] = "当前进程"
L["Show errors from the current session."] = "显示当前进程错误"
L["Previous session"] = "上一进程"
L["Show errors from the previous session."] = "显示上一进程错误"
L["By session number"] = "进程数"
L["Show errors by session number."] = "根据进程错误数显示."
L["All errors"] = "全部错误"
L["Show all errors."] = "显示全部错误."
L["Received errors"] = "接收的错误"
L["Show errors received from another player."] = "显示收集到其他玩家的错误信息"
L["Send bugs"] = "发送错误"
L["Sends your current session bugs to another BugSack user."] = "发送你当前进程错误给其他玩家.只有在你和接收者都装有且加载了AceComm-2.0和BugSack的情况才能工作."
L["<player name>"] = "<玩家姓名>"
L["Menu"] = "目录"
L["Menu options."] = "目录设置"

L["List errors"] = "列举错误"
L["List errors to the chat frame."] = "在聊天框列出错误."
L["List the current error."] = "列出当前错误."
L["List errors from the current session."] = "列出当前进程错误."
L["List errors from the previous session."] = "列出上一进程错误"
L["List errors by session number."] = "列出进程错误数."
L["List all errors."] = "列出全部错误."
L["List errors received from another player."] = "列出从其他玩家接收到的错误"

L["Auto popup"] = "自动弹出"
L["Toggle auto BugSack frame popup."] = "遇到错误是否自动弹出 BugSack 窗口"
L["Chatframe output"] = "聊天栏输出"
L["Print a warning to the chat frame when an error occurs."] = "当发生错误的时,在聊天栏中显示."
L["Errors to chatframe"] = "错误到聊天栏"
L["Print the full error message to the chat frame instead of just a warning."] = "显示详细的错误信息到聊天栏中而非是一警告."
L["Mute"] = "静音"
L["Toggle an audible warning everytime an error occurs."] = "切换错误发生时发出警告声."
L["Sound"] = "音效"
L["What sound to play when an error occurs (Ctrl-Click to preview.)"] = "使用音效提示错误信息（Ctrl-点击预览声音效果。）"
L["Save errors"] = "保存错误"
L["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = "是否在 SavedVariables\\!BugGrabber.lua 文件中保存错误信息"
L["Limit"] = "限制"
L["Set the limit on the nr of errors saved."] = "设置错误保存限制"
L["Filter addon mistakes"] = "过滤插件错误"
L["Filters common mistakes that trigger the blocked/forbidden event."] = "过滤通常的错误,如阻止/禁止的事件."
L["Throttle at excessive amount"] = "过度错误数量过滤"
L["Whether to throttle for a default of 60 seconds when BugGrabber catches more than 20 errors per second."] = "当BugGrabbe捕获错误信息20次/秒,是否以默认值60秒频率过滤"

L["Generate bug"] = "模拟错误"
L["Generate a fake bug for testing."] = "模拟产生一个模拟错误进行测试."
L["Script bug"] = "脚本错误"
L["Generate a script bug."] = "模拟产生一个脚本错误."
L["Addon bug"] = "插件缺陷"
L["Generate an addon bug."] = "模拟产生一个插件缺陷."
L["Clear errors"] = "清除错误"
L["Clear out the errors database."] = "清除错误数据库."

L["%d sec."] = "%d秒"
L["|cffeda55fBugGrabber|r is paused due to an excessive amount of errors being generated. It will resume normal operations in |cffff0000%d|r seconds. |cffeda55fDouble-Click|r to resume now."] = "由于错误数量过量产生,所以|cffeda55fBugGrabber|r已暂停工作.它将在|cffff0000%d|r后重新开始正常运行.|cffeda55f双击|r直接重新开始. "
-- Chat messages
L["You have no errors, yay!"] = "没有发生错误, \\^o^/"
L["List of errors:"] = "错误列表"
L["An error has been generated."] = "所有错误均已生成."
L["BugSack generated this fake error."] = "这个错误是由 BugSack 产生的模拟错误."
L["All errors were wiped."] = "所有错误被清除."
L["An error has been recorded."] = "所有错误被记录."
L["%d errors have been recorded."] = "已记录 %d 个错误."
L["You've received %d errors from %s, you can show them with /bugsack show received."] = "你已从%d接收到%d个错误, 你可以通过输入/bugsack来显示."
L["%d errors has been sent to %s. He must have BugSack to be able to read them."] = "%d个错误已经发送给%s. 若他没有安装BugSack和AceComm-2.0这两个插件的话, 他将不能浏览错误信息."

-- Frame messages,
L[" (... more ...)"] = "(... 更多...)"
L["No errors found"] = "未发现错误"
L["Error %d of %d"] = "错误 %d/%d"
L[" (viewing last error)"] = " (查看最后一个错误)"
L[" (viewing session errors)"] = " (查看此次进程错误)"
L[" (viewing previous session errors)"] = " (查看上一进程错误)"
L[" (viewing all errors)"] = " (查看全部错误)"
L[" (viewing errors for session %d)"] = " (查看 \"%d\" 进程错误)"
L[" (viewing errors from %s)"] = "(查看%s的错误)"

-- FuBar plugin
L["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."] = "|cffeda55f点击|r打开BugSack及最后一错误信息. |cffeda55fShift-点击|r重新加载用户界面(和/console reloadui一样效果). |cffeda55fAlt-点击|r清除储存错误信息."

if GetLocale() == "zhCN" then
	BugSackNextButton:SetText("下一个")
	BugSackLastButton:SetText("最后")
	BugSackPrevButton:SetText("上一个")
	BugSackFirstButton:SetText("最初")
end
