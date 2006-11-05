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
BugSackFu:RegisterDB("BugSackDB")
BugSackFu.hasNoColor = true
BugSackFu.clickableTooltip = true
BugSackFu.hasIcon = true

function BugSackFu:OnTextUpdate()
	local errs = BugSack:GetErrors("session")
	if table.getn(errs) > 0 then
		self:SetText(tostring(table.getn(errs)))
	else
		self:SetText("")
	end
end

function BugSackFu:OnClick()
	BugSack:ShowFrame("session")
end

function BugSackFu:OnTooltipUpdate()
	local cat = Tablet:AddCategory(
		"columns", 1,
		"hideBlankLine", true,
		"showWithoutChildren", false,
		"child_textR", 1,
		"child_textG", 1,
		"child_textB", 1
	)

	local errs = BugSack:GetErrors("session")
	if table.getn(errs) == 0 then
		cat:AddLine("text", L["You have no errors, yay!"])
	else
		local output = "|cffffff00%d.|r |cffeda55f%s|r:|cff00ff00%s|r:%s"
		local pattern = ".*%]: (.-):(%d+):(.-)\n"
		for i, err in ipairs(errs) do
			cat:AddLine(
				"text", string.format(output, i, string_gmatch(err.message, pattern)()),
				"func", BugSack.ShowFrame,
				"arg1", BugSack,
				"arg2", "session",
				"arg3", i,
				"wrap", true
			)
			if i == 5 then break end
		end
	end

	Tablet:SetHint(L["Click to open the BugSack frame with the last error."])
end

function BugSackFu:OnMenuRequest()
	Dewdrop:FeedAceOptionsTable(BugSack:ReturnOptionsTable())
end

-- vim:set ts=4:
