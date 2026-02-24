local addonName, addon = ...
if GetLocale() ~= "zhTW" then return end

local L = {}

-- General
L["General.AllBugs"] = "全部錯誤"
L["General.BugsExterminated"] = "所有儲存的錯誤已經被清除。"
L["General.CurrentSession"] = "這次"
L["General.Filter"] = "過濾"
L["General.Local"] = "本地 (%s)"
L["General.Next"] = "下一個 >"
L["General.Previous"] = "< 上一個"
L["General.PreviousSession"] = "上一次"
L["General.Send"] = "傳送"
L["General.SendBugs"] = "傳送錯誤"
L["General.SentBy"] = "由%s傳送(%s)"
L["General.Today"] = "今天"
L["General.NoBugs"] = "你沒有發生錯誤。\\^o^//"
L["General.BugInSoup"] = "在你的湯裡有一隻臭蟲啊！"
L["General.QuickTipsTitle"] = "快速提示"
L["General.QuickTipsDesc"] = "雙擊過濾錯誤報告。完成搜尋結果後，透過選擇底部的標籤返回完整匯總。點擊並拖動視窗。右擊關閉匯總並開啟 BugSack 介面選項。"

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack需要%s插件，你可以從你下載BugSack相同的地方來下載。獵蟲愉快!"
L["ErrorMessage.DeserializeFail"] = "從%s傳來的資料反序列化失敗。"
L["ErrorMessage.InvalidPlayer"] = "玩家需要有一個有效的名字。"
L["ErrorMessage.BugsSent"] = "%d個錯誤已經傳送給%s。他們必須有BugSack來查看錯誤訊息。"
L["ErrorMessage.SendPrompt"] = "傳送這次(%d)所有錯誤給以下玩家。"
L["ErrorMessage.BugsReceived"] = "從%s收到%d個錯誤。"

-- Options
L["Options.RestoreDefaults"] = "恢復預設"
L["Options.RestoreDefaultsDesc"] = "將所有 BugSack 設定恢復為預設值。"
L["Options.EnablePopup"] = "自動彈出"
L["Options.EnablePopupDesc"] = "當發生錯誤時自動開啟BugSack，但是不在戰鬥中開啟。"
L["Options.EnablePrintMessages"] = "聊天框架輸出"
L["Options.EnablePrintMessagesDesc"] = "當發生錯誤時輸出提醒到聊天框架。不是輸出所有錯誤，只是一個提醒！"
L["Options.EnableSoundEffects"] = "開啟聲音效果"
L["Options.EnableSoundEffectsDesc"] = "允許 BugSack 在檢測到錯誤時播放聲音。"
L["Options.Sound"] = "音效"
L["Options.SoundPreview"] = "試聽音效"
L["Options.UseMaster"] = "使用\"主\"聲道"
L["Options.UseMasterDesc"] = "使用主聲道而不是預設聲道播放選定的錯誤聲音。"
L["Options.EraseBugs"] = "清除儲存的錯誤"
L["Options.EraseBugsDesc"] = "清除資料庫中所有儲存的錯誤。"
L["Options.EnableMinimapButton"] = "小地圖圖示"
L["Options.EnableMinimapButtonDesc"] = "在小地圖四周顯示BugSack圖示。"
L["Options.AddonCompartment"] = "插件抽屜圖示"
L["Options.AddonCompartmentDesc"] = "在\"插件抽屜\"中為 BugSack 建立一個選單。"
L["Options.BugWindowFontSize"] = "錯誤視窗字型大小"
L["Options.FontSize"] = "字型大小"

-- Font sizes
L["FontSize.Small"] = "小"
L["FontSize.Medium"] = "中"
L["FontSize.Large"] = "大"
L["FontSize.XLarge"] = "超大"

-- Minimap
L["Minimap.Click"] = "點擊"
L["Minimap.ClickAction"] = "開啟"
L["Minimap.RightClick"] = "右擊"
L["Minimap.RightClickAction"] = "選項"
L["Minimap.MiddleClick"] = "中擊"
L["Minimap.MiddleClickAction"] = "切換聲音"
L["Minimap.ShiftClick"] = "Shift-點擊"
L["Minimap.ShiftClickAction"] = "重載介面"
L["Minimap.ShiftMiddleClick"] = "Shift-中擊"
L["Minimap.ShiftMiddleClickAction"] = "清除錯誤"

addon.L = L