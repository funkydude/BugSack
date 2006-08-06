--
-- BugSackFu -- a FuBar button interface to the BugSack
--

-- Only load if we can find FuBar2
if not FuBar2DB then
	return
end

local L = AceLibrary("AceLocale-2.0"):new("BugSack")

local Tablet = AceLibrary("Tablet-2.0")
local Dewdrop = AceLibrary("Dewdrop-2.0")

BugSackFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0")

function BugSackFu:OnInitialize()
	self:RegisterDB("BugSackDB")
	self.hasIcon = true
end

function BugSackFu:OnEnable()
	self:UpdateText()
	self:SetIcon(true)
end

function BugSackFu:OnTextUpdate()
	local errs = BugSack:GetNrErrors("session")
	if errs > 0 then
		self:SetText(tostring(errs))
	else
		self:SetText("")
	end
	self:SetIcon(true)
end

function BugSackFu:OnClick()
	BugSack:ShowFrame("current")
end

function BugSackFu:OnTooltipUpdate()
	Tablet:SetHint(L"Click to open the BugSack frame with the last error.")
	local cat = Tablet:AddCategory(
		"columns", 1,
		"child_textR", 1,
		"child_textG", 1,
		"child_textB", 1
	)

	local text = BugSack:GetErrors("session")
	if text then
		for line in string.gfind(text, "(.-)\n") do
			cat:AddLine("text", line)
		end
	else
		cat:AddLine(
			"text", L"You have no errors, yay!"
		)
	end
end

function BugSackFu:OnMenuRequest(level, value, x, valueN_1, valueN_2, valueN_3, valueN_4)
	Dewdrop:FeedAceOptionsTable(BugSack.optionsTable)
end

-- vim:set ts=4:
