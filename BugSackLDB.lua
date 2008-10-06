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

if not BugSack then return end
local BugSack = BugSack

if not LibStub then return end
local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not ldb then return end

-- Suppress the default BugGrabber throttle output.
BUGGRABBER_SUPPRESS_THROTTLE_CHAT = true

local L = LibStub("AceLocale-3.0"):GetLocale("BugSack")
local dew = AceLibrary("Dewdrop-2.0")

local paused = nil
local pauseCountDown = nil

BugSackLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("BugSack", {
	type = "data source",
	text = "0",
	icon = "Interface\\AddOns\\BugSack\\Media\\icon",
})
local BugSackLDB = BugSackLDB

function BugSackLDB.OnClick(self, button)
	if button == "RightButton" then
		dew:Open(self,
			"children", function()
				dew:FeedAceOptionsTable(BugSack.options)
			end
		)
	else
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
end

-- Invoked from BugSack
function BugSackLDB:Update()
	local e = BugSack:GetErrors("session")
	local count = e and #e or 0
	self.text = count
	self.icon = count == 0 and "Interface\\AddOns\\BugSack\\Media\\icon" or "Interface\\AddOns\\BugSack\\Media\\icon_red"
end

--[[
local function countdown()
	if type(pauseCountDown) ~= "number" then
		pauseCountDown = BUGGRABBER_TIME_TO_RESUME or 10
	end
	if pauseCountDown > 0 then
		pauseCountDown = pauseCountDown - 1
	end
end

function BugSackFu:BugGrabber_CapturePaused()
	paused = true
	pauseCountDown = BUGGRABBER_TIME_TO_RESUME or 10
end

function BugSackFu:BugGrabber_CaptureResumed()
	paused = nil
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


function BugSackFu:OnDoubleClick()
	if not pauseCountDown then return end
	BugGrabber:Resume()
end
]]
do
	local pauseHint = L["|cffeda55fBugGrabber|r is paused due to an excessive amount of errors being generated. It will resume normal operations in |cffff0000%d|r seconds. |cffeda55fDouble-Click|r to resume now."]
	local hint = L["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."]
	local line = "%d. %s (x%d)"
	function BugSackLDB.OnTooltipShow(tt)
		local errs = BugSack:GetErrors("session")
		if not errs or #errs == 0 then
			tt:AddLine(L["You have no errors, yay!"])
		else
			tt:AddLine("BugSack")
			local pattern = "^(.-)\n"
			local counter = 1
			for i, err in ipairs(errs) do
				if not BugSack.db.profile.filterAddonMistakes or (BugSack.db.profile.filterAddonMistakes and err.type == "error") then
					local m = err.message
					if type(m) == "table" then m = table.concat(m, "") end
					m = select(3, m:find(pattern))
					tt:AddLine(line:format(counter, BugSack:ColorError(m), err.counter))
					counter = counter + 1
					if counter > 10 then break end
				end
			end
		end
		tt:AddLine(" ")
		if pauseCountDown then
			tt:AddLine(pauseHint:format(pauseCountDown), 0.2, 1, 0.2, 1)
		else
			tt:AddLine(hint, 0.2, 1, 0.2, 1)
		end
	end
end

--BugSackLDB:RegisterEvent("BugGrabber_CapturePaused")
--BugSackLDB:RegisterEvent("BugGrabber_CaptureResumed")

-- vim:set ts=4:
