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

local dupeCounter = 0

BugSackFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0", "AceEvent-2.0")
BugSackFu:RegisterDB("BugSackDB")
BugSackFu.hasNoColor = true
BugSackFu.clickableTooltip = true
BugSackFu.hasIcon = true
BugSackFu.hideWithoutStandby = true

function BugSackFu:OnEnable()
	dupeCounter = 0
	self:RegisterEvent("BugGrabber_BugGrabbedAgain", function()
		dupeCounter = dupeCounter + 1
		self:UpdateText()
	end)
end

function BugSackFu:Reset()
	dupeCounter = 0
end

function BugSackFu:OnTextUpdate()
	local errcount = #BugSack:GetErrors("session")
	if not errcount then errcount = 0 end
	if errcount > 0 or dupeCounter > 0 then
		self:SetText(tostring(errcount).."/"..tostring(dupeCounter + errcount))
	else
		self:SetText("")
	end
end

function BugSackFu:OnClick()
	if IsShiftKeyDown() then 
		ReloadUI()
	elseif IsAltKeyDown() then
		BugSack:Reset()
	else
		BugSack:ShowFrame("session")
	end
end

function BugSackFu:OnTooltipUpdate()
	local errs = BugSack:GetErrors("session")
	if #errs == 0 then
		local cat = Tablet:AddCategory("columns", 1)
		cat:AddLine("text", L["You have no errors, yay!"])
	else
		local cat = Tablet:AddCategory(
			"columns", 1,
			"justify", "LEFT",
			"hideBlankLine", true,
			"showWithoutChildren", false,
			"child_textR", 1,
			"child_textG", 1,
			"child_textB", 1
		)
		local output = "|cffffff00%d.|r |cff999999(x%d)|r %s"
		local pattern = ": (.-)\n"
		local counter = 0
		local i, err
		for i, err in ipairs(errs) do
			if not self.db.profile.filterAddonMistakes or (self.db.profile.filterAddonMistakes and err.type == "error") then
				cat:AddLine(
					"text", output:format(i, err.counter, BugSack:FormatError(err):gmatch(pattern)()),
					"func", BugSack.ShowFrame,
					"arg1", BugSack,
					"arg2", "session",
					"arg3", i
				)
				
				counter = counter + 1
				if counter == 5 then break end
			end
		end
	end

	Tablet:SetHint(L["|cffeda55fClick|r to open the BugSack frame with the last error."].."\n"..
	               L["|cffeda55fShift-Click|r to Reload the UI"].."\n"..
	               L["|cffeda55fAlt-Click|r to Clear Errors"])
end

function BugSackFu:OnMenuRequest()
	Dewdrop:FeedAceOptionsTable(BugSack:ReturnOptionsTable())
end

-- vim:set ts=4:
