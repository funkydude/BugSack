--[[

BugSack, a World of Warcraft addon that interfaces with the !BugGrabber addon
to present errors in a nice way.
Copyright (C) 2008 The BugSack Team.

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
if not BugSack then return end
local BugSack = BugSack

-- Suppress the default BugGrabber throttle output.
BUGGRABBER_SUPPRESS_THROTTLE_CHAT = true

local L = AceLibrary("AceLocale-2.2"):new("BugSack")

local paused = nil
local pauseCountDown = nil

BugSackFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0", "AceEvent-2.0")
local BugSackFu = BugSackFu

BugSackFu.hasIcon = true

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

	self.OnMenuRequest = options
	self.hasNoColor = true
	self.clickableTooltip = true
	self.hideWithoutStandby = true
	self.blizzardTooltip = true
	self.cannotDetachTooltip = true
end

function BugSackFu:OnEnable()
	paused = nil
	pauseCountDown = nil

	self:RegisterEvent("BugGrabber_CapturePaused")
	self:RegisterEvent("BugGrabber_CaptureResumed")

	self:Update()
end

local function countdown()
	if type(pauseCountDown) ~= "number" then
		pauseCountDown = BUGGRABBER_TIME_TO_RESUME or 10
	end
	if pauseCountDown > 0 then
		pauseCountDown = pauseCountDown - 1
	end
	BugSackFu:UpdateDisplay()
end

function BugSackFu:BugGrabber_CapturePaused()
	paused = true
	pauseCountDown = BUGGRABBER_TIME_TO_RESUME or 10
	self:ScheduleRepeatingEvent("bugGrabberPauseTimer", countdown, 1)
	self:UpdateDisplay()
end

function BugSackFu:BugGrabber_CaptureResumed()
	paused = nil
	self:CancelScheduledEvent("bugGrabberPauseTimer")
	pauseCountDown = nil
	self:UpdateDisplay()
end

function BugSackFu:Reset()
	self:SetIcon(true)
end

function BugSackFu:OnTextUpdate()
	if pauseCountDown then
		self:SetText(L["%d sec."]:format(pauseCountDown))
	else
		local e = BugSack:GetErrors("session")
		local count = e and #e or 0
		self:SetText(count)
		self:SetIcon(count == 0 and true or "Interface\\AddOns\\BugSack\\icon_red")
	end
end

function BugSackFu:OnClick()
	if pauseCountDown then return end

	if IsShiftKeyDown() then
		ReloadUI()
	elseif IsAltKeyDown() then
		BugSack:Reset()
	elseif BugSackFrame:IsShown() then
		BugSackFrame:Hide()
	else
		BugSack:ShowFrame("session")
	end
end

function BugSackFu:OnDoubleClick()
	if not pauseCountDown then return end
	BugGrabber:Resume()
end

do
	local pauseHint = L["|cffeda55fBugGrabber|r is paused due to an excessive amount of errors being generated. It will resume normal operations in |cffff0000%d|r seconds. |cffeda55fDouble-Click|r to resume now."]
	local hint = L["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."]
	local line = "%d. %s (x%d)"
	function BugSackFu:OnTooltipUpdate()
		local errs = BugSack:GetErrors("session")
		if not errs or #errs == 0 then
			GameTooltip:AddLine(L["You have no errors, yay!"])
		else
			GameTooltip:AddLine("BugSack")
			local pattern = "^(.-)\n"
			local counter = 1
			for i, err in ipairs(errs) do
				if not self.db.profile.filterAddonMistakes or (self.db.profile.filterAddonMistakes and err.type == "error") then
					local m = err.message
					if type(m) == "table" then m = table.concat(m, "") end
					m = select(3, m:find(pattern))
					GameTooltip:AddLine(line:format(counter, BugSack:ColorError(m), err.counter))
					counter = counter + 1
					if counter > 10 then break end
				end
			end
		end
		GameTooltip:AddLine(" ")
		if pauseCountDown then
			GameTooltip:AddLine(pauseHint:format(pauseCountDown), 0.2, 1, 0.2, 1)
		else
			GameTooltip:AddLine(hint, 0.2, 1, 0.2, 1)
		end
	end
end

-- vim:set ts=4:
