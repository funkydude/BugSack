--
-- BugSackFu -- a FuBar button interface to the BugSack
--

--[[

BugSack, a World of Warcraft addon that interfaces with the !BugGrabber addon
to present errors in a nice way.
Copyright (C) 2007 The BugSack Team.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

]]

-- Only load if BugSack is already loaded
if not BugSack then
	return
end

local BugSack = BugSack
local BugGrabber = BugGrabber

-- Suppress the default BugGrabber throttle output.
BUGGRABBER_SUPPRESS_THROTTLE_CHAT = true

local L = AceLibrary("AceLocale-2.2"):new("BugSack")
local Tablet = AceLibrary("Tablet-2.0")
local Dewdrop = AceLibrary("Dewdrop-2.0")

local dupeCounter = 0
local paused = nil
local pauseCountDown = nil

BugSackFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0", "AceEvent-2.0")
local BugSackFu = BugSackFu

BugSackFu.hasNoColor = true
BugSackFu.clickableTooltip = true
BugSackFu.hasIcon = true
BugSackFu.hideWithoutStandby = true

function BugSackFu:OnInitialize()
	self:RegisterDB("BugSackDB")

	local args = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(self)
	local options = BugSack.options

	if not options.args[L["Menu"]] then
		options.args.menuSpacer = {
			type = "header",
			name = " ",
			order = 401,
		}
		options.args[L["Menu"]] = {
			type = "group",
			name = L["Menu"],
			desc = L["Menu options."],
			args = args,
			order = 402,
		}
	end

	self.OnMenuRequest = BugSack.options
end

function BugSackFu:OnEnable()
	dupeCounter = 0
	paused = nil
	pauseCountDown = nil

	self:RegisterEvent("BugGrabber_BugGrabbedAgain", function()
		dupeCounter = dupeCounter + 1
		self:UpdateText()
	end)
	self:RegisterEvent("BugGrabber_CapturePaused")
	self:RegisterEvent("BugGrabber_CaptureResumed")

	self:Update()
end

function BugSackFu:Countdown()
	if type(pauseCountDown) ~= "number" then
		pauseCountDown = BUGGRABBER_TIME_TO_RESUME or 10
	end
	if pauseCountDown > 0 then
		pauseCountDown = pauseCountDown - 1
	end
	self:UpdateDisplay()
end

function BugSackFu:BugGrabber_CapturePaused()
	paused = true
	pauseCountDown = BUGGRABBER_TIME_TO_RESUME or 10
	self:ScheduleRepeatingEvent("bugGrabberPauseTimer", self.Countdown, 1, self)
	self:UpdateDisplay()
end

function BugSackFu:BugGrabber_CaptureResumed()
	paused = nil
	self:CancelScheduledEvent("bugGrabberPauseTimer")
	pauseCountDown = nil
	self:UpdateDisplay()
end

function BugSackFu:Reset()
	dupeCounter = 0
	self:SetIcon(true)
end

function BugSackFu:OnTextUpdate()
	if pauseCountDown then
		self:SetText(string.format(L["%d sec."], pauseCountDown))
	else
		local errcount = #BugSack:GetErrors("session")
		if not errcount then errcount = 0 end
		self:SetText(tostring(errcount).."/"..tostring(dupeCounter + errcount))
		self:SetIcon(errcount == 0 and true or "Interface\\AddOns\\BugSack\\icon_red")
	end
end

function BugSackFu:OnClick()
	if pauseCountDown then return end

	if IsShiftKeyDown() then
		ReloadUI()
	elseif IsAltKeyDown() then
		BugSack:Reset()
	else
		BugSack:ShowFrame("session")
	end
end

function BugSackFu:OnDoubleClick()
	if not pauseCountDown or type(BugGrabber.Resume) ~= "function" then return end
	BugGrabber.Resume()
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
	if pauseCountDown then
		Tablet:SetHint(string.format(L["|cffeda55fBugGrabber|r is paused due to an excessive amount of errors being generated. It will resume normal operations in |cffff0000%d|r seconds. |cffeda55fDouble-Click|r to resume now."], pauseCountDown))
	else
		Tablet:SetHint(L["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."])
	end
end

-- vim:set ts=4:
