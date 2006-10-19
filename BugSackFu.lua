--
-- BugSackFu -- a FuBar button interface to the BugSack
--

-- Only load if BugSack is already loaded
if not BugSack then
	return
end

local L = AceLibrary("AceLocale-2.2"):new("BugSack")

local Tablet = AceLibrary("Tablet-2.0")
local Dewdrop = AceLibrary("Dewdrop-2.0")

local string_gmatch = string.gmatch or string.gfind

BugSackFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0")
function BugSackFu:OnInitialize()
	self:RegisterDB("BugSackDB")
	self.hasIcon = true
	self.optionsTable = BugSack:ReturnOptionsTable()
end

function BugSackFu:OnEnable()
	self.isEnabled = true
	self:UpdateText()
	self:SetIcon(true)
end

function BugSackFu:OnTextUpdate()
	local errs = BugSack:GetErrors("session")
	if table.getn(errs) > 0 then
		self:SetText(tostring(table.getn(errs)))
	else
		self:SetText("")
	end
	self:SetIcon(true)
end

function BugSackFu:OnClick()
	BugSack:ShowFrame("session")
end

function BugSackFu:OnTooltipUpdate()
	Tablet:SetHint(L["Click to open the BugSack frame with the last error."])
	local cat = Tablet:AddCategory(
		"columns", 1,
		"child_textR", 1,
		"child_textG", 1,
		"child_textB", 1
	)

	local errs = BugSack:GetErrors("session")
	if table.getn(errs) == 0 then
		cat:AddLine("text", L["You have no errors, yay!"])
	else
		for i, err in ipairs(errs) do
			cat:AddLine(
				"text", string.format("%d. %s", i, string_gmatch(err.message, "(.-)\n")() ),
				"func", BugSack.ShowFrame,
				"arg1", BugSack,
				"arg2", "session",
				"arg3", i
			)
		end
	end
end

function BugSackFu:OnMenuRequest(level, value, x, valueN_1, valueN_2, valueN_3, valueN_4)
	Dewdrop:FeedAceOptionsTable(self.optionsTable)
end

-- vim:set ts=4:
