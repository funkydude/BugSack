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
	local text
	local db = BugSack:GetDB()
	local f = 0
	for _, v in db do
		local _, _, ses = strfind(v, "-(.+)] ")
		if BugSack.db.profile.session == tonumber(ses) then
			f = f + 1
		end
	end
	if f > 0 then
		text = tostring(f)
	else
		text = ""
	end
	self:SetText(text)
	self:SetIcon(true)
end

function BugSackFu:OnClick()
	BugSack:ShowFrame("curr")
end

function BugSackFu:OnTooltipUpdate()
	Tablet:SetHint(L"Click to open the BugSack frame with the current error.")
	local cat = Tablet:AddCategory(
		"columns", 1,
		"child_textR", 1,
		"child_textG", 1,
		"child_textB", 1
	)

	local db = BugSack:GetDB()

	local f
	for _, v in db do
		local _, _, ses = strfind(v, "-(.+)] ")
		if BugSack.db.profile.session == tonumber(ses) then
			v = "- "..v
			cat:AddLine("text", v)
			f = true
		end
	end

	if not f then
		cat:AddLine(
			"text", L"You have no errors, yay!"
		)
	end
end

function BugSackFu:OnMenuRequest(level, value, x, valueN_1, valueN_2, valueN_3, valueN_4)
	Dewdrop:FeedAceOptionsTable(BugSack.optionsTable)
end

-- vim:set ts=4:
