local addonName, addon = ...
if GetLocale() ~= "zhCN" then return end

local L = {}

-- General
L["General.AllBugs"] = "全部错误"
L["General.BugsExterminated"] = "所有已保存的错误已经被清除。"
L["General.CurrentSession"] = "目前会话"
L["General.Filter"] = "过滤"
L["General.Local"] = "本地（%s）"
L["General.Next"] = "下一个>"
L["General.Previous"] = "<前一个"
L["General.PreviousSession"] = "上一次登录会话"
L["General.Send"] = "发送"
L["General.SendBugs"] = "发送错误"
L["General.SentBy"] = "%s发送（%s）"
L["General.Today"] = "今日"
L["General.NoBugs"] = "没有发生错误。\\^o^/"
L["General.BugInSoup"] = "这里有一个恶心的错误！"
L["General.QuickTipsTitle"] = "快速提示"
L["General.QuickTipsDesc"] = "双击过滤错误报告。完成搜索结果后，通过选择底部的选项卡返回完整汇总。点击并拖动窗口。右击关闭汇总并打开 BugSack 界面选项。"

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack 需要 %s 插件, 你可以从相同地方下载 BugSack。猎虫愉快！"
L["ErrorMessage.DeserializeFail"] = "反序列化失败输入数据来自 %s。"
L["ErrorMessage.InvalidPlayer"] = "玩家需要有一个有效的名字。"
L["ErrorMessage.BugsSent"] = "%d个错误已经发送给%s。他们必须安装 BugSack 插件才能查看错误信息。"
L["ErrorMessage.SendPrompt"] = "发送当前查看会话（%d）所有错误给下列玩家。"
L["ErrorMessage.BugsReceived"] = "你已从%s接收到%d个错误。"

-- Options
L["Options.RestoreDefaults"] = "恢复默认"
L["Options.RestoreDefaultsDesc"] = "将所有 BugSack 设置恢复为默认值。"
L["Options.EnablePopup"] = "自动弹出"
L["Options.EnablePopupDesc"] = "遇到错误是否自动弹出 BugSack 窗口。"
L["Options.EnablePrintMessages"] = "聊天栏输出"
L["Options.EnablePrintMessagesDesc"] = "当发生错误的时，在聊天栏中显示。不是整个错误，只是一个提醒！"
L["Options.EnableSoundEffects"] = "开启声音效果"
L["Options.EnableSoundEffectsDesc"] = "允许 BugSack 在检测到错误时播放声音。"
L["Options.Sound"] = "音效"
L["Options.SoundPreview"] = "试听音效"
L["Options.UseMaster"] = "使用\"主\"声道"
L["Options.UseMasterDesc"] = "通过\"主\"声道而不是默认声道播放所选的错误音效。"
L["Options.EraseBugs"] = "清除已保存错误"
L["Options.EraseBugsDesc"] = "清除数据库中所有已保存错误。"
L["Options.EnableMinimapButton"] = "小地图按钮"
L["Options.EnableMinimapButtonDesc"] = "在小地图周围显示 BugSack 图标。"
L["Options.AddonCompartment"] = "插件抽屉图标"
L["Options.AddonCompartmentDesc"] = "在\"插件抽屉\"中为 BugSack 创建一个菜单。"
L["Options.BugWindowFontSize"] = "错误窗口字体大小"
L["Options.FontSize"] = "字体尺寸"

-- Font sizes
L["FontSize.Small"] = "小"
L["FontSize.Medium"] = "中"
L["FontSize.Large"] = "大"
L["FontSize.XLarge"] = "超大"

-- Minimap
L["Minimap.Click"] = "点击"
L["Minimap.ClickAction"] = "打开"
L["Minimap.RightClick"] = "右击"
L["Minimap.RightClickAction"] = "选项"
L["Minimap.MiddleClick"] = "中击"
L["Minimap.MiddleClickAction"] = "切换声音"
L["Minimap.ShiftClick"] = "Shift-点击"
L["Minimap.ShiftClickAction"] = "重载界面"
L["Minimap.ShiftMiddleClick"] = "Shift-中击"
L["Minimap.ShiftMiddleClickAction"] = "清除错误"
L["Minimap.AltClick"] = "Alt-点击"
L["Minimap.AltClickAction"] = "擦除错误"

addon.L = L